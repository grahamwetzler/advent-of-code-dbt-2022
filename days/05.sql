/*
  Day 5: Supply Stacks
  https://adventofcode.com/2022/day/5
*/

{%- set stacks = 9 -%}

{%- set stack_columns -%}
  {%- for stack in range(1, stacks + 1) -%}
    stack_{{ stack }}{%- if not loop.last %}, {% endif -%}
  {%- endfor -%}
{%- endset -%}

with recursive stacks as (
  select regexp_replace(columns(*), '[\[\]]', '', 'g') as stack
    from read_csv_auto('input/05-1.csv', delim=',', nullstr='   ')
)

, instructions as (
  select row_number() over () as step
       , string_split_regex(instruction[6:], '( from | to )')::int[] as instructions
       , instructions[1] as move_n
       , instructions[2] as move_from
       , instructions[3] as move_to
    from read_csv_auto('input/05-2.csv') tbl(instruction)
)

, stacks_str({{ stack_columns }}) as (
  select trim(reverse(string_agg(columns(*), '')))
    from stacks
)

, stacks_list as (
  select [{%- for stack in range(1, stacks + 1) %}
           stack_{{ stack }},
          {%- endfor %}] as stacks
    from stacks_str
)

, move(step, part_1, part_2) as (
  select 0 as step
       , stacks as part_1
       , stacks as part_2
    from stacks_list

   union all

  select r.step + 1 as step
       , [{%- for stack in range(1, stacks + 1) %}
           case
            when move_from = {{ stack }}
              then part_1[{{ stack }}][:move_n * -1]
            when move_to = {{ stack }}
              then part_1[{{ stack }}] || reverse(right(part_1[move_from], move_n))
              else part_1[{{ stack }}]
           end,
         {%- endfor %}
         ] as part_1
       , [{%- for stack in range(1, stacks + 1) %}
           case
            when move_from = {{ stack }}
              then part_2[{{ stack }}][:move_n * -1]
            when move_to = {{ stack }}
              then part_2[{{ stack }}] || right(part_2[move_from], move_n)
              else part_2[{{ stack }}]
           end,
         {%- endfor %}
         ] as part_2
    from move r
    join instructions i
      on i.step = r.step + 1
)

, answers as (
  select unnest(list_apply(part_1, x -> x[-1])) as part_1
       , unnest(list_apply(part_2, x -> x[-1])) as part_2
    from move
 qualify row_number() over (order by step desc) = 1
)

select 1 as part
     , string_agg(part_1, '') as answer
  from answers
 union all
select 2 as part
     , string_agg(part_2, '') as answer
  from answers
