# Описания проекта - Маркетинговая аналитика развлекательного приложения Procrastinate Pro+

Заказчик — развлекательное приложение Procrastinate Pro+. Несмотря на огромные вложения в рекламу, последние несколько месяцев компания терпит убытки. Моя задача — разобраться в причинах и помочь компании выйти в плюс.

## Цель исследования 

Разобраться в причинах убытков и помочь компании выйти в плюс.

## Данные
**Данные** - данные о пользователях, привлечённых с 1 мая по 27 октября 2019 года:
- лог сервера с данными об их посещениях,
- выгрузка их покупок за этот период,
- рекламные расходы.


**Структура таблицы `visits`:**

* `User Id` — уникальный идентификатор пользователя,
* `Region` — страна пользователя,
* `Device` — тип устройства пользователя,
* `Channel` — идентификатор источника перехода,
* `Session Start` — дата и время начала сессии,
* `Session End` — дата и время окончания сессии.

**Структура таблицы `orders`:**
  
* `User Id` — уникальный идентификатор пользователя,
* `Event Dt` — дата и время покупки,
* `Revenue` — сумма заказа.

**Структура таблицы ` costs`:**
  
* `dt` — дата проведения рекламной кампании,
* `Channel` — идентификатор рекламного источника,
* `costs` — расходы на эту кампанию.


  
## Навыки и инструменты

*Анализ причин убытков рекламной компании. Расчет основных маркетинговых метрик, когортный анализ, оценка успешности рекламной кампании, рекомендации для маркетингового отдела по наиболее выгодным источникам трафика и когортам.y*

## Итоги исследования

## Во время исследовательского анализы были сформулированы следующие выводы:

1. Больше всего в приложение приходят пользователи из США, их более 100 тыс., на втором месте пользователи из Франции и Великобритании (17 тыс.), немного меньше пользователей из Германии (почти 15 тыс.). Платящие клиенты в основном также приходятся на США (7%), примерно 4% платящих пользователей из Франции, Германии, Великобритании.

2. Больше всего пользователей пользуется iPhone (почти 55 тыс.),почти в 1,5 раза меньше пользователей с Android, практически одинаковое количество пользователей используют PC и Mac (30 тыс.).  Несмотря на то, что больше пользователей с iPhone, доля платящих таких пользователей составляет 6%, такая же доля платящих пользователей имеющих Android или Mac. Доля платящих клиентов с РС составляет 5%.

3. Больше всего платящих клиентов приносят рекламные каналы: FaceBoom, TipTop и RocketSuperAds, AdNonSense.
 


## Во время маркетингового анализа были сформулированы следующие выводы:

1. Общая сумма расходов на маркетинг: 105497
2. Больше всего денег потратили на источник TipTop (почти 55 тыс.) и FaceBoom (почти 33 тыс.). В десятки раз меньше трат на источники WahooNetBanner (5 тыс.), AdNonSense (почти 4 тыс.) и  OppleCreativeMedia (почти 2 тыс.).
3. По каналам TipTop и FaceBoom наблюдается рост расходов, причем раходы по TipTop растут быстрее. В недельном разрезе заменты пики наибольших расходом на 23, 26, 39 недели. По остальным каналам наблюдается незначительный рост расходов до 20 недели, затем резкий спад до 23 недели (6 месяц), а далее до конца октября раходы практически не меняются, правда на 39 неделе наблюдается незначительное увеличение расходов. Выделяется канал WahooNetBanner по которому с самого начала мая наблюдается рост расходов с пиками на 23, 26 и 39 недели.
4. Самый дорогой трафик - TipTop (средняя стоимость - 2.80 за пользователя), далее - FaceBoom (1,11), AdNonSense (1,01). Органический трафик бесплатен, остальные каналы берут за пользователя от 0.21 до 0.72.


## Выводы после оценки окупаемости рекламы:
1. В целом реклама не окупается, а стоимость привлечения новых пользователей растет.
2. Негативно на окупаемость рекламы погут влиять:
   - пользователи из США. У них высокая стоимость привлечения и низкая окупаемость. Вероятно это связано с низким удержанием;
   - пользователи iPhone и Мас. У них низкая окупаемость, но высокая стоимость привлечения
   - пользователи с каналов FaceBoom, AdNonSense. Реклама на этих каналах не окупается, что вероятно связано с плохим удержанием. 
   - проблемы окупаемости вероятно связаны с неправильным выбора рекламного канала, устройства и страны. Также необходимо улучшать удержание клиентов.

## Причины неэффективности привлечения пользователей:

1. Завышены расходы по рекламному каналу FaceBoom, реклама не окупается.
2. Завышены расходы на пользователей из США.
3. Завышены расходы на пользователей iPhone и Мас
4. Низкое удержание пользователей:
   - из США, 
   - привлеченных с каналов FaceBoom, AdNonSense

## Рекомендации для отдела маркетинга:

1. Снизить расходы на рекламу по каналам FaceBoom, TipTop
2. Уменьшить рекламу для пользователей из США, а также для владельцев iPhone и Мас. Желательно ориентироваться на величину расходов по другим странам, устройствам.
3. Выяснить причины низкого удержания клиентов, в особенности клиентов из США или привлеченных с каналов FaceBoom, AdNonSense
4. Увеличить показ рекламы пользователям РС
5. Увеличить бюджет на рекламу по каналу RocketSuperAds, у него высокая доля платящих клиентов, а также окупаемость рекламы быстро растет

## [Посмотреть ход решения](https://github.com/zhuravleva-ekaterina/data_analyst_portfolio/blob/main/06_marketing_analytics/06_marketing_analytics.ipynb)

