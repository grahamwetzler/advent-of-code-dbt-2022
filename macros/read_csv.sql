{#- ✨ Magically ✨ reads the input file in based on the day. #}
{%- macro read_csv() -%}
read_csv('input/{{ this.name }}.csv', header=False, delim=False, columns={'input': 'text'})
{%- endmacro %}
