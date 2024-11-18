1. Explain the five main types of materializations in dbt.
2. Configure materializations in configuration files and in models.
3. Explain the differences and tradeoffs between tables, views, and ephemeral models.
4. Build intuition for incremental models.
5. Build intuition for snapshots.


# 1. what is materializations?

+ what is materializations?
    + `how` dbt process `models` and save result to database

+ what is model ?
    + `select` statements from sql file
    + usually not include `update` or `delete`
    + dbt read sql file to generate `DDL`/`DML` to create `table` or `view`
    + tips
        + `DDL`(Data Definition Language): define/modify table structure
        + `DML`(Data Manipulation Language): modify data, like inset, update or delete

+ materializations can be define in
    1. `dbt_project.yml` file
    2. top `config` part of sql file


## 5 type of materializations

1. table
    + re-create table every time excute the model
    + suits: small, not frequently modified statement
    + pros: inhance efficiency
    + cons: cost storage
    + `{{ config(materialized='view') }}`
2. view
    + excute `select` statement every time you excute model
    + suits: light, frequently modified statement
    + pros: save storage
    + cons: if statement is complex, it may cost a lot of
    + `{{ config(materialized='table') }}`
3. Ephemeral (CTE)
    + pass select statement, let other downstream model import as a CTE
    + suits: 
        + very light transformations
        + only use in one or two downstream models
        + ** don't need to query directly (it doesn't exist in database) **
    + pros: decrease storage loading for database
    + cons: may effect model efficiency if model is complex
    + `{{ config(materialized='ephemeral') }}`
    + tips
        + model `sales_data (A)` -> model `sales_summary (B)`
        + `A`: upstream model of `B`
        + `B`: downstream model of `A`
4. Incremental (insert)
    + look at an underlying data (source data), and only insert new data to another existing table
    + suits: needs of insert frequently increased data
    + pros: save time and resource to re-create table
    + cons: need to design the Incremental condition carefully
```
{{ config(materialized='incremental') }}

SELECT *
FROM source_table
{% if is_incremental() %}
WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}
```

5. snapshot (save changed data)
    + capture historical changes in mutable source data (e.g., Slowly Changing Dimensions)
    + takes periodic "snapshots" of a source table and records the data's state over time
    + suits: Scenarios where you need to maintain a history of changes in the source data (e.g., updated_at, status)
    + pros:
        + enables time-travel analysis by retaining historical states
        + supports Slowly Changing Dimensions (SCD Type 2) use cases
    + cons:
        + requires additional storage for historical records
        + potentially higher runtime costs for large datasets
        + complexity increases if business rules for capturing changes are ambiguous or frequently modified


# 2. Tables, views, and ephemeral models

+ in this section, we use model `fct_orders`, `dim_customers` for example
+ add the `--debug` in command to check the excuted sql

+ 1. Create Table

    1. change the config setting of `fct_orders.sql`

    ```
    {{ config(
        materialized='table'
    ) }}
    ```
    
    2. run the `fct_orders` and it's downstream model `dim_customers`

    ```
    dbt run -m fct_orders+ --debug
    ```
    + every time dbt re-create the table, it would be the following:
        1. create new `<table_name>__dbt_tmp` 
        2. rename original `<table_name>` to `<table_name>__dbt_backup`
        3. rename new `<table_name>__dbt_tmp` to `<table_name>`
        4. drop original `<table_name>__dbt_backup`


+ 2. Create View

    1. change the config setting of `fct_orders.sql`

        ```
        {{ config(
            materialized='view'
        ) }}
        ```

    2. run the `fct_orders` and it's downstream model `dim_customers`

        ```
        dbt run -m fct_orders+ --debug
        ```
        + if you turn view to table, it would be the following:
            1. create new view `<table_name>__dbt_tmp`
            2. rename original table to `<table_name>__dbt_backup`
            3. rename new view `<table_name>__dbt_tmp` to new view `<table_name>`
            4. drop original table `<table_name>__dbt_backup`

3. Ephemeral
    + it does not exist in the database
    + reusable code snippet
    + interpolated as CTE in a model that refs this model

    1. change the config setting of `fct_orders.sql`

        ```
        {{ config(
            materialized='ephemeral'
        ) }}
        ```

    2. delete the view `fct_orders`

    3. run the `fct_orders` and it's downstream model `dim_customers`

        ```
        dbt run -m fct_orders+ --debug
        ```
        + `fct_orders` model would not be run, cause it's a reusable code snippet
        + instead the sql in `fct_orders` would be added to `dim_customers` model
        + where is the view `fct_orders`?
            + after we delete view `fct_orders`, it doesn't appear again
            + if we didn't delete view `fct_orders`, dbt would simply ignored it


# 3. Incremental models

+ in this section, we use 
    1. model in `model/snowplow` for example
    2. `events` table in `dev` database, `jaffle_shop` schema

+ 1. Method 1: Insert Data after Latest Time

    1. have a look on `event` table
        + we would choose `collector_tstamp` column for time cut off
        + which means the time pipeline collected the data

    ```
    select * from jaffle_shop.events
    ```

    2. add the following code to `models/snowplow/stg_page_views_v1.sql`
        + if we don't add `is_incremental()`, model would fail for the first time cause `this` doesn't exist
        + since the model can't `ref()` to itself, use `this` argument

    ```
    {{ config(
        materialized = 'incremental'
    ) }}

    with events as (
        select * from {{ source('jaffle_shop', 'events') }}
        {% if is_incremental() %}
        where collector_tstamp >= (select max(max_collector_tstamp) from {{ this }})
        {% endif %}
    ),
    ```

    3. run the model for the first time, check the log (first time)
        + it would create table `stg_page_views_v1` at the first time

        ```
        dbt run -m stg_page_views_v1 --debug
        ```
    
    4. run the model for the first time, check the log (second time)
        + create tmp table `<table_name>__dbt_tmp<tmp_id>`
        + insert data of `<table_name>__dbt_tmp<tmp_id>` to official `<table_name>`

        ```
        dbt run -m stg_page_views_v1 --debug
        ```
    
    5. run the model in all refresh mode
        + it would create table like the first time running the model
        + it would fully refresh the whole table

        ```
        dbt run -m stg_page_views_v1 --full-refresh --debug
        ````

+ 2. Method 2: : Insert Data after (Latest Time – Time Period)

    1. add the following code to `models/snowplow/stg_page_views_v2.sql`
        + add `page_view_id` column as unique key for record
        + adjust the time cut off to 3 days before max `collector_tstamp`

    ```
    {{ config(
    materialized = 'incremental',
    unique_key = 'page_view_id'
    ) }}

    with events as (
        select * from {{ source('jaffle_shop', 'events') }}
        {% if is_incremental() %}
        where collector_tstamp >= (select max(collector_tstamp) - interval '3 days' from {{ this }})
        {% endif %}
    ),
    ```

    2. run the model for 2 times, check the log
        + first time it would create a table
        + second time
            + create tmp table `<table_name>__dbt_tmp<tmp_id>`
            + delete data in official table `<table_name>` which is also in `<table_name>__dbt_tmp<tmp_id>` (identified by `page_view_id`)
            + insert tmp data in `<table_name>__dbt_tmp<tmp_id>` to `<table_name>`
        + note that different database has different approch
        + set the cut off time from experiments

        ```
        dbt run -m stg_page_views_v2 --debug
        ```


# 4. What are snapshots?

+ in this section, we use sql in `snapshots` folder
+ we usually save snapshot in other schema, to let users know they are raw data which shouldn't be changed mamually
+ they should not be fully refresh
+ overall we recommand to set snapshot in `timestamp` mode, but if the updated_at is unstable, change to `check` mode

1. set snapshot by timestamp
    + in the beginning we define the snapshot name is `snap_products_ts`
    + set the `updated_at` column as the tracking timestamp column

    ```
    {% snapshot snap_products_ts %}

    {% set new_schema = target.schema + '_snapshot' %}

    {{
        config(
        target_database='postgres',
        target_schema=new_schema,
        unique_key='id',

        strategy='timestamp',
        updated_at='updated_at'
        )
    }}

    select * from {{ source('jaffle_shop', 'products') }}

    {% endsnapshot %}
    ```

    2. run dbt to build snapshot table

    ```
    dbt snapshot -s snap_products_ts --debug
    ```

    3. change data in `jaffle_shop.products`

    4. run the command again to check if the snapshot update

    + update the snapshot
    ```
    dbt snapshot -s snap_products_ts --debug
    ```

    + check the snapshot table in dbeaver
    ```
    select * from jaffle_shop_snapshot.snap_products_ts
    ```

2. set snapshot by checking columns
    
    1. change the `snapshots/snap_product_price.sql`
        + set the `price` column as the checking column
        + more than one column can be set as checking column

    ```
    {% snapshot snap_products_price %}

    {% set new_schema = target.schema + '_snapshot' %}

    {{
        config(
        target_database='postgres',
        target_schema=new_schema,
        unique_key='id',

        strategy='check',
        check_cols =['price']
        )
    }}

    select * from {{ source('jaffle_shop', 'products') }}

    {% endsnapshot %}
    ```

    2. run dbt to build snapshot table

    ```
    dbt snapshot -s snap_product_price --debug
    ```

    3. change data in `jaffle_shop.products`

    4. run the command again to check if the snapshot update

    + update the snapshot
    ```
    dbt snapshot -s snap_product_price --debug
    ```

    + check the snapshot table in dbeaver
    ```
    select * from jaffle_shop_snapshot.snap_products_price
    ```

