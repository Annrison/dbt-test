{% snapshot snap_products_price %}

-- table name of snapshot

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