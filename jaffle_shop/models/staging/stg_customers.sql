-- stg_customers: 清理和標準化 customers 表數據

with raw_customers as (
    select
        id as customer_id,               -- 重命名 id 為 customer_id
        lower(first_name) as first_name, -- 將名字轉為小寫以標準化
        lower(last_name) as last_name    -- 將姓氏轉為小寫以標準化
    from {{ source('jaffle_shop', 'customers') }}  -- 引用原始表 customers
)

select *
from raw_customers
