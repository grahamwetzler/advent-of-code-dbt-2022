{#- ✨ Magically ✨ reads the input file in based on the day. #}
{%- macro read_csv(columns={'input': 'text'}) -%}
read_csv('input/{{ this.name }}.csv', header=False, delim=False, columns={{ columns }})
{%- endmacro %}
