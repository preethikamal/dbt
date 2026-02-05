{% macro unnest_query(root_alias, columns) %}
    {% for column in columns %}
        {% if loop.first %}
            {% set parent = root_alias %}
        {% else %}
            {# Adding spaces around the minus sign fixes the 'expected :' error #}
            {% set parent = columns[loop.index0 - 1] %}
        {% endif %}
        
        {# We alias the unnest as the column name so you can select from it #}
        LEFT JOIN UNNEST({{ parent }}.{{ column }}) AS {{ column }}
    {% endfor %}
{% endmacro %}