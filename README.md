# `dbt-test` Quickstart

[![Generic badge](https://img.shields.io/badge/dbt-1.8.8-blue.svg)](https://docs.getdbt.com/dbt-cli/cli-overview)
[![Generic badge](https://img.shields.io/badge/PostgreSQL-16-blue.svg)](https://www.postgresql.org/)
[![Generic badge](https://img.shields.io/badge/Python-3.11.10-blue.svg)](https://www.python.org/)
[![Generic badge](https://img.shields.io/badge/Podman-5.0.2-blue.svg)](https://www.docker.com/)

This is a `dbt-test` quickstart template, that supports PostgreSQL run with podman. This turtorial assumed viewer has basic DBT and Jinja knowledge. If not please have these lessons first.
  - [dbt-core-quickstart-template](https://github.com/saastoolset/dbt-core-quickstart-template)
  
  This `dbt-test` taken from the various [dbt Developer Hub](https://docs.getdbt.com/guides/using-jinja) and the infrastructure is based on [dbt-core-quickstart-template](https://github.com/saastoolset/dbt-core-quickstart-template), using `PostgreSQL` as the data warehouse. 

  If you have finished dbt-core-quickstart-template before, the infrastructure and architect we using here are total the same. That is to say, you can skip directly to [Step 3 Create a project​](#3-create-a-project)

- [Setup Steps](#setup-steps)
  - [1 Introduction​](#1-introduction)
  - [2 Create a repository and env prepare​](#2-create-a-repository-and-env-prepare)
  - [3 Create a project​](#3-create-a-project)
  - [4 Connect to PostgreSQL​](#4-connect-to-postgresql)


## material
+ for more info, you can check the ppt in `ppt` folder

# Setup Steps

## [1 Introduction​](https://docs.getdbt.com/guides/manual-install?step=1)

This template will develop and run dbt commands using the dbt Cloud CLI — a dbt Cloud powered command line with PostgreSQL.

- Prerequisites
  - Python/conda
  - Podman desktop
  - DBeaver
  - git client
  - visual code
  
  - ***Windows***: Path review for conda if VSCode have python runtime issue. Following path needs add and move to higher priority.

  ```
  C:\ProgramData\anaconda3\Scripts
  C:\ProgramData\anaconda3
  ```
  
- Create a GitHub account if you don't already have one.


## [2 Create a repository and env prepare​](https://docs.getdbt.com/guides/manual-install?step=2)

1. Create a new GitHub repository

- Find our Github template repository [dbt-core-quickstart-template](https://github.com/saastoolset/dbt-core-quickstart-template)
- Click the big green 'Use this template' button and 'Create a new repository'.
- Create a new GitHub repository named **dbt-core-qs-ex1**.

![Click use template](.github/static/use-template.gif)

2. Select Public so the repository can be shared with others. You can always make it private later.
2. Leave the default values for all other settings.
3. Click Create repository.
4. Save the commands from "…or create a new repository on the command line" to use later in Commit your changes.
5. Install and setup envrionment

- Create python virtual env for dbt
  - For venv and and docker, using the [installation instructions](https://docs.getdbt.com/docs/core/installation-overview) for your operating system.
  - For conda in **Mac**, open terminal as usual

    ```command
    (base) ~ % conda create -n jinja 
    (base) ~ % conda activate jinja
    ```
    
  - For conda in **Windows**, open conda prompt terminal in ***system administrador priviledge***

    ```command
    (base) C:> conda create -n dbt dbt-core dbt-postgres
    (base) C:> conda activate dbt
    ```
    
  - ***Windows***: create shortcut to taskbar
    - Find application shortcut location

    ![Start Menu](.github/static/FindApp.png)

    - Copy and rename shortcut to venv name
    - Change location parameter to venv name
    
    ![Change location parameter](.github/static/venv_name.png)

    - Pin the shortcut to Start Menu


- Start up db and pgadmin
  . use admin/Password as connection
  
  - ***Windows***:
    
    ```
    (dbt) C:> cd C:\Proj\myProject\50-GIT\dbt-core-qs-ex1
    (dbt) C:> bin\db-start-pg.bat
    ```
    
  - ***Mac***:
    
    ```
    (dbt) ~ % cd ~/Projects/dbt-macros-packages/
    (dbt) ~ % source ./bin/db-start-pg.sh
    (dbt) ~ % source ./bin/db-pgadm.sh
    ``` 

## [3 Create a project​](https://docs.getdbt.com/guides/manual-install?step=3)

Make sure you have dbt Core installed and check the version using the dbt --version command:

```
dbt --version
```

- Init project in repository home directory
  Initiate the jaffle_shop project using the init command:

```python
dbt init jaffle_shop
```

DBT will configure connection while initiating project, just follow the information below. After initialization, the configuration can be found in `profiles.yml`. For mac user, it can be found in `/Users/ann/.dbt/profiles.yml`

```YAML
jaffle_shop:
  outputs:
    dev:
      dbname: postgres
      host: localhost
      user: admin      
      pass: Passw0rd 
      port: 5432
      schema: jaffle_shop
      threads: 1
      type: postgres
  target: dev
```


Navigate into your project's directory:

```command
cd jaffle_shop
```

Use pwd to confirm that you are in the right spot:

```command
 pwd
```

Use a code editor VSCode to open the project directory

```command
(dbt) ~\Projects\jaffle_shop> code .
```
Let's remove models/example/ directory, we won't use any of it in this turtorial

## [4 Connect to PostgreSQL​](https://docs.getdbt.com/guides/manual-install?step=4)

1. Test connection config

```
dbt debug
``` 

2. Load sample data by csv
+ copy the csv file from `db` to `db/seeds`

**Windows**
```
copy ..\db\*.csv seeds
dbt seed
```

**Mac**
```
cp ../db/*.csv seeds
dbt seed
```
  
+ Verfiy result in database client, you should see 3 tables in `dev` database, `jaffle_shop` schema
  + customers
  + orders
  + products
+ note: 
  + if you can not find the tables created, check if the setting of database and schema is right
  + the database and schema are defined in `dbt_project.yml`
  + if database is not defined in `dbt_project.yml`, it would be the same as the database in `profiles.yml`




# Course




## 1. Introduciton to Advanced Testing
+ Learning Objectives
  + Explain the types of testing that are possible in dbt
  + Explain what makes a good test
  + Explain what to test and why
  + Ensure proper test coverage with `dbt_meta_testing` package
+ what is testing ?
  + select statement to select fail record, to assert model quality
  + ex: if you assume a column should be unique in the model, the test would select the duplicate records
+ what makes good testing ?
  + it should always running
  + it should be fast
  + include clues to fix error, like whick table/column to fix
  + every test should be independent
  + it should only validate 1 assumption
+ type of test ?
  1. data base object
    + assume something about data is true, like not null
  2. relationship
    + like if two joined model have the same size or key
  3. business logic
    + test example 
      + payments >= 0 for order data
      + billing data = sum of all parts
  4. freshness
    + test if new data is added in last X hours
    + ex: setting low and hight watermark of the data, if the data not updated within 24 hours, set a warning
  5. refactor
    + test if a model is the same after refactoring
+ 4 generic tests
  + unique, not null, relationship, accepted values

## 2. Test coverage and schema test

+ Learning objectives
  + Understand when in the life cycle of your project to run different types of tests
  + Run tests on subsets of your DAG using node selector syntax and test specific flags
  + How to take action on your test failures
  + Enable testing to store test failures in the database for record keeping

+ checking test coverage (schema test)
  + schema testing info are writed in `.yml`, as the same level of model sql

  1. download the [dbt_meta_testing](https://hub.getdbt.com/tnightengale/dbt_meta_testing/latest/) pkg 

    + add the following to the `packages.yml` file
    ```
    packages:
      - package: tnightengale/dbt_meta_testing
        version: 0.3.6
    ```

    + download pkg
    ```
    dbt deps
    ```

    + run the models again
    ```
    dbt run
    ```

  2. add the test setting to `dbt_project.yml`
    + tips
      + The `+required_tests` config must be `None` or a dict with `str` keys and `int` values
      + if you use dict format like `+required_tests:{"unique.*|not_null":2}` there should not be any whitespace, like `{"unique.*|not_null": 2 }` is not ok
    + what the setting means: 
      + all models in `models/core` should meet `required_tests` rules
      + test setting is define in `models/core/_core.yml`
      + each model should have 
        + `2` tests included `unique` or `not_null`
        + `1 relationship` test
    
    ```
    models:
      jaffle_shop:
        marts:
          core:
            +required_tests:
              "unique.*|not_null": 2
              "relationship.*": 1
            +materialized: table
        staging:
          +materialized: view
    ```

    + check the `_core.yml`, the following setting would run built in test `unique` and `not_null` on column `customer_id` on model `customers`

    ```
    - name: dim_customers # model name
      description: One record per customer
      columns:
        - name: customer_id
          description: Primary key
          data_tests:
            - unique
            - not_null
            - relationships:
                to: ref('stg_customers')
                field: customer_id
    ```

  3. run macro `required_tests`
    + `required_tests` is a bulit in test in `dbt_meta_testing` package
    + the detail of this macro is in `dbt_packages/dbt_meta_testing/macro/required_tests.sql`
    + if you define a `required_tests` in your macro folder, it would overwrite the built in macro when excuting the following code
    + only check if the setting of `dbt_project.yml` meet setting in `.yml` in `models` folder
    + you can add it in CI process # todo check official doc

    ```
    dbt run-operation required_tests
    ```

    + the log should be like this
    ```
    03:30:05  Checking `required_tests` config...
    03:30:05  Success. `required_tests` passed.
    ```
  
  4. comment on the following code, and run the test again, it should gives warning that some tests are missing

    + comment following code in `_core.yml` (coverage demo)
    ```
    # data_tests:
    #   - unique
    #   - not_null
    ```

    + run required_tests again
    ```
    dbt run-operation required_tests
    ```

    + the log should be like this
    ```
    Insufficient test coverage from the 'required_tests' config on the following models:
      - Model: 'dim_customers' Test: 'unique.*|not_null' Got: 0 Expected: 2
    ```

  5. ignore test setting in `dbt_project`
  + if you add following code to the top of model sql file, the model can ignore the tests
  + check `models/core/dim_customers_wo_check.sql`
  + delete `required_tests=None` , to see if it gives error

  ```
  -- config overwrite setting in dbt_project.yml, and this doesn't required tests
  {{ config(
    materialized='table', required_tests=None
  )}}
  ```
  ```
  dbt run-operation required_tests
  ```

## 3. How to run the test?

+ Overall test after developing
  + note that `dbt test` only test existing models, so you need to build models first then test the models

+ method 1 (more complete)
  + test the sources first, then run `models`, then run `tests` on models exclude sources
  + sources are defined in `.yml` in model folder, like `model/staging/schema.yml`
    + `dbt test -s "source:*"`
      + run test defined in `source` parameter, test on raw data, not `stage` data
      + [How do I run tests on just my sources?](https://docs.getdbt.com/faqs/Tests/testing-sources)
    + `dbt run`
      + run and build all models
      + [About dbt run command](https://docs.getdbt.com/reference/commands/run)
    + `dbt test --select <test_name>`: run test seperately
    + `dbt test --exclude sources:*`: run all tests except for tests under source
+ method 2 (faster)
  + `dbt build`
    + it will do
      + run models
      + test tests
      + snapshot snapshots
      + seed seeds
    + `--fail-fast`
      + if fail, stop the process
    + `--models state:modified+`
      + for only modified models and thier downstream models
      + base on version control file in `target/`
    + `--write-json`
      + generate `run_results.json`, `manifest.json` to save current model status in `target/`

+ test models seperately and save fail record
  
  1. open comment on `_core.yml` for `fct_orders` model (`save error demo`)
  ```  
  - name: customer_id
    description: id of customer
    # this test should failed
    data_tests:
      - unique
  ```

  2. run the test
    + it should give out the error message tells you that `29` records not pass the tests
    + test sql saved in `target/compiled/jaffle_shop/models/marts/core/_core.yml/unique_fct_orders_customer_id.sql`
    + if you paste the sql in the DBeaver, you can check the duplicate `customer_id` and their counts
    ```
    dbt test -s fct_orders
    ```

  3. run the test again but save failure to table
    + the log show that failure data is saved in `"postgres"."jaffle_shop_dbt_test__audit"."unique_fct_orders_customer_id"`
    
    ```
    dbt test -s fct_orders --store-failures
    ```

    + select the test result in DBeaver
      + the select result is the same as above
    ```
    select * from "postgres"."jaffle_shop_dbt_test__audit"."unique_fct_orders_customer_id"
    ```

## 4. Custome tests

+ singular test
  + `select` statement stored in `tests` folder
  + test specific model, return data that fail to meet the assumption
  + add a test sql `tests/fct_orders_amount_greater_than_five.sql` from `note_sql/`

  ```
  -- this singular test tests the assumption that the amount column
  -- of the orders model is always greater than 5.

  select 
      amount 
  from {{ ref('orders') }}
  where amount <= 5
  ```

  + run the tests
  + it will run all the test associate with `order` model, include
    + `schema test` defined in `_core.yml`
    + `singular test` defined in `tests` folder
  + result would shows that `FAIL 15`, means there're 15 records don't meet the assumption
  ```
  dbt test --select fct_orders
  ```

## 5. Generic Test

+ if a singular test is applied to more than one model, you can consider to turn it to a generic test to let it applied to multiple models
+ all built in dbt tests are generic tests
+ generic tests
  + can be written in
    + `tests/generic`
    + `macros/`
  + should have one or both standard arguments `model`, `column_name` 
+ the used model column is defined in `_core.yml`
+ see more info at [generic-tests-with-standard-arguments](https://docs.getdbt.com/best-practices/writing-custom-generic-tests#generic-tests-with-standard-arguments)


+ practice
  + 1. add test sql to `tests/generic/assert_column_greater_than_five.sql`
  ```
  -- this generic test tests the assumption that the column
  -- of the model_name is always greater than 5.

  {% test assert_column_greater_than_five(model, column_name) %}

  select
      {{ column_name }}
  from {{ model }}
  where {{ column_name }} <= 5

  {% endtest %}
  ```

  2. add the setting to `_core.yml` (`generic test demo`)
    + notice that the name defined in `data_tests` arguments should be as the same as test name in `tests/generic/assert_column_greater_than_five.sql`
      
    ```
    - name: amount
    description: Dollars spent per order
    data_tests:
      - assert_column_greater_than_five
    ```

  3. run the test again, it should be the same error
    ```
    dbt test --select fct_orders --store-failures
    ```

## 6. Overwriting Native Tests
  + some general tests are built in dbt core code, like `not_null` or `unique`
  + have a look on original sql, take my path as example
  ```
  cd ../../../env/dbt-course/lib/python3.13/site-packages/dbt/include/global_project/macros/generic_test_sql
  ```
  + `not_null.sql`
  ```
  {% macro default__test_not_null(model, column_name) %}

  {% set column_list = '*' if should_store_failures() else column_name %}

  select {{ column_list }}
  from {{ model }}
  where {{ column_name }} is null

  {% endmacro %}
  ```

  + practice
  1. open DBeaver, modify `amount` column of the first and second row to `NULL` in `fct_orders` table 
  2. run the tests, you will get 2 fail error for `not_null` test
    ```
    dbt test --select fct_orders --store-failures
    ``` 
  3. add a test `tests/generic/not_null.sql` from `note_sql/`
  ```
  -- this is the not_null test, with a mod!
  {% test not_null(model, column_name, column_id) %}

  select *
  from {{ model }}
  where {{ column_name }} is null
    and {{ column_id }} != 1

  {% endtest %}
  ```
  3. modified setting in `_core.yml`
    + open and comment on `overwriting demo` setting
    + note that a `column_id` variable is needed

    ```
    data_tests: 
      # open when overwriting demo
      - not_null:
          column_id: order_id
    ```

    + remember to comment on other test to prevent error
    ```
    - name: order_id
      description: Primary key for orders
      data_tests:
        - unique
        # - not_null # comment when overwriting demo
        - relationships:
            to: ref('stg_orders')
            field: order_id
    ```

  4. run the tests again, you will get only 1 fail error for `not_null` test, which means it skip the first row
    ```
    dbt test --select fct_orders --store-failures
    ```

## 7. Tests in packages

+ sometimes dbt test already exist in current packages

+ 1. how to use test from packages

    1. visit the package page on [hub.getdbt.com](hub.getdbt.com)
        + take [dbt_utils](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/) for example
    2. add packages you want to `packages.yml`
    3. install packages by
    ```
    dbt deps
    ```

  + dbt_utils
    + check the detail in `_core.yml`
      + you can check the detail in [expression_is_true](https://github.com/dbt-labs/dbt-utils/tree/1.3.0/#expression_is_true-source)
      + this test assume that the expression input is true for all rows
      + return rows which not meet the assumption
      + open the comment of `pkg demo` part

    ```
    # open when pkg demo
    data_tests:
      - dbt_utils.expression_is_true:
          expression: "amount >= 5"
    ```

    + run the test
    ```
    dbt test --select fct_orders
    ```
  
  + dbt_expectations
    + check the detail in `_core.yml`
      + you can check the detail in [expect_column_values_to_be_between](https://github.com/calogica/dbt-expectations/tree/0.10.4/#expect_column_values_to_be_between)
      + this test check if the rows is between two values
      + return rows which not meet the assumption
      + open the comment of `pkg demo` part
      ```
      # open when pkg demo
      data_tests:
        - dbt_expectations.expect_column_values_to_be_between:
            min_value: 5
            row_condition: "order_id is not null"
            strictly: True
      ```

## 8. Compare Models Differences

+ example shows that the pkg can be applied in `analyses` and `macros`

1. mismatch percentage of rows
  + add sql `models/marts/core/fct_orders_new.sql` from `note_sql/`
  + add sql `analyses/audit_helper_compare_relation.sql` from `note_sql/`
  + check the result
  ```
  dbt compile --select audit_helper_compare_relation
  ```
  + paste the compiled sql in DBeaver

2. mismatch percentage of rows for each column
  + check `macros/audit_helper_compare_column_values.sql`
  + run the macro, it would shows that the missing percentage of each column
  ```
  dbt run-operation audit_helper_compare_column_values
  ```










## related sources

+ [dbt course: advanced-test](https://learn.getdbt.com/courses/advanced-testing)
+ related github [learn-on-demand](https://github.com/coapacetic/learn-on-demand)
+ github issue
  + [how to write require_test setting](https://github.com/dbt-labs/dbt-core/issues/7660)

### Some other packages to consider
+ Python
  + [dbt-coverage](https://github.com/slidoapp/dbt-coverage): 
    + Compute coverage from catalog.json and manifest.json files found in a dbt project, e.g. jaffle_shop
  + [pre-commit-dbt](https://github.com/dbt-checkpoint/dbt-checkpoint)
    + A comprehensive list of hooks to ensure the quality of your dbt projects.
    + check-model-has-tests: Check the model has a number of tests.
    + check-source-has-tests-by-name: Check the source has a number of tests by test name.
    + See Enforcing rules at scale with pre-commit-dbt

+ dbt Packages
  + [dbt_dataquality](https://hub.getdbt.com/divergent-insights/dbt_dataquality/latest/)
    + Access and report on the outputs from dbt source freshness (sources.json and manifest.json) and dbt test (run_results.json and manifest.json)
    + Optionally tag tests and visualize quality by type
  + [dbt-project-evaluator](https://github.com/dbt-labs/dbt-project-evaluator)
    + This package highlights areas of a dbt project that are misaligned with dbt Labs' best practices. 

### when to run tests
+ [dbt Developer Blog: Enforcing rules at scale with pre-commit-dbt](https://docs.getdbt.com/blog/enforcing-rules-pre-commit-dbt)

+ helpful packages


+ dbt_utils
  + dbt_utils is a one-stop-shop for several key functions and tests that you’ll use every day in your project.
  + Here are some useful tests in dbt_utils:
    + expression_is_true
    + cardinality_equality
    + unique_where
    + not_null_where
    + not_null_proportion
    + unique_combination_of_columns

+ dbt_expectations
  + dbt_expectations contains a large number of tests that you may not find native to dbt or dbt_utils. If you are familiar with Python’s great_expectations, this package might be for you!
  + Here are some useful tests in dbt_expectations:
    + expect_column_values_to_be_between
    + expect_row_values_to_have_data_for_every_n_datepart
    + expect_column_values_to_be_within_n_moving_stdevs
    + expect_column_median_to_be_between
    + expect_column_values_to_match_regex_list
    + Expect_column_values_to_be_increasing

+ audit_helper
  + This package is utilized when you are making significant changes to your models, and you want to be sure the updates do not change the resulting data. The audit helper functions will only be run in the IDE, rather than a test performed in deployment.
  + Here are some useful tools in audit_helper:
    + compare_relations
    + compare_queries
    + compare_column_values
    + compare_relation_columns
    + compare_all_columns
    + compare_column_values_verbose















