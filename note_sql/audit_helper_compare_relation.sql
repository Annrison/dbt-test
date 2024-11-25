

{% set old_relation = ref('fct_orders') %}

{% set dbt_relation = ref('fct_orders_new') %}

{{ audit_helper.compare_relations(
    a_relation = old_relation,
    b_relation = dbt_relation,
    exclude_columns = ["load_at"],
    primary_key = "order_id"
) }}