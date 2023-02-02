/* Задача №1 
 * Составьте список пользователей users, которые осуществили хотя бы один заказ 
 * orders в интернет магазине.*/

/*
 * выведу на экран информацию о таблицах users, orders, orders_products
 * определю столбцы для создания запроса (т.к. таблица orders пуста ее предварительно заполню)
*/ 

USE shop;
SHOW CREATE TABLE users;
/*
	users	CREATE TABLE `users` (
	  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
	  `name` varchar(255) DEFAULT NULL COMMENT 'Имя покупателя',
	  `birthday_at` date DEFAULT NULL COMMENT 'Дата рождения',
	  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
	  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	  PRIMARY KEY (`id`),
	  UNIQUE KEY `id` (`id`)
	) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Покупатели'
*/

SHOW CREATE TABLE orders;
/*
	 orders	CREATE TABLE `orders` (
	  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
	  `user_id` int unsigned DEFAULT NULL,
	  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
	  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	  PRIMARY KEY (`id`),
	  UNIQUE KEY `id` (`id`),
	  KEY `index_of_user_id` (`user_id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Заказы' 
*/

SHOW CREATE TABLE orders_products;
/*
	orders_products	CREATE TABLE `orders_products` (
	  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
	  `order_id` int unsigned DEFAULT NULL,
	  `product_id` int unsigned DEFAULT NULL,
	  `total` int unsigned DEFAULT '1' COMMENT 'Количество заказанных товарных позиций',
	  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
	  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	  PRIMARY KEY (`id`),
	  UNIQUE KEY `id` (`id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Состав заказа'
 */

SELECT * FROM orders; -- пустая таблица
-- заполним таблицу orders

 INSERT INTO orders(user_id) VALUES
(2), (5), (1), (4); 

/* ****************  запрос  ****************** */
SELECT users.id, users.name, orders.id AS ORDER_id
FROM users 
RIGHT JOIN
	orders
ON users.id = orders.user_id;

/*
	1	Геннадий	3
	2	Наталья	1
	4	Сергей	4
	5	Иван	2
*/


/* Задача №2 
 * Выведите список товаров 
 * products и разделов catalogs, который соответствует товару.*/

SHOW COLUMNS FROM catalogs;
/*
	id	bigint unsigned	NO	PRI		auto_increment
	name	varchar(255)	YES	UNI		
*/

SHOW COLUMNS FROM products;
/*
	id	bigint unsigned	NO	PRI		auto_increment
	name	varchar(255)	YES			
	description	text	YES			
	price	decimal(11,2)	YES			
	catalog_id	int unsigned	YES	MUL		
	created_at	datetime	YES		CURRENT_TIMESTAMP	DEFAULT_GENERATED
	updated_at	datetime	YES		CURRENT_TIMESTAMP	DEFAULT_GENERATED 
		on update CURRENT_TIMESTAMPutf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Товарные позиции'
 */

/* ****************  запрос  ****************** */
SELECT 
	p.id, p.name, p.description, c.id AS cat_id,  p.price
FROM
	products AS p
JOIN
	catalogs AS c
ON 	p.catalog_id = c.id; 

/*
	1	Intel Core i3-8100	Процессор для настольных персональных компьютеров, основанных на платформе Intel.	1	7890.00
	2	Intel Core i5-7400	Процессор для настольных персональных компьютеров, основанных на платформе Intel.	1	12700.00
	3	AMD FX-8320E	Процессор для настольных персональных компьютеров, основанных на платформе AMD.	1	4780.00
	4	AMD FX-8320	Процессор для настольных персональных компьютеров, основанных на платформе AMD.	1	7120.00
	5	ASUS ROG MAXIMUS X HERO	Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX	2	19310.00
	6	Gigabyte H310M S2H	Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX	2	4790.00
	7	MSI B250M GAMING PRO	Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX	2	5060.00
 */

 /* Задача №3
  * (по желанию) Пусть имеется таблица рейсов flights (id, from, to)
  *  и таблица городов cities (label, name). Поля from, to и label 
  * содержат английские названия городов, поле name — русское. Выведите список рейсов flights 
  * с русскими названиями городов.
  */

-- создам таблицы flights и cities:
DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
	id SERIAL PRIMARY KEY, 
    `from` VARCHAR(150),
    `to` VARCHAR(150)
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
	id SERIAL PRIMARY KEY, 
    label VARCHAR(150),
    name VARCHAR(150)
);

-- заполняю
INSERT INTO cities (label, name) VALUES
('Moscow', 'Москва'), ('Saint-Petersburg', 'Санкт-Петербург'),
('Novosibirsk', 'Новосибирск'), ('Ekaterinburg','Екатеринбург'),
('Nizhniy Novgorod', 'Нижний Новгород'), ('Kazan', 'Казань'),
('Chelyabinsk',	'Челябинск'), ('Volgograd',	'Волгоград');

-- попыталась реализовать декартов запрос, но не смогла его вставить в INSERT
-- пришлось все сделать в ручную
SELECT a.label, b.label FROM cities AS a JOIN cities AS b;
/*Volgograd	Moscow
Chelyabinsk	Moscow
Kazan	Moscow
Nizhniy Novgorod	Moscow
Ekaterinburg	Moscow
Novosibirsk	Moscow
Saint-Petersburg	Moscow
Moscow	Moscow
Volgograd	Saint-Petersburg
Chelyabinsk	Saint-Petersburg
Kazan	Saint-Petersburg
Nizhniy Novgorod	Saint-Petersburg
Ekaterinburg	Saint-Petersburg
Novosibirsk	Saint-Petersburg
Saint-Petersburg	Saint-Petersburg
Moscow	Saint-Petersburg
Volgograd	Novosibirsk
Chelyabinsk	Novosibirsk
Kazan	Novosibirsk
Nizhniy Novgorod	Novosibirsk
Ekaterinburg	Novosibirsk
Novosibirsk	Novosibirsk
Saint-Petersburg	Novosibirsk
Moscow	Novosibirsk
Volgograd	Ekaterinburg
Chelyabinsk	Ekaterinburg
Kazan	Ekaterinburg
Nizhniy Novgorod	Ekaterinburg
Ekaterinburg	Ekaterinburg
Novosibirsk	Ekaterinburg
Saint-Petersburg	Ekaterinburg
Moscow	Ekaterinburg
Volgograd	Nizhniy Novgorod
Chelyabinsk	Nizhniy Novgorod
Kazan	Nizhniy Novgorod
Nizhniy Novgorod	Nizhniy Novgorod
Ekaterinburg	Nizhniy Novgorod
Novosibirsk	Nizhniy Novgorod
Saint-Petersburg	Nizhniy Novgorod
Moscow	Nizhniy Novgorod
Volgograd	Kazan
Chelyabinsk	Kazan
Kazan	Kazan
Nizhniy Novgorod	Kazan
Ekaterinburg	Kazan
Novosibirsk	Kazan
Saint-Petersburg	Kazan
Moscow	Kazan
Volgograd	Chelyabinsk
Chelyabinsk	Chelyabinsk
Kazan	Chelyabinsk
Nizhniy Novgorod	Chelyabinsk
Ekaterinburg	Chelyabinsk
Novosibirsk	Chelyabinsk
Saint-Petersburg	Chelyabinsk
Moscow	Chelyabinsk
Volgograd	Volgograd
Chelyabinsk	Volgograd
Kazan	Volgograd
Nizhniy Novgorod	Volgograd
Ekaterinburg	Volgograd
Novosibirsk	Volgograd
Saint-Petersburg	Volgograd
Moscow	Volgograd*/


/* хотела заполнить вложением, но что -то сделала не правильно по тому решила не мудорствовать
INSERT INTO flights (`from`, `to`) VALUES (SELECT a.label, b.label FROM cities AS a JOIN cities AS b);
Reason:
SQL Error [1064] [42000]: You have an error in your SQL syntax;
check the manual that corresponds to your MySQL server version for the right 
syntax to use near 'SELECT a.label, b.label FROM cities AS a JOIN cities AS b)' at line 1*/


INSERT INTO flights (`from`, `to`) 
VALUES
	('Volgograd','Moscow'),
	('Chelyabinsk', 'Moscow'),
	('Kazan',	'Moscow'),
	('Nizhniy Novgorod','Moscow'),
	('Ekaterinburg',	'Moscow');



/* ****************  запрос  ****************** */
SELECT f.id, `from`.name AS `from`, `to`.name AS `to`
FROM flights AS f
JOIN cities AS `from` ON f.`from` = `from`.label
JOIN cities AS `to` ON f.`to` = `to`.label
ORDER BY id;

/*
	1	Волгоград	Москва
	2	Челябинск	Москва
	3	Казань	Москва
	4	Нижний Новгород	Москва
	5	Екатеринбург	Москва
*/