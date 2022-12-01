with input as (
  from {{ ref("01-prep") }}
)

, calories_by_elf as (
  select elf
       , sum(calories) as calories
    from input
   group by 1
)

, top_3_elves as (
  select calories
    from calories_by_elf
   order by calories desc
   limit 3
)

 select 1 as part
     , max(calories) as answer
  from calories_by_elf
 union all
select 2 as part
     , sum(calories) as answer
  from top_3_elves
