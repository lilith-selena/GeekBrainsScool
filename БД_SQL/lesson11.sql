/* Задача №1 
 * Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users,
 *  catalogs и products в таблицу logs помещается время и дата создания записи, 
 * название таблицы, идентификатор первичного ключа и содержимое поля name.

 */
DROP TABLE IF EXISTS logs;
CREATE TABLE logs;
	created_at Datetime DEFAULT current_timestamp,
	name Varchar (255) NOT NULL,
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
	record_name Varchar (255)
	) ENGINE = ARCHIVE;



DROP PROCEDURE IF EXISTS record_logs;
delimiter //
CREATE PROCEDURE record_logs(
	name_log Varchar (255),
	id_log Bigint,
	record_name_log Varchar (255)
)
BEGIN 
	INSERT INTO logs (name, id, record_name)
	VALUES (name_log, id_log, record_name_log);
END //
delimiter ;



DROP TRIGGER IF EXISTS log_recording_catalogs;
delimiter //
CREATE TRIGGER log_recording_catalogs
AFTER INSERT catalogs
FOR EACH ROW
BEGIN CALL record_logs('catalogs', NEW.id, NEW.name);
END //


DROP TRIGGER IF EXISTS log_recording_users;
INSERT INTO products (name, description, price, catalog_id) VALUES ('Intel',
  'Процессор', 13999, 1);
 
DESC products; 


delimiter // 
CREATE TRIGGER log_recording_users
AFTER INSERT ON users
FOR EACH ROW
BEGIN
	CALL record_logs('users', NEW.id, NEW.name);
END //
delimiter ;



DROP TRIGGER IF EXISTS log_recording_products;
delimiter //
CREATE TRIGGER log_recording_products
AFTER INSERT ON products
FOR EACH ROW
BEGIN
	CALL record_logs('products', NEW.id, NEW.name);
END //
delimiter ;


/* Задача №2 Создайте SQL-запрос, который помещает в таблицу users миллион записей*/


DROP PROCEDURE IF EXISTS test;
delimiter //
CREATE PROCEDURE test()
BEGIN
   DECLARE count INT DEFAULT 1;
   WHILE count <= 1000000 DO
      INSERT INTO users (name, birthday_at) VALUES
        (LEFT(UUID(), 10)), DATE(CURRENT_TIMESTAMP - INTERVAL FLOOR(RAND() * 365) DAY)),
      SET count = count + 1;
   END WHILE;
END//
delimiter ;

test();
