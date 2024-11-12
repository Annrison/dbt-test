{% macro get_methods_simple() %}
    {{ return(["bank_transfer", "credit_card", "gift_card"]) }}
{% endmacro %}