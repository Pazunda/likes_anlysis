select 
	round(avg(likes),2) as avg_likes,
    days
From (
    select 
            likes,
            EXTRACT('day' from (post_date - LAG(post_date) OVER (ORDER BY post_date))) AS days
        from ( 
         select 
            likes,
              TO_TIMESTAMP(date,'YYYY-MM-DD HH24-MI-SS') as post_date
          from  posts) t1 ) t2
group by days
order by days;

select  round((max(avg_likes) - min(avg_likes))/max(avg_likes)::decimal*100,2)
from(
  select 
      round(avg(likes),2) as avg_likes,
      days
  From (
      select 
              likes,
              EXTRACT('day' from (post_date - LAG(post_date) OVER (ORDER BY post_date))) AS days
          from ( 
           select 
              likes,
                TO_TIMESTAMP(date,'YYYY-MM-DD HH24-MI-SS') as post_date
            from  posts) t1 ) t2
  group by days ) t3


