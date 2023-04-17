# Проект "Базовый SQL" (Яндекс.Практикум)

**Описание проекта:**
В данном проекте буду работать с базой данных, которая хранит информацию о венчурных фондах и инвестициях в компании-стартапы. Эта база данных основана на датасете Startup Investments, опубликованном на платформе Kaggle. 

**Цель проекта -** проанализировать данные о фондах и инвестициях и написать запросы к базе



## Задачи

1. Посчитайте, сколько компаний закрылось.</summary>

Решение:

```sql
SELECT count(id)
FROM company
WHERE status = 'closed'
```  

2. Отобразите количество привлечённых средств для новостных компаний США. Используйте данные из таблицы company. Отсортируйте таблицу по убыванию значений в поле funding_total

Решение:

```sql
SELECT sum(funding_total) 
FROM company
WHERE category_code = 'news' AND country_code = 'USA'
GROUP BY name
ORDER BY sum(funding_total) DESC
```  

3. Найдите общую сумму сделок по покупке одних компаний другими в долларах. Отберите сделки, которые осуществлялись только за наличные с 2011 по 2013 год включительно.</summary>


Решение:

```sql
SELECT SUM(price_amount)
FROM acquisition
WHERE term_code = 'cash'
        AND acquired_at BETWEEN '2011-01-01' AND '2013-12-31'
```  

4. Отобразите имя, фамилию и названия аккаунтов людей в твиттере, у которых названия аккаунтов начинаются на 'Silver'.

Решение:

```sql
SELECT first_name,
       last_name,
       twitter_username
FROM people
WHERE twitter_username LIKE 'Silver%'
``` 

5. Выведите на экран всю информацию о людях, у которых названия аккаунтов в твиттере содержат подстроку 'money', а фамилия начинается на 'K'.

Решение:

```sql
SELECT *
FROM people
WHERE twitter_username LIKE '%money%' AND last_name LIKE 'K%'
``` 

6. Для каждой страны отобразите общую сумму привлечённых инвестиций, которые получили компании, зарегистрированные в этой стране. Страну, в которой зарегистрирована компания, можно определить по коду страны. Отсортируйте данные по убыванию суммы.

Решение:

```sql
SELECT country_code,
       sum(funding_total)
FROM company
GROUP BY country_code
ORDER BY 2 DESC
``` 

7. Составьте таблицу, в которую войдёт дата проведения раунда, а также минимальное и максимальное значения суммы инвестиций, привлечённых в эту дату.
Оставьте в итоговой таблице только те записи, в которых минимальное значение суммы инвестиций не равно нулю и не равно максимальному значению.

```sql
SELECT funded_at,
       MIN(raised_amount) AS min_,
       MAX(raised_amount) AS max_
FROM funding_round
GROUP BY funded_at
HAVING MIN(raised_amount) != 0
AND MIN(raised_amount) != MAX(raised_amount)
```


8. Создайте поле с категориями:
 - Для фондов, которые инвестируют в 100 и более компаний, назначьте категорию high_activity.
 - Для фондов, которые инвестируют в 20 и более компаний до 100, назначьте категорию middle_activity.
 - Если количество инвестируемых компаний фонда не достигает 20, назначьте категорию low_activity.
Отобразите все поля таблицы fund и новое поле с категориями.

```sql
SELECT *,
       CASE
           WHEN invested_companies < 20 THEN 'low_activity'
           WHEN invested_companies BETWEEN 20 AND 100 THEN 'middle_activity'
           WHEN invested_companies > 100 THEN 'high_activity'
       END
FROM fund
```

9. Для каждой из категорий, назначенных в предыдущем задании, посчитайте округлённое до ближайшего целого числа среднее количество инвестиционных раундов, в которых фонд принимал участие. Выведите на экран категории и среднее число инвестиционных раундов. Отсортируйте таблицу по возрастанию среднего.

```sql
SELECT ROUND(AVG(investment_rounds)),
       CASE
           WHEN invested_companies>=100 THEN 'high_activity'
           WHEN invested_companies>=20 THEN 'middle_activity'
           ELSE 'low_activity'
       END AS activity
FROM fund
GROUP BY activity
ORDER BY AVG(investment_rounds);
```

10. Проанализируйте, в каких странах находятся фонды, которые чаще всего инвестируют в стартапы. 
Для каждой страны посчитайте минимальное, максимальное и среднее число компаний, в которые инвестировали фонды этой страны, основанные с 2010 по 2012 год включительно. Исключите страны с фондами, у которых минимальное число компаний, получивших инвестиции, равно нулю. 
Выгрузите десять самых активных стран-инвесторов: отсортируйте таблицу по среднему количеству компаний от большего к меньшему. Затем добавьте сортировку по коду страны в лексикографическом порядке.

```sql
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
```
