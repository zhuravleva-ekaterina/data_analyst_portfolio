-- Проект "Продвинутый SQL" (Яндекс.Практикум) --

Описание проекта:
В данном проекте буду работать с базой данныхStackOverflow — сервиса вопросов и ответов о программировании. 
StackOverflow похож на социальную сеть — пользователи сервиса задают вопросы, отвечают на посты, оставляют комментарии и ставят оценки другим ответам.. 
Состоит из двух частей на 20 задач на составление запросов к базе данных (PostgreSQL) StackOverFlow за 2008 год.
Более сложные задания находятся в конце файла.


/* Задание 1.
Найдите количество вопросов, которые набрали больше 300 очков или как минимум 100 раз были добавлены в «Закладки».*/

SELECT COUNT(*)
FROM stackoverflow.post_types pt
LEFT JOIN stackoverflow.posts p ON pt.id=p.post_type_id
WHERE (type = 'Question') AND score >300 OR favorites_count >= 100


/* Задание 2.
Сколько в среднем в день задавали вопросов с 1 по 18 ноября 2008 включительно? Результат округлите до целого числа.*/

WITH a AS
  (SELECT COUNT(p.id) AS count_
   FROM stackoverflow.post_types pt
   LEFT JOIN stackoverflow.posts p ON pt.id=p.post_type_id
   WHERE TYPE = 'Question'
     AND p.creation_date::date BETWEEN '2008-11-01' AND '2008-11-18'
   GROUP BY DATE_TRUNC('day', p.creation_date)::date)
SELECT ROUND(AVG(count_))
FROM a


/* Задание 3.
Сколько пользователей получили значки сразу в день регистрации? Выведите количество уникальных пользователей.*/

SELECT COUNT(DISTINCT u.id)
FROM stackoverflow.users u
JOIN stackoverflow.badges bd ON u.id=bd.user_id
WHERE bd.creation_date::date = u.creation_date::date


/* Задание 4.
Сколько уникальных постов пользователя с именем Joel Coehoorn получили хотя бы один голос?*/

SELECT COUNT(*)
FROM
  (SELECT p.id
   FROM stackoverflow.posts p
   JOIN stackoverflow.votes v ON p.id=v.post_id
   JOIN stackoverflow.users u ON u.id=p.user_id
   WHERE display_name = 'Joel Coehoorn'
     AND v.id IS NOT NULL
   GROUP BY p.id) a
   

/* Задание 5.
Выгрузите все поля таблицы vote_types. Добавьте к таблице поле rank, в которое войдут номера записей в обратном порядке. 
Таблица должна быть отсортирована по полю id.*/

SELECT *,
       RANK() OVER (
                    ORDER BY id DESC)
FROM stackoverflow.vote_types
ORDER BY id
   

/* Задание 6.
Отберите 10 пользователей, которые поставили больше всего голосов типа Close. 
Отобразите таблицу из двух полей: идентификатором пользователя и количеством голосов. 
Отсортируйте данные сначала по убыванию количества голосов, потом по убыванию значения идентификатора пользователя.*/

WITH a AS
  (SELECT v.id AS id_votes,
          vt.name,
          v.post_id,
          v.user_id
   FROM stackoverflow.vote_types vt
   JOIN stackoverflow.votes v ON vt.id=v.vote_type_id
   WHERE vt.name = 'Close')
SELECT user_id,
       COUNT(id_votes) AS count_
FROM a
GROUP BY user_id
ORDER BY count_ DESC,
         user_id DESC
LIMIT 10
  

/* Задание 7.
Отберите 10 пользователей по количеству значков, полученных в период с 15 ноября по 15 декабря 2008 года включительно.
Отобразите несколько полей:
 - идентификатор пользователя;
 - число значков;
 - место в рейтинге — чем больше значков, тем выше рейтинг.
Пользователям, которые набрали одинаковое количество значков, присвойте одно и то же место в рейтинге.
Отсортируйте записи по количеству значков по убыванию, а затем по возрастанию значения идентификатора пользователя.*/

WITH a AS
  (SELECT bd.user_id,
          bd.id
   FROM stackoverflow.badges bd
   JOIN stackoverflow.users u ON u.id=bd.user_id
   WHERE bd.creation_date::date BETWEEN '2008-11-15' AND '2008-12-15'),
     b AS
  (SELECT user_id,
          COUNT(id) AS count_id
   FROM a
   GROUP BY user_id
   ORDER BY count_id DESC, user_id ASC
   LIMIT 10)
SELECT user_id,
       count_id,
       DENSE_RANK() OVER (
                          ORDER BY count_id DESC) AS rang
FROM b


/* Задание 8.
Сколько в среднем очков получает пост каждого пользователя?
Сформируйте таблицу из следующих полей:
 - заголовок поста;
 - идентификатор пользователя;
 - число очков поста;
 - среднее число очков пользователя за пост, округлённое до целого числа.
Не учитывайте посты без заголовка, а также те, что набрали ноль очков.*/

WITH a AS
  (SELECT title,
          user_id,
          score,
          AVG(score) OVER (PARTITION BY user_id) AS avg_score
   FROM stackoverflow.posts
   WHERE title IS NOT NULL
     AND score != 0)
SELECT title,
       user_id,
       score,
       ROUND(avg_score)
FROM a


/* Задание 9.
Отобразите заголовки постов, которые были написаны пользователями, получившими более 1000 значков. 
Посты без заголовков не должны попасть в список.*/

SELECT p.title
FROM stackoverflow.posts p
WHERE p.user_id IN
    (SELECT bd.user_id
     FROM stackoverflow.badges bd
     GROUP BY bd.user_id
     HAVING COUNT(bd.id)> 1000)
  AND p.title IS NOT NULL
  
  
/* Задание 10.
Напишите запрос, который выгрузит данные о пользователях из США (англ. United States). 
Разделите пользователей на три группы в зависимости от количества просмотров их профилей:
 - пользователям с числом просмотров больше либо равным 350 присвойте группу 1;
 - пользователям с числом просмотров меньше 350, но больше либо равно 100 — группу 2;
 - пользователям с числом просмотров меньше 100 — группу 3.
Отобразите в итоговой таблице идентификатор пользователя, количество просмотров профиля и группу. 
Пользователи с нулевым количеством просмотров не должны войти в итоговую таблицу.*/

SELECT id,
       VIEWS,
       CASE
           WHEN VIEWS < 100 THEN 3
           WHEN VIEWS >= 100
                AND VIEWS < 350 THEN 2
           WHEN VIEWS >= 350 THEN 1
       END
FROM stackoverflow.users
WHERE LOCATION LIKE '%United States%'
  AND VIEWS != 0


/* Задание 11.
Дополните предыдущий запрос. Отобразите лидеров каждой группы — пользователей, которые набрали максимальное число просмотров в своей группе.
Выведите поля с идентификатором пользователя, группой и количеством просмотров.
Отсортируйте таблицу по убыванию просмотров, а затем по возрастанию значения идентификатора.*/

WITH b AS
  (SELECT id,
          VIEWS,
          group_views,
          MAX(VIEWS) OVER (PARTITION BY group_views) AS max_view
   FROM
     (SELECT id,
             VIEWS,
             CASE
                 WHEN VIEWS < 100 THEN 3
                 WHEN VIEWS >= 100
                      AND VIEWS < 350 THEN 2
                 WHEN VIEWS >= 350 THEN 1
             END AS group_views
      FROM stackoverflow.users
      WHERE LOCATION LIKE '%United States%'
        AND VIEWS != 0) a)
SELECT id,
       group_views,
       VIEWS
FROM b
WHERE VIEWS = max_view
ORDER BY VIEWS DESC, id


/* Задание 12.
Посчитайте ежедневный прирост новых пользователей в ноябре 2008 года. Сформируйте таблицу с полями:
 - номер дня;
 - число пользователей, зарегистрированных в этот день;
 - сумму пользователей с накоплением.*/
 
 WITH a AS
  (SELECT EXTRACT(DAY
                  FROM creation_date::timestamp) AS day_nom,
          COUNT(id) AS count_id
   FROM stackoverflow.users
   WHERE creation_date::date BETWEEN '2008-11-01' AND '2008-11-30'
   GROUP BY day_nom
   ORDER BY day_nom)
SELECT *,
       SUM(count_id) OVER (
                           ORDER BY day_nom)
FROM a


/* Задание 13.
Для каждого пользователя, который написал хотя бы один пост, найдите интервал между регистрацией и временем создания первого поста. 
Отобразите:
- идентификатор пользователя;
- разницу во времени между регистрацией и первым постом.*/

WITH a AS
  (SELECT p.user_id,
          MIN(creation_date) OVER (PARTITION BY p.user_id) AS min_dt
   FROM stackoverflow.posts p)
SELECT a.user_id,
       min_dt - u.creation_date AS ab
FROM a
JOIN stackoverflow.users u ON u.id=a.user_id
GROUP BY a.user_id,
         ab


ЧАСТЬ 2.

/* Задание 1.
Выведите общую сумму просмотров постов за каждый месяц 2008 года. 
Если данных за какой-либо месяц в базе нет, такой месяц можно пропустить. 
Результат отсортируйте по убыванию общего количества просмотров.*/

SELECT DATE_TRUNC('month', creation_date)::date AS month_post,
       SUM(views_count)
FROM stackoverflow.posts
WHERE EXTRACT(YEAR
              FROM creation_date::timestamp) = 2008
GROUP BY month_post
ORDER BY SUM(views_count) DESC


/* Задание 2.
Выведите имена самых активных пользователей, которые в первый месяц после регистрации (включая день регистрации) дали больше 100 ответов. 
Вопросы, которые задавали пользователи, не учитывайте. Для каждого имени пользователя выведите количество уникальных значений user_id. 
Отсортируйте результат по полю с именами в лексикографическом порядке.*/

SELECT u.display_name,
       COUNT(DISTINCT p.user_id)
FROM stackoverflow.posts p
JOIN stackoverflow.users u ON u.id=p.user_id
JOIN stackoverflow.post_types pt ON pt.id=p.post_type_id
WHERE pt.type = 'Answer'
  AND p.creation_date::date BETWEEN u.creation_date::date AND (u.creation_date::date + INTERVAL '1 month')
GROUP BY u.display_name
HAVING COUNT(DISTINCT p.id) > 100
ORDER BY u.display_name


/* Задание 3.
Выведите количество постов за 2008 год по месяцам. 
Отберите посты от пользователей, которые зарегистрировались в сентябре 2008 года и сделали хотя бы один пост в декабре того же года. 
Отсортируйте таблицу по значению месяца по убыванию.*/

SELECT DATE_TRUNC('month', p.creation_date)::date month_post,
       COUNT(p.id) AS count_post
FROM stackoverflow.users u
JOIN stackoverflow.posts p ON u.id=p.user_id
WHERE p.user_id IN
    (SELECT p.user_id
     FROM stackoverflow.users u
     JOIN stackoverflow.posts p ON u.id=p.user_id
     WHERE EXTRACT(MONTH
                   FROM u.creation_date::timestamp) = 9
       AND EXTRACT(YEAR
                   FROM u.creation_date::timestamp) = 2008
       AND DATE_TRUNC('month', p.creation_date)::date BETWEEN '2008-12-01' AND '2008-12-31' )
  AND EXTRACT(YEAR
              FROM u.creation_date::timestamp) = 2008
GROUP BY month_post
ORDER BY month_post DESC


/* Задание 4.
Используя данные о постах, выведите несколько полей:
- идентификатор пользователя, который написал пост;
- дата создания поста;
- количество просмотров у текущего поста;
- сумму просмотров постов автора с накоплением.
Данные в таблице должны быть отсортированы по возрастанию идентификаторов пользователей, 
а данные об одном и том же пользователе — по возрастанию даты создания поста.*/

SELECT user_id,
       creation_date,
       views_count,
       SUM(views_count) OVER (PARTITION BY user_id
                              ORDER BY creation_date)
FROM stackoverflow.posts
ORDER BY user_id,
         creation_date
 
 
/* Задание 5.
Сколько в среднем дней в период с 1 по 7 декабря 2008 года включительно пользователи взаимодействовали с платформой? 
Для каждого пользователя отберите дни, в которые он или она опубликовали хотя бы один пост. 
Нужно получить одно целое число — не забудьте округлить результат.*/

WITH a AS
  (SELECT user_id,
          COUNT(DISTINCT creation_date::date) AS activ_days
   FROM stackoverflow.posts
   WHERE creation_date::date BETWEEN '2008-12-01' AND '2008-12-07'
   GROUP BY user_id)
SELECT ROUND(AVG(activ_days))
FROM a


/* Задание 6.
На сколько процентов менялось количество постов ежемесячно с 1 сентября по 31 декабря 2008 года? 
Отобразите таблицу со следующими полями:
- номер месяца;
- количество постов за месяц;
- процент, который показывает, насколько изменилось количество постов в текущем месяце по сравнению с предыдущим.
Если постов стало меньше, значение процента должно быть отрицательным, если больше — положительным. 
Округлите значение процента до двух знаков после запятой.*/

WITH a AS
  (SELECT EXTRACT(MONTH
                  FROM creation_date::timestamp) AS month_post,
          COUNT(DISTINCT id) AS count_post
   FROM stackoverflow.posts
   WHERE creation_date::date BETWEEN '2008-09-01' AND '2008-12-31'
   GROUP BY month_post
   ORDER BY month_post)
SELECT *,
       ROUND(100*(count_post::numeric/LAG(count_post, 1) OVER (
                                                               ORDER BY month_post)-1), 2)
FROM a


/* Задание 7.
Выгрузите данные активности пользователя, который опубликовал больше всего постов за всё время. 
Выведите данные за октябрь 2008 года в таком виде:
- номер недели;
- дата и время последнего поста, опубликованного на этой неделе.*/

SELECT DISTINCT num_week,
                MAX(creation_date) OVER (PARTITION BY num_week )--as last_v
FROM
  (SELECT creation_date,
          EXTRACT(WEEK
                  FROM creation_date::timestamp) num_week
   FROM stackoverflow.posts
   WHERE user_id =
       (SELECT user_id
        FROM stackoverflow.posts
        GROUP BY user_id
        ORDER BY COUNT(DISTINCT id) DESC
        LIMIT 1) ) a
WHERE creation_date::date BETWEEN '2008-10-01' AND '2008-10-31'
ORDER BY num_week
