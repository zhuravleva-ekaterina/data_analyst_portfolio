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
