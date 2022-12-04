{% test test_answer(model, part, answer) %}
  select *
    from {{ model }}
   where not exists (
      select true
        from {{ model }}
       where part = {{ part }} and answer = {{ answer }}
   )
{% endtest %}
