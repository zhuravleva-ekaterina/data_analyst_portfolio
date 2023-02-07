# Описания проекта - Исследование объявлений о продаже квартир

В данном проекте исследовалось влияние различных факторов на стоимость объектов недвижимости в Санкт-Петербурге и соседних населённых пунктов за несколько лет.

## Цель исследования 

Установить параметры, влияющие на стоимость квартир. Это позволит построить автоматизированную систему: она отследит аномалии и мошенническую деятельность. 

По каждой квартире на продажу доступны два вида данных. Первые вписаны пользователем, вторые — получены автоматически на основе картографических данных. Например, расстояние до центра, аэропорта, ближайшего парка и водоёма. 

## Данные

**Данные** - данные сервиса Яндекс.Недвижимость — архив объявлений о продаже квартир. 

* `airports_nearest` — расстояние до ближайшего аэропорта в метрах (м)
* `balcony` — число балконов
* `ceiling_height` — высота потолков (м)
* `cityCenters_nearest` — расстояние до центра города (м)
* `days_exposition` — сколько дней было размещено объявление (от публикации до снятия)
* `first_day_exposition` — дата публикации
* `floor` — этаж
* `floors_total` — всего этажей в доме
* `is_apartment` — апартаменты (булев тип)
* `kitchen_area` — площадь кухни в квадратных метрах (м²)
* `last_price` — цена на момент снятия с публикации
* `living_area` — жилая площадь в квадратных метрах (м²)
* `locality_name` — название населённого пункта
* `open_plan` — свободная планировка (булев тип)
* `parks_around3000` — число парков в радиусе 3 км
* `parks_nearest` — расстояние до ближайшего парка (м)
* `ponds_around3000` — число водоёмов в радиусе 3 км
* `ponds_nearest` — расстояние до ближайшего водоёма (м)
* `rooms` — число комнат
* `studio` — квартира-студия (булев тип)
* `total_area` — общая площадь квартиры в квадратных метрах (м²)
* `total_images` — число фотографий квартиры в объявлении

## Навыки и инструменты

*Предобработка данных, исследовательский анализ, визуализация данных, Matplotlib*

## Итоги исследования

**1. Изучено как быстро продавались квартиры:**
- Обычно продажа квартиры занимает 3 месяца, иногда затягивается до 6 месяцев. Продажу квартиры до 3 месяцев можно считать быстрой, а необычно долгая продажа будет длиться более 1 года.

**2. Изучено какие факторы больше всего влияют на общую стоимость объекта:**

**2.1. Основными факторами, влияющими на стоимость квартиры являются:**
- общая площадь квартиры. Чем больше площадь, тем выше цена;
- тип этажа, на котором расположена квартира. На первых и последних этажах квартиры дешевле;

**2.2.В меньшей степени стоимость квартиры зависит от:**
- жилой площади и площади кухни. Чем больше площадь, тем выше цена;
- количество комнат. Чем больше комнат, тем выше цена.

**2.3.Дата размещения объявления на цену не влияет. Замечено, что с 2014 по 2017 наблюдается тренд на снижении стоимости жилья**

**3. Рассчитана средняя цена одного квадратного метра в 10 населённых пунктах с наибольшим числом объявлений, а также определены населенные пункты с минимальной и максимальной средней ценой одного квадратного метра:**
- Больше всего объявлений в Санкт-Петербурге, стоимость 1 кв.м составляет около 113 тыс., на втором месте по количеству объявлений - посёлок Мурино, где средняя цена 1 кв.м составляет около 86 тыс.
- Среди 10 населённых пунктов с наибольшим числом объявлений средняя минимальная цена за кв.м в Выборге и состовляет 59 тыс. Самая высокая цена за кв.м в Санкт-Петербурге и состовляет почти 115 тыс.

**4. Расчитана зависимость стоимости квартиры от расстояния до центра города:**
- Чем ближе к центру расположена квартира, тем она дороже. 
- Выделяется низкая стоимость квартир в 3 км от центра, либо это некорректные данные, либо на таком расстоянии мало объявлений или неудачное расположение квартир. 
- Заметен пик увеличения стоимость на расстоянии 27 км, что может были либо выбросом, либо необычным объектом. 

## [Посмотреть ход решения]()