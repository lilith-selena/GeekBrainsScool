/* Задача 1
Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
*/

UPDATE users
	SET updated_at = NOW(), created_at = NOW();

/* Задача 2
Таблица users была неудачно спроектирована. Записи created_at и updated_at 
были заданы типом VARCHAR и в них долгое время помещались значения в формате
 "20.10.2017 8:10". Необходимо преобразовать поля к типу  DATETIME, 
 сохранив введеные ранее значения.*/

UPDATE users
SET
created_at = STR_TO_DATE(created_at , '%d.%m.%Y %k:%i'),
updated_at = STR_TO_DATE(updated_at , '%d.%m.%Y %k:%i');

ALTER TABLE users 
MODIFY created_at DATETIME DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE users 
MODIFY updated_at DATETIME DEFAULT CURRENT_TIMESTAMP;

/* как не старалась (нашла даже несколько разных решений в интернете,
 * но программа пишет SQL Error [1411] [HY000]: Incorrect datetime value:
 *  '2022-07-27 14:12:55' for function str_to_date).
 *рекомендация наставника не помогли, педлагаемый код дает ту же ошибку 
 *
 *Заполняем таблицу
INSERT INTO users (firstname, lastname, created_at, updated_at)
VALUES
('Pavel', 'Kotov', '20.10.2016 8:10', '20.10.2017 8:10'),
('Semen', 'Dvorov', '21.12.2017 8:10', '20.10.2017 8:10'),
('Natalia', 'Gotova', '22.03.2018 8:10', '20.10.2017 8:10');

 -- Меняем формат записи
UPDATE users
SET
created_at = STR_TO_DATE(created_at , '%d.%m.%Y %k:%i'),
updated_at = STR_TO_DATE(updated_at , '%d.%m.%Y %k:%i');

 -- Меняем тип данных
ALTER TABLE users MODIFY created_at DATETIME DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE users MODIFY updated_at DATETIME DEFAULT CURRENT_TIMESTAMP */

/* Задача 3
В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.
*/
SELECT * FROM storehouses_products;

INSERT INTO storehouses_products
	(storehouse_id, product_id, value, created_at, updated_at) VALUES
	(1, 7, 0, now(), now()),
	(2, 4, 2500, now(), now()),
	(3, 8, 0, now(), now()),
	(4, 2, 30, now(), now()),
	(5, 5, 500, now(), now()),
	(6, 6, 1, now(), now())
;

SELECT * FROM storehouses_products ORDER BY 
CASE 
	WHEN value = 0 THEN TRUE
	ELSE FALSE END, 
value;
	

/* Задача 4
(по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')
*/
SELECT * FROM users WHERE (birthday_at LIKE '%-05-%' OR birthday_at LIKE '%-08-%');


/* Задача 5
(по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.
*/
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIND_IN_SET(id,'5,1,2');



-- -----------------Практическое задание теме “Агрегация данных”-----------------------------

/* Задача 6
Подсчитайте средний возраст пользователей в таблице users */
ALTER  TABLE users DROP age;

ALTER TABLE users ADD age INT NOT NULL;

UPDATE users SET age = (YEAR(CURRENT_DATE) - YEAR(birthday_at));

SELECT AVG(age) FROM users;


/* Задача 7
Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.*/
SELECT CASE WEEKDAY(birthday_at) 
WHEN 0 THEN 'Понедельник' 
WHEN 1 THEN 'Вторник'
WHEN 2 THEN 'Среда' 
WHEN 3 THEN 'Четверг' 
WHEN 4 THEN 'Пятница' 
WHEN 5 THEN 'Суббота' 
WHEN 6 THEN 'Воскресенье' 
ELSE -1 END as week_day, 
COUNT(birthday_at) as num FROM users GROUP BY 
week_day ORDER BY FIELD(week_day,'Понедельник','Вторник','Среда','Четверг','Пятница','Суббота','Воскресенье');


/* Задача 8
(по желанию) Подсчитайте произведение чисел в столбце таблицы*/

