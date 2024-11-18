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