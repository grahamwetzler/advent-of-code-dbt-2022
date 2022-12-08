/*
  Day 8: Treetop Tree House
  https://adventofcode.com/2022/day/8
*/

with grid as (
  select row_number() over () as row
       , str_split(row, '')::int[] as trees
    from read_csv('input/08.csv', columns={'row': 'text'})
)

, unnested as (
  select row
       , unnest(trees) as tree
    from grid
)

, trees as (
  select row
       , row_number() over (partition by row order by row) as col
       , tree
    from unnested
)

, part_1 as (
  select case
          when t.row = 1 or t.col = 1 then 1 /* edge */
          when t.row = max(t.row) over () or t.col = max(t.col) over () then 1 /* edge */
          when t.tree > (select max(tree) /* left */
                           from trees l
                          where t.row = l.row
                            and t.col > l.col) then 1
          when t.tree > (select max(tree) /* right */
                           from trees r
                          where t.row = r.row
                            and t.col < r.col) then 1
          when t.tree > (select max(tree) /* down */
                           from trees d
                          where t.col = d.col
                            and t.row < d.row) then 1
          when t.tree > (select max(tree) /* up */
                           from trees u
                          where t.col = u.col
                            and t.row > u.row) then 1
         end as visible
    from trees t
)

select 1 as part
     , sum(visible) as answer
  from part_1
