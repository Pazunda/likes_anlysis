select  round((max(avg_likes) - min(avg_likes))/max(avg_likes)::decimal*100,2)
from(
  select 
      CASE
          when date_part('hour',TO_TIMESTAMP(date,'YYYY-MM-DD HH24-MI-SS')) < 6 Then 'morning'
          when date_part('hour',TO_TIMESTAMP(date,'YYYY-MM-DD HH24-MI-SS')) >= 6 AND date_part('hour',TO_TIMESTAMP(date,'YYYY-MM-DD HH24-MI-SS')) < 12 Then 'day'
          when date_part('hour',TO_TIMESTAMP(date,'YYYY-MM-DD HH24-MI-SS')) >= 12 AND date_part('hour',TO_TIMESTAMP(date,'YYYY-MM-DD HH24-MI-SS')) < 18 Then 'evening'
          when date_part('hour',TO_TIMESTAMP(date,'YYYY-MM-DD HH24-MI-SS')) >= 18 Then 'night'
      end as day_part, 
       avg(likes) as avg_likes
  from posts
  group by day_part) t1;
  
  select 
      CASE
          when date_part('hour',TO_TIMESTAMP(date,'YYYY-MM-DD HH24-MI-SS')) < 6 Then 'morning'
          when date_part('hour',TO_TIMESTAMP(date,'YYYY-MM-DD HH24-MI-SS')) >= 6 AND date_part('hour',TO_TIMESTAMP(date,'YYYY-MM-DD HH24-MI-SS')) < 12 Then 'day'
          when date_part('hour',TO_TIMESTAMP(date,'YYYY-MM-DD HH24-MI-SS')) >= 12 AND date_part('hour',TO_TIMESTAMP(date,'YYYY-MM-DD HH24-MI-SS')) < 18 Then 'evening'
          when date_part('hour',TO_TIMESTAMP(date,'YYYY-MM-DD HH24-MI-SS')) >= 18 Then 'night'
          else 'sdf'
      end as day_part, 
       round(avg(likes),2) as avg_likes
  from posts
  group by day_part
