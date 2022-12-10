with instructions as (
  select row_number() over () as step
       , str_split(ins, ' ')[1] as instruction
       , str_split(ins, ' ')[2]::int as value
    from read_csv_auto('input/10.csv') _(ins)
)

, addx as (
  select *
    from instructions
   cross join range(1, 3) _(instruction_step)
   where instruction = 'addx'
   order by step
)

, steps as (
   from addx
  union all
  select *
       , 1 as instruction_step
    from instructions
   where instruction = 'noop'
   order by step
       , instruction_step
)

, run as (
select *
     , row_number() over () as cycle
     , sum(case
            when instruction_step = 1 and step = 1 then 1
            when instruction = 'addx' and instruction_step % 2 = 0 then value
           end) over (order by step, instruction_step) as x
  from steps
 order by cycle
)

, part_1 as (
  select cycle
       , cycle * lag(x) over (order by cycle) as signal_strength
    from run
)

select 1 as part
     , sum(signal_strength) as answer
  from part_1
 where cycle in (20, 60, 100, 140, 180, 220)
