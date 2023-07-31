## Анализ влияния факторов на количество лайков постов на стене пользовтеля Вконтакте.
### Задача
### Возьмите свою страницу Вконтакте, соберите по ней таблицу с датой постов и количеством лайков и напишите SQL-запросы, которые позволят ответить на вопрос: что больше всего влияет на количество лайков: время суток публикации, день недели или промежуток между постами.

1. Получим данные о количестве дайков в постах для конкретного пользователя с помощью Python.
[файл Jupiter notebook](https://github.com/Pazunda/likes_anlysis/blob/725614fb02d287a54b1313e0d5ffd4f6847c1405/vk_posts.ipynb)
В итоге имеем таблицу в формате csv с двумя колонками: date - дата поста, likes - количество лайков.

3. Для того, чтобы оценить влияние дня недели публикации на количество лайков сделаем следующий запрос в SQL:
``` sql   
select 
       TO_CHAR(TO_TIMESTAMP(date,'YYYY-MM-DD HH24-MI-SS'), 'day') AS "post_day",
       ROUND(avg(likes),2) as avg_likes
 from posts
 group by post_day
```
Запрос группирует лайки по дням недели, вычисляет среднее количество в каждый день недели. Используя результат этого запроса в качестве источника для запроса 
```sql
select  round((max(avg_likes) - min(avg_likes))/max(avg_likes)::decimal*100,2)
from(
  ...
  ) AS t1
```
получим разницу  между самым большим и самым маленьким средним в процентах. Результат запроса - 36.62 %

3. Для того, чтобы оценить влияние времени суток сделаем следующий запрос:
```sql
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
```
Запрос разбивает сутки на четыре части и группирует лайки по этим периодам. Вычисляет среднее количество в каждый период. Используя результат этого запроса в качестве источника для запроса 
```sql
select  round((max(avg_likes) - min(avg_likes))/max(avg_likes)::decimal*100,2)
from(
  ...
  ) AS t1
```
получим разницу  между самым большим и самым маленьким средним в процентах. Результат запроса - 38.87 %

4. Для того, чтобы оценить влияние промежутка между постами  сделаем следующий запрос:
```sql
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
order by days
   ```
Запрос  вычисляет для каждого поста разницу во времени между ним и предыдущим. группирует лайки по количеству дней прошедших между предыдущим и текущим постом. Находит среднее значение для каждой доли. Используя результат этого запроса в качестве источника для запроса 
```sql
select  round((max(avg_likes) - min(avg_likes))/max(avg_likes)::decimal*100,2)
from(
  ...
  ) AS t1
```
получим разницу  между самым большим и самым маленьким средним в процентах. Результат запроса - 99.38 %

### Вывод:
На основе результатов расчета можно сделать вывод, что день недели сильнее влияет на воличество лайков, чем часть дня. Промежуток между постами дал саме большое различие между средними,однако, по моему мнению, на количество лайков влияют другие факторы(содержание поста, висел ли пост в закрепе и сколько). Они могут искажать картину.

   




