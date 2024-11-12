{% macro get_methods_complex() %}

    {% set payment_methods_query %}
        select distinct
        payment_method
        from {{ ref('raw_payments') }}
        order by 1
    {% endset %}

    {% set results = run_query(payment_methods_query) %}

    -- We used the execute variable to ensure that 
    -- the code runs during the parse stage of dbt (otherwise an error would be thrown).
    {% if execute %}
        -- sql would return an Agate table, a Python Library class, to get the list would need to do more excution
        {# Return the first column #}
        {% set results_list = results.columns[0].values() %}
    {% else %}
        {% set results_list = [] %}
    {% endif %}

    {{ log(results_list, info=True) }}

    {{ return(results_list) }}

{% endmacro %}