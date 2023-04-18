-- Проект "Продвинутый SQL. Расчёт бизнес-показателей" (Яндекс.Практикум) --

/* Задание 1.
Напишите запрос, который выведет общую конверсию из пользователя в клиента для схемы tools_shop. 
Результат округлите до одного знака после запятой.*/

SELECT ROUND(COUNT(DISTINCT o.user_id) * 100.0 / COUNT(DISTINCT u.user_id), 1)
FROM tools_shop.users u
LEFT JOIN tools_shop.orders o ON u.user_id=o.user_id

/* Задание 2.
Используя функцию DATE_TRUNC(), рассчитайте ARPPU в разрезе года оформления заказа для схемы tools_shop. 
Поле с датой приведите к типу данных date, а значение ARPPU округлите до двух знаков после запятой.*/

SELECT CAST(DATE_TRUNC('year', o.created_at) AS date),
       ROUND(SUM(o.total_amt) / COUNT(DISTINCT u.user_id), 2)
FROM tools_shop.orders o
JOIN tools_shop.users u ON o.user_id=u.user_id
GROUP BY DATE_TRUNC('year', o.created_at)

/* Задание 3.
Рассчитайте метрику ARPU для схемы tools_shop.*/

SELECT SUM(o.total_amt) / COUNT(DISTINCT u.user_id)
FROM tools_shop.users u
LEFT JOIN tools_shop.orders o ON u.user_id=o.user_id

/* Задание 4.
Рассчитайте ROI в динамике по месяцам для схемы tools_shop*/

SELECT a.dt,
       b.total_amt *100 / a.costs
FROM
  (SELECT DATE_TRUNC('month', created_at)::date AS dt,
          SUM(costs) AS costs
   FROM tools_shop.costs
   GROUP BY dt) a
JOIN
  (SELECT DATE_TRUNC('month', paid_at)::date AS dt,
          SUM(total_amt) AS total_amt
   FROM tools_shop.orders
   GROUP BY dt) b ON a.dt=b.dt
   
/* Задание 5.
Рассчитайте Retention Rate по месяцам для клиентов схемы tools_shop. 
Выведите в запросе несколько полей:
- месяц старта когорты,
- месяц события,
- общее количество пользователей когорты,
- количество пользователей в этот месяц,
- Retention Rate.
Значение Retention Rate округлите до двух знаков после запятой.*/

WITH PROFILE AS
  (SELECT u.user_id,
          DATE_TRUNC('month', MIN(event_time))::date AS dt
   FROM tools_shop.users u
   JOIN tools_shop.orders o ON u.user_id = o.user_id
   JOIN tools_shop.events e ON u.user_id = e.user_id
   GROUP BY 1), sessions AS
  (SELECT p.user_id,
          DATE_TRUNC('month', event_time)::date AS session_dt
   FROM tools_shop.events e
   JOIN PROFILE p ON p.user_id = e.user_id
   GROUP BY 1,
            2),
                cohort_users_cnt AS
  (SELECT dt,
          COUNT(user_id) AS cohort_users_cnt
   FROM PROFILE
   GROUP BY 1)
SELECT dt,
       session_dt,
       cohort_users_cnt,
       COUNT(p.user_id) AS users_cnt,
       ROUND(COUNT(p.user_id) * 100.0 / cohort_users_cnt, 2) AS retention_rate
FROM PROFILE p
JOIN sessions USING(user_id)
JOIN cohort_users_cnt USING(dt)
GROUP BY 1,
         2,
         3;
         
/* Задание 6.
Рассчитайте LTV в первые шесть месяцев с момента регистрации пользователей для схемы tools_shop, сгруппировав данные по месяцу регистрации. 
При этом нужно учитывать только тех пользователей, которые зарегистрировались в 2019 году.*/  

WITH user_profile AS
  (SELECT user_id,
          DATE_TRUNC('month', created_at)::date AS start_cohort,
          COUNT(*) OVER (PARTITION BY DATE_TRUNC('month', created_at)::date) AS cohort_size
   FROM tools_shop.users),
     sessions AS
  (SELECT EXTRACT(MONTH
                  FROM AGE(DATE_TRUNC('month', created_at), up.start_cohort)) AS lifetime,
          DATE_TRUNC('month', o.created_at)::date AS order_date,
          start_cohort,
          cohort_size,
          total_amt
   FROM user_profile up
   JOIN tools_shop.orders o ON up.user_id = o.user_id),
     ltv_raw AS
  (SELECT lifetime,
          start_cohort,
          cohort_size,
          SUM(total_amt) OVER (PARTITION BY start_cohort
                               ORDER BY lifetime) / cohort_size AS ltv
   FROM sessions)
SELECT lifetime,
       start_cohort,
       ltv
FROM ltv_raw
WHERE start_cohort BETWEEN '2019-01-01' AND '2019-12-31'
GROUP BY lifetime,
         start_cohort,
         ltv
ORDER BY start_cohort,
         lifetime
         
/* Задание 7.
Рассчитайте Churn Rate по месяцам для клиентов схемы tools_shop.*/   

WITH profiles AS
  (SELECT DISTINCT o.user_id,
                   MIN(DATE_TRUNC('month', event_time)::date) AS dt
   FROM tools_shop.users u
   JOIN tools_shop.orders o USING(user_id)
   JOIN tools_shop.events e USING(user_id)
   GROUP BY 1),
     sessions AS
  (SELECT p.dt AS start_dt,
          DATE_TRUNC('month', event_time)::date AS session_dt,
          COUNT(DISTINCT p.user_id) AS users_cnt
   FROM profiles p
   JOIN tools_shop.events e ON p.user_id = e.user_id
   GROUP BY 1,
            2)
SELECT *,
       LAG(users_cnt) OVER (PARTITION BY start_dt
                            ORDER BY session_dt) AS previous_day_users_cnt,
                           ROUND((1 - (users_cnt::numeric/ LAG(users_cnt) OVER (PARTITION BY start_dt
                                                                                ORDER BY session_dt))) * 100, 2) AS churn_rate
FROM sessions;
