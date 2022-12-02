with input as (
  from read_csv_auto(
    'input/02.csv',
    delim=' ',
    columns={'opponent': 'text', 'you': 'text'}
  )
)

, outcomes as (
  from (values ('A', 'X', 'draw')
             , ('A', 'Y', 'win',)
             , ('A', 'Z', 'lose')
             , ('B', 'X', 'lose')
             , ('B', 'Y', 'draw')
             , ('B', 'Z', 'win',)
             , ('C', 'X', 'win',)
             , ('C', 'Y', 'lose')
             , ('C', 'Z', 'draw'))
     _ (opponent, you, result)
)

, score_outcomes as (
  from (values ('lose', 0)
             , ('draw', 3)
             , ('win',  6))
     _ (result, score_outcome)
)

, score_choices as (
  from (values ('X', 1)
             , ('Y', 2)
             , ('Z', 3))
     _ (you, score_choice)
)

, part_2_instructions as (
  from (values ('X', 'lose')
             , ('Y', 'draw')
             , ('Z', 'win'))
     _ (you, result)
)

, final_outcome as (
  select * exclude (score_outcome, score_choice)
       , score_outcome + score_choice as score
    from outcomes
    join score_outcomes
   using (result)
    join score_choices
   using (you)
)

, part_1 as (
  select 1 as part
       , sum(score) as answer
    from input
    join final_outcome
   using (opponent, you)
)

, part_2 as (
  select 2 as part
       , sum(score) as answer
    from input
    join part_2_instructions
   using (you)
    join final_outcome
   using (opponent, result)
    join score_choices
   using (you)
)

 from part_1
union all
 from part_2
