SELECT
  {%- for key, cols in nested.items() %}
  {%- for col in cols %}
    {{ key }}:{{col}}::{{ cols[col]["type"].lower() }} AS {{ cols[col]["id"] }}{% if not loop.last or columns %},{% endif %}
  {%- endfor %}
  {%- endfor %}
  {%- for col in columns %}
    {{col['name']}}::{{ col["type"].lower() }} AS {{ col['id'] }}{% if not loop.last %},{% endif %}
  {%- endfor %}
FROM {% raw %}{{{% endraw %} source('{{ relation.schema }}', '{{ relation.name }}') {% raw %}}}{% endraw %}