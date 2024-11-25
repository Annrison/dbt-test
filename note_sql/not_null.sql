-- this is the not_null test, with a mod!
{% test not_null(model, column_name, column_id) %}

select *
from {{ model }}
where {{ column_name }} is null
and {{ column_id }} != 1

{% endtest %}