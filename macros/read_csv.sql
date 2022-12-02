{#- ✨ Magically ✨ reads the input file in based on the day. #}
{%- macro read_csv(delim="False", columns="{'input': 'text'}") -%}
read_csv('input/{{ this.name }}.csv', header=False, delim={{ delim }}, columns={{ columns }})
{%- endmacro %}
