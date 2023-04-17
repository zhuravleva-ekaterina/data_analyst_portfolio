-- Проект "Базовый SQL" (Яндекс.Практикум) --

Описание проекта:
В данном проекте буду работать с базой данных, которая хранит информацию о венчурных фондах и инвестициях в компании-стартапы.
Эта база данных основана на датасете Startup Investments, опубликованном на платформе Kaggle. 
Состоит из 23 заданий на составление запросов к БД (PostgreSQL) на основе датасета Startup Investments с Kaggle 

Цель проекта - проанализировать данные о фондах и инвестициях и написать запросы к базе


/* Задание 1.
Посчитайте, сколько компаний закрылось.*/

SELECT count(id)
FROM company
WHERE status = 'closed'
 

/* Задание 2. 
Отобразите количество привлечённых средств для новостных компаний США. Используйте данные из таблицы company. Отсортируйте таблицу по убыванию значений в поле funding_total */

SELECT sum(funding_total) 
FROM company
WHERE category_code = 'news' AND country_code = 'USA'
GROUP BY name
ORDER BY sum(funding_total) DESC 


/* Задание 3. 
Найдите общую сумму сделок по покупке одних компаний другими в долларах. 
Отберите сделки, которые осуществлялись только за наличные с 2011 по 2013 год включительно. */

SELECT SUM(price_amount)
FROM acquisition
WHERE term_code = 'cash'
        AND acquired_at BETWEEN '2011-01-01' AND '2013-12-31'


/* Задание 4. 
Отобразите имя, фамилию и названия аккаунтов людей в твиттере, у которых названия аккаунтов начинаются на 'Silver'. */

SELECT first_name,
       last_name,
       twitter_username
FROM people
WHERE twitter_username LIKE 'Silver%'


/* Задание 5. 
Выведите на экран всю информацию о людях, у которых названия аккаунтов в твиттере содержат подстроку 'money', а фамилия начинается на 'K'. */

SELECT *
FROM people
WHERE twitter_username LIKE '%money%' AND last_name LIKE 'K%'


/* Задание 6. 
Для каждой страны отобразите общую сумму привлечённых инвестиций, которые получили компании, зарегистрированные в этой стране. 
Страну, в которой зарегистрирована компания, можно определить по коду страны. Отсортируйте данные по убыванию суммы. */

SELECT country_code,
       sum(funding_total)
FROM company
GROUP BY country_code


/* Задание 7.  
Составьте таблицу, в которую войдёт дата проведения раунда, а также минимальное и максимальное значения суммы инвестиций, привлечённых в эту дату.
Оставьте в итоговой таблице только те записи, в которых минимальное значение суммы инвестиций не равно нулю и не равно максимальному значению. */

SELECT funded_at,
       MIN(raised_amount) AS min_,
       MAX(raised_amount) AS max_
FROM funding_round
GROUP BY funded_at
HAVING MIN(raised_amount) != 0
AND MIN(raised_amount) != MAX(raised_amount)


/* Задание 8. 
Создайте поле с категориями:
 - Для фондов, которые инвестируют в 100 и более компаний, назначьте категорию high_activity.
 - Для фондов, которые инвестируют в 20 и более компаний до 100, назначьте категорию middle_activity.
 - Если количество инвестируемых компаний фонда не достигает 20, назначьте категорию low_activity.
Отобразите все поля таблицы fund и новое поле с категориями. */

SELECT *,
       CASE
           WHEN invested_companies < 20 THEN 'low_activity'
           WHEN invested_companies BETWEEN 20 AND 100 THEN 'middle_activity'
           WHEN invested_companies > 100 THEN 'high_activity'
       END
FROM fund


/* Задание 9. 
Для каждой из категорий, назначенных в предыдущем задании, посчитайте округлённое до ближайшего целого числа среднее количество инвестиционных раундов, 
в которых фонд принимал участие. Выведите на экран категории и среднее число инвестиционных раундов. Отсортируйте таблицу по возрастанию среднего. */

SELECT ROUND(AVG(investment_rounds)),
       CASE
           WHEN invested_companies>=100 THEN 'high_activity'
           WHEN invested_companies>=20 THEN 'middle_activity'
           ELSE 'low_activity'
       END AS activity
FROM fund
GROUP BY activity
ORDER BY AVG(investment_rounds);


/* Задание 10. 
Проанализируйте, в каких странах находятся фонды, которые чаще всего инвестируют в стартапы. 
Для каждой страны посчитайте минимальное, максимальное и среднее число компаний, в которые инвестировали фонды этой страны, 
основанные с 2010 по 2012 год включительно. Исключите страны с фондами, у которых минимальное число компаний, получивших инвестиции, равно нулю. 
Выгрузите десять самых активных стран-инвесторов: отсортируйте таблицу по среднему количеству компаний от большего к меньшему. 
Затем добавьте сортировку по коду страны в лексикографическом порядке. */

SELECT country_code,
       MIN(invested_companies) AS min_,
       MAX(invested_companies) AS max_,
       AVG(invested_companies) AS avg_
FROM fund
WHERE founded_at BETWEEN '2010-01-01' AND '2012-12-31'
GROUP BY country_code
HAVING MIN(invested_companies) != 0
ORDER BY avg_ DESC,
         country_code
LIMIT 10


/* Задание  11.
Отобразите имя и фамилию всех сотрудников стартапов. 
Добавьте поле с названием учебного заведения, которое окончил сотрудник, если эта информация известна. */

SELECT first_name,
       last_name,
       instituition
FROM people p
LEFT JOIN education e ON p.id=e.person_id


/* Задание  12.
Для каждой компании найдите количество учебных заведений, которые окончили её сотрудники. 
Выведите название компании и число уникальных названий учебных заведений. Составьте топ-5 компаний по количеству университетов. */

SELECT c.name,
       COUNT(DISTINCT tab2.instituition)
FROM company AS c
LEFT JOIN
  (SELECT tab1.instituition,
          p.company_id
   FROM
     (SELECT person_id,
             instituition
      FROM education
      WHERE instituition IS NOT NULL ) AS tab1
   INNER JOIN people AS p ON p.id = tab1.person_id) AS tab2 ON tab2.company_id = c.id
GROUP BY c.name
ORDER BY COUNT(DISTINCT tab2.instituition) DESC
LIMIT 5;


/* Задание  13.
Составьте список с уникальными названиями закрытых компаний, для которых первый раунд финансирования оказался последним. */

SELECT name
FROM company c
LEFT JOIN funding_round fr ON c.id=fr.company_id
WHERE is_first_round = 1
  AND is_last_round = 1
  AND status = 'closed'
GROUP BY name


/* Задание  14.
Составьте список уникальных номеров сотрудников, которые работают в компаниях, отобранных в предыдущем задании. */

SELECT p.id
FROM people p
WHERE company_id IN
    (SELECT c.id
     FROM company c
     LEFT JOIN funding_round fr ON c.id=fr.company_id
     WHERE is_first_round = 1
       AND is_last_round = 1
       AND status = 'closed'
     GROUP BY c.id)
GROUP BY p.id


/* Задание  15.
Составьте таблицу, куда войдут уникальные пары с номерами сотрудников из предыдущей задачи и учебным заведением, которое окончил сотрудник. */

SELECT e.person_id,
       instituition
FROM education e
WHERE e.person_id IN
    (SELECT p.id
     FROM people p
     WHERE company_id IN
         (SELECT c.id
          FROM company c
          LEFT JOIN funding_round fr ON c.id=fr.company_id
          WHERE is_first_round = 1
            AND is_last_round = 1
            AND status = 'closed'
          GROUP BY c.id)
     GROUP BY p.id)
GROUP BY e.person_id,
         instituition


/* Задание  16.
Посчитайте количество учебных заведений для каждого сотрудника из предыдущего задания. 
При подсчёте учитывайте, что некоторые сотрудники могли окончить одно и то же заведение дважды. */

SELECT e.person_id,
       COUNT(instituition)
FROM education e
WHERE e.person_id IN
    (SELECT p.id
     FROM people p
     WHERE company_id IN
         (SELECT c.id
          FROM company c
          LEFT JOIN funding_round fr ON c.id=fr.company_id
          WHERE is_first_round = 1
            AND is_last_round = 1
            AND status = 'closed'
          GROUP BY c.id)
     GROUP BY p.id)
GROUP BY e.person_id


/* Задание  17.
Дополните предыдущий запрос и выведите среднее число учебных заведений (всех, не только уникальных), которые окончили сотрудники разных компаний. 
Нужно вывести только одну запись, группировка здесь не понадобится. */

SELECT AVG(count_)
FROM
  (SELECT e.person_id,
          COUNT(instituition) AS count_
   FROM education e
   WHERE e.person_id IN
       (SELECT p.id
        FROM people p
        WHERE company_id IN
            (SELECT c.id
             FROM company c
             LEFT JOIN funding_round fr ON c.id=fr.company_id
             WHERE is_first_round = 1
               AND is_last_round = 1
               AND status = 'closed'
             GROUP BY c.id)
        GROUP BY p.id)
   GROUP BY e.person_id) AS t


/* Задание  18.
Напишите похожий запрос: выведите среднее число учебных заведений (всех, не только уникальных), которые окончили сотрудники Facebook */

SELECT AVG(count_)
FROM
  (SELECT e.person_id,
          COUNT(instituition) AS count_
   FROM education e
   WHERE e.person_id IN
       (SELECT p.id
        FROM people p
        WHERE company_id IN
            (SELECT c.id
             FROM company c
             WHERE c.name = 'Facebook'
             GROUP BY c.id)
        GROUP BY p.id)
   GROUP BY e.person_id) AS t


/* Задание  19.
Составьте таблицу из полей:
- name_of_fund — название фонда;
- name_of_company — название компании;
- amount — сумма инвестиций, которую привлекла компания в раунде.
В таблицу войдут данные о компаниях, в истории которых было больше шести важных этапов, 
а раунды финансирования проходили с 2012 по 2013 год включительно.*/

SELECT f.name AS name_of_fund,
       c.name AS name_of_company,
       fr2.raised_amount AS amount
FROM investment i
LEFT JOIN company c ON i.company_id=c.id
LEFT JOIN fund f ON f.id=i.fund_id
INNER JOIN
  (SELECT *
   FROM funding_round fr
   WHERE fr.funded_at BETWEEN '2012-01-01' AND '2013-12-31') AS fr2 ON fr2.id=i.funding_round_id
WHERE c.milestones > 6


/* Задание 20.
Выгрузите таблицу, в которой будут такие поля:
- название компании-покупателя;
- сумма сделки;
- название компании, которую купили;
- сумма инвестиций, вложенных в купленную компанию;
- доля, которая отображает, во сколько раз сумма покупки превысила сумму вложенных в компанию инвестиций, округлённая до ближайшего целого числа.

Не учитывайте те сделки, в которых сумма покупки равна нулю. Если сумма инвестиций в компанию равна нулю, исключите такую компанию из таблицы. 
Отсортируйте таблицу по сумме сделки от большей к меньшей, а затем по названию купленной компании в лексикографическом порядке. 
Ограничьте таблицу первыми десятью записями.  */

WITH покупателя AS
  (SELECT c.name AS acquiring_company_id,
          a.price_amount,
          a.id AS k
   FROM acquisition a
   LEFT JOIN company c ON c.id = a.acquiring_company_id
   WHERE a.price_amount !=0),
     покупают AS
  (SELECT c.name AS acquired_company_id,
          c.funding_total,
          a.id AS k
   FROM acquisition a
   LEFT JOIN company c ON c.id = a.acquired_company_id
   WHERE c.funding_total != 0)
SELECT acquiring_company_id,
       price_amount,
       acquired_company_id,
       funding_total,
       ROUND(price_amount/funding_total)
FROM покупателя
JOIN покупают ON покупателя.k=покупают.k
ORDER BY price_amount DESC,
         acquired_company_id
LIMIT 10


/* Задание  21.
Выгрузите таблицу, в которую войдут названия компаний из категории social, получившие финансирование с 2010 по 2013 год включительно. 
Проверьте, что сумма инвестиций не равна нулю. Выведите также номер месяца, в котором проходил раунд финансирования.*/

SELECT c.name AS social_co,
       EXTRACT (MONTH
                FROM fr.funded_at) AS funding_month
FROM company AS c
LEFT JOIN funding_round AS fr ON c.id = fr.company_id
WHERE c.category_code = 'social'
  AND fr.funded_at BETWEEN '2010-01-01' AND '2013-12-31'
  AND fr.raised_amount <> 0;


/* Задание  22.
Отберите данные по месяцам с 2010 по 2013 год, когда проходили инвестиционные раунды. 
Сгруппируйте данные по номеру месяца и получите таблицу, в которой будут поля:
- номер месяца, в котором проходили раунды;
- количество уникальных названий фондов из США, которые инвестировали в этом месяце;
- количество компаний, купленных за этот месяц;
- общая сумма сделок по покупкам в этом месяце.*/

WITH a1 AS
  (SELECT EXTRACT(MONTH
                  FROM fr.funded_at) AS MONTH,
          COUNT(DISTINCT f.name) count_fund
   FROM investment i
   LEFT JOIN fund f ON i.fund_id=f.id
   LEFT JOIN funding_round fr ON fr.id=i.funding_round_id
   WHERE fr.funded_at BETWEEN '2010-01-01' AND '2013-12-31'
     AND f.country_code = 'USA'
   GROUP BY MONTH),
     b1 AS
  (SELECT EXTRACT(MONTH
                  FROM a.acquired_at) AS month2,
          COUNT(a.acquired_company_id) AS count_,
          SUM(price_amount) AS sum_
   FROM acquisition a
   WHERE a.acquired_at BETWEEN '2010-01-01' AND '2013-12-31'
   GROUP BY month2)
SELECT MONTH,
       count_fund,
       count_,
       sum_
FROM a1
LEFT JOIN b1 ON a1.month=b1.month2

/* Задание  23.
Составьте сводную таблицу и выведите среднюю сумму инвестиций для стран, в которых есть стартапы, зарегистрированные в 2011, 2012 и 2013 годах. 
Данные за каждый год должны быть в отдельном поле. Отсортируйте таблицу по среднему значению инвестиций за 2011 год от большего к меньшему.*/

WITH a1 AS
  (SELECT country_code,
          AVG(funding_total) AS year_2011
   FROM company
   WHERE EXTRACT(YEAR
                 FROM founded_at::DATE) IN (2011,
                                            2012,
                                            2013)
   GROUP BY country_code,
            EXTRACT(YEAR
                    FROM founded_at)
   HAVING EXTRACT(YEAR
                  FROM founded_at::DATE) = '2011'),
     b1 AS
  (SELECT country_code,
          AVG(funding_total) AS year_2012
   FROM company
   WHERE EXTRACT(YEAR
                 FROM founded_at::DATE) IN (2011,
                                            2012,
                                            2013)
   GROUP BY country_code,
            EXTRACT(YEAR
                    FROM founded_at)
   HAVING EXTRACT(YEAR
                  FROM founded_at::DATE) = '2012'),
     c1 AS
  (SELECT country_code,
          AVG(funding_total) AS year_2013
   FROM company
   WHERE EXTRACT(YEAR
                 FROM founded_at::DATE) IN (2011,
                                            2012,
                                            2013)
   GROUP BY country_code,
            EXTRACT(YEAR
                    FROM founded_at)
   HAVING EXTRACT(YEAR
                  FROM founded_at::DATE) = '2013')
SELECT a1.country_code,
       year_2011,
       year_2012,
       year_2013
FROM a1
JOIN b1 ON a1.country_code=b1.country_code
JOIN c1 ON b1.country_code=c1.country_code
ORDER BY year_2011 DESC
