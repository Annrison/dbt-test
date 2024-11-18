-- stg_payments: 中間處理模型，用於清理和標準化 payments 表的數據
with raw_payments as (
    select
        id as payment_id,                  -- 將 id 重命名為 payment_id
        order_id,                          -- 保留原始的 order_id
        lower(payment_method) as method,   -- 將 payment_method 全部轉換為小寫
        amount,                             -- 保留原始的 amount
        lower(status) as status
    from {{ source('jaffle_shop', 'payments') }}  -- 引用原始表 payments
)

select *
from raw_payments
