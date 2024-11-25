-- this singular test tests the assumption that the amount column
-- of the orders model is always greater than 5.

select 
    amount 
from {{ ref('fct_orders') }}
where amount <= 5
