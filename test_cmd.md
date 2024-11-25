
09:46:29  2 of 5 START test fct_orders_amount_greater_than_five .......................... [RUN]
09:46:29  2 of 5 FAIL 15 fct_orders_amount_greater_than_five ............................. [FAIL 15 in 0.09s]

09:46:29  4 of 5 START test relationships_fct_orders_order_id__order_id__ref_stg_orders_ . [RUN]
09:46:29  4 of 5 PASS relationships_fct_orders_order_id__order_id__ref_stg_orders_ ....... [PASS in 0.05s]


09:46:29  3 of 5 START test not_null_fct_orders_order_id ................................. [RUN]
09:46:29  3 of 5 PASS not_null_fct_orders_order_id ....................................... [PASS in 0.05s]

# This is a long list of potential testing commands!

## run all tests
dbt test

## run tests for one_specific_model
dbt test --select one_specific_model
dbt test --select customers orders

## run tests for all models in a subfolder (i.e. marts/core)
dbt test --select marts.core.*

## run tests for all models in package
dbt test --select some_package.*
# note: we do not currently have any packages installed that do have tests

## run only tests defined singularly
dbt test --select test_type:singular

## run only tests defined generically
dbt test --select test_type:generic

## run singular tests limited to one_specific_model
dbt test --select one_specific_model, test_type:singular
dbt test --select orders, test_type:singular

## run generic tests limited to one_specific_model
dbt test --select one_specific_model, test_type:generic
dbt test --select customers, test_type:generic

## run only source tests
dbt test --select source:*

## run tests on your dbt models
dbt test --select models
