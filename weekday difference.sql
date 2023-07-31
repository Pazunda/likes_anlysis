 select 
       TO_CHAR(TO_TIMESTAMP(date,'YYYY-MM-DD HH24-MI-SS'), 'day') AS "post_day",
       ROUND(avg(likes),2) as avg_likes
 from posts
 group by post_day;
 
 select round((max(avg_likes) - min(avg_likes))/max(avg_likes)::decimal*100,2)
from (
  select 
       to_char(TO_TIMESTAMP(date,'YYYY-MM-DD HH24-MI-SS'), 'day') AS "post_day",
       avg(likes) as avg_likes
  from posts
  group by post_day) t1 