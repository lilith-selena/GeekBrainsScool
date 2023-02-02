/*Практическое задание по теме “Транзакции, переменные, представления”
 * 
 * Задача №1
 * В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
 * Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции
 */

START TRANSACTION;
INSERT INTO sample.users 
SELECT id, name 
FROM shop.users 
WHERE id = 1;
COMMIT;


/*Задача №2
 * Создайте представление, которое выводит название name товарной позиции из таблицы products 
 * и соответствующее название каталога name из таблицы catalogs.
*/

CREATE OR REPLACE VIEW v AS 
SELECT products.name 
AS p_name, catalogs.name AS c_name 
FROM products,catalogs 
WHERE products.catalog_id = catalogs.id;


/*
Практическое задание по теме “Хранимые процедуры и функции, триггеры"*/

/* Задача №1
Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
в зависимости от текущего времени суток. 
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
с 18:00 до 00:00 — "Добрый вечер", 
с 00:00 до 6:00 — "Доброй ночи".
*/

DROP PROCEDURE IF EXISTS hello;
DELIMITER //
CREATE PROCEDURE hello()
BEGIN
	IF(CURTIME() BETWEEN '06:00:00' AND '12:00:00') THEN
		SELECT 'Доброе утро';
	ELSEIF(CURTIME() BETWEEN '12:00:00' AND '18:00:00') THEN
		SELECT 'Добрый день';
	ELSEIF(CURTIME() BETWEEN '18:00:00' AND '00:00:00') THEN
		SELECT 'Добрый вечер';
	ELSE
		SELECT 'Доброй ночи';
	END IF;
END //
DELIMITER ;

CALL hello();

/* Задача №2
В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.
*/

DROP TRIGGER IF EXISTS nullTrigger;
delimiter //
CREATE TRIGGER nullTrigger BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF(ISNULL(NEW.name) AND ISNULL(NEW.description)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ошибка! поле не может быть NULL!';
	END IF;
END //
delimiter ;

INSERT INTO products (name, description, price, catalog_id)
VALUES ("GeForce RTX 3060", NULL, 37999, 3); 

INSERT INTO products (name, description, price, catalog_id)
VALUES ("GeForce RTX 3060", "видеокарта", 37999, 2); 

INSERT INTO products (name, description, price, catalog_id)
VALUES (NULL, NULL, 37999, 2);



