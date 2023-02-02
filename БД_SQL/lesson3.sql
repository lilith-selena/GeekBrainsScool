/* ДЗ№4
 * БД - в которую вносятся данные */


DROP DATABASE IF EXISTS vk; 
CREATE DATABASE vk;
USE vk;


DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	firstname VARCHAR(50),
	lastname VARCHAR(50),
	email VARCHAR(100) UNIQUE,
	password_hash VARCHAR(100),
	phone BIGINT UNSIGNED,
	INDEX idx_users_usernsme (firstname,lastname)
)COMMENT 'юзеры...';


DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	gender CHAR(1),
	hometown VARCHAR(50),
	birthday DATETIME,
	created_at DATETIME DEFAULT NOW()
);
 

ALTER TABLE profiles ADD CONSTRAINT fk_profiles_user_id
FOREIGN KEY (user_id) REFERENCES users (id);


DROP TABLE IF EXISTS messages;
CREATE TABLE messages ( 
	id SERIAL,
	from_user_id BIGINT UNSIGNED NOT NULL,
	to_user_id BIGINT UNSIGNED NOT NULL,
	body TEXT,
	created_at DATETIME DEFAULT NOW(),

FOREIGN KEY (from_user_id) REFERENCES users(id),
FOREIGN KEY (to_user_id) REFERENCES users(id)
);


DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests ( 
	initiator_user_id BIGINT UNSIGNED NOT NULL,
	target_user_id BIGINT UNSIGNED NOT NULL,
	status ENUM('requested','approved', 'declined', 'unfriended'),
	recuested_at DATETIME DEFAULT NOW(),
	uppdeted_at DATETIME ON UPDATE CURRENT_tIMESTAMP,

PRIMARY KEY (initiator_user_id, target_user_id),
FOREIGN KEY (initiator_user_id) REFERENCES users(id),
FOREIGN KEY (target_user_id) REFERENCES users(id),
CHECK (initiator_user_id <> target_user_id)
);


DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL,
	name VARCHAR(255),
	admin_user_id BIGINT UNSIGNED NOT NULL,
	
	INDEX communities_name_idx(name),
	foreign key (admin_user_id) references users(id)
);


DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  
PRIMARY KEY (user_id, community_id), 
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (community_id) REFERENCES communities(id)
);


DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);


DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL,
	media_type_id BIGINT UNSIGNED NOT NULL,
	user_id BIGINT UNSIGNED NOT NULL,
	body text,
	filename VARCHAR(255),    	
	size INT,
	metadata JSON,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,

FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);



DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW()
);

ALTER TABLE vk.likes ADD CONSTRAINT likes_FK FOREIGN KEY (media_id) REFERENCES vk.media(id);
ALTER TABLE vk.likes ADD CONSTRAINT likes_FK_1 FOREIGN KEY (user_id) REFERENCES vk.users(id);


DROP TABLE IF EXISTS neus_types;
CREATE TABLE neus_types(
	id SERIAL,
    name ENUM ('video','txt'),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);



DROP TABLE IF EXISTS neus;
CREATE TABLE neus(
	id SERIAL,
	neus_id BIGINT UNSIGNED NOT NULL,
    neus_type_id BIGINT UNSIGNED NOT NULL,
   	neus_name VARCHAR(500),
    data_neus DATETIME DEFAULT NOW(),
    body TEXT,
    FOREIGN KEY (neus_id) REFERENCES users(id),
    FOREIGN KEY (neus_type_id) REFERENCES neus_types(id)
);


DROP TABLE IF EXISTS users_neus;
CREATE TABLE users_neus(
	neus_id BIGINT UNSIGNED NOT NULL,
	users_id BIGINT UNSIGNED NOT NULL,
  
	FOREIGN KEY (neus_id) REFERENCES neus(id),
    FOREIGN KEY (users_id) REFERENCES users(id)
);
/* Урок №4 
Тема: CRUD / DML (data manipulation language)
Команды: INSERT, SELECT, UPDATE, DELETE


#INSERT INTO users (id, firstname, lastname, email, phone) -- при повторении данных появляется ошибка
#VALUES (1, 'Ivanov', 'Ivan', 'Ivanov@Ivan.ork', 9876543210);

INSERT IGNORE INTO users (id, firstname, lastname, email, phone) -- IGNORE позволяет не останавливать работу скрипта 
-- даже при не корректных (повторяющихся) данных
VALUES (2, 'Sidorov', 'Sidor', 'sidorov@sidor.ork', 9876543211);

INSERT IGNORE INTO users (firstname, lastname, email, phone) -- можно обойтись без id номер поля присваевается по порядку 
-- auto_increment говорит о том что к  последнему  значению  в поле id +1, id заполняется по порядку
VALUES ('Petrov', 'Petr', 'Petrov@Petrov.ork', 9876543212);

INSERT IGNORE INTO users (firstname, lastname, email, phone) -- можно обойтись без id номер поля присваевается по порядку 
-- auto_increment говорит о том что к  последнему  значению  в поле id +1, id заполняется по порядку
VALUES 
('Petrov0', 'Petr0', 'Petrov0@Petrov0.ork', 9876543213),
('Petrov1', 'Petr1', 'Petrov1@Petrov1.ork', 9876543214),
('Petrov2', 'Petr2', 'Petrov2@Petrov2.ork', 9876543215);

INSERT IGNORE INTO users (firstname, lastname, email)
SELECT first_name, last_name, email
FROM sakila.staff; 

SELECT id, firstname, lastname, email, password_hash, phone
FROM users
WHERE phone IS NOT NULL;

-- многократное повторение кода вызывает ошибку, по этому на данном этапе работы 
-- в команде SQL используется IGNORE
INSERT IGNORE INTO friend_requests (initiator_user_id, target_user_id, status)
VALUES ('1', '2', 'requested');

INSERT  IGNORE INTO friend_requests (initiator_user_id, target_user_id, status)
VALUES ('1', '3', 'requested');

INSERT  IGNORE INTO friend_requests (initiator_user_id, target_user_id, status)
VALUES ('1', '4', 'requested');

INSERT  IGNORE  INTO friend_requests (initiator_user_id, target_user_id, status)
VALUES ('1', '5', 'requested');

UPDATE friend_requests 
SET
	status = 'approved'
WHERE initiator_user_id = 1 AND target_user_id = 2;

UPDATE friend_requests 
SET
	status = 'declined'
WHERE initiator_user_id = 1 AND target_user_id = 3;



INSERT IGNORE INTO messages values
('1','1','2','гляжу опавший лист','1995-08-28 22:44:29'),
('2','2','1','опять взлетел на ветку',now()),
('3','3','1','то бабочка была','1993-09-14 19:45:58'),
('4','4','3','хоку','1985-11-25 16:56:25'),
('5','1','5','вроде','1999-09-19 04:35:46')
;

DELETE FROM messages
WHERE from_user_id = 1 AND to_user_id = 2
; */


/* Задача 1
Заполнить все таблицы БД vk данными (не больше 10-20 записей в каждой таблице)*/

INSERT INTO `users` VALUES
(1,'Rowena','Stamm','mauricio.lang@example.com','05a346c96cd282d46ebe43420afa006ad7a1215f',89627443646),
(2,'Mae','Becker','hauck.elvie@example.com','bacb9215ba2ad54df9521c23bd634cd6a930b347',89014725885),
(3,'Aiyana','Dickens','seamus.abbott@example.net','c719f323ed283f50079f1f2d1dce9cac878025cd',89082943452),
(4,'Seth','Lueilwitz','catalina.dietrich@example.org','ce4e7bd4263f76b261742c49834c095e92fdc70b',89005122958),
(5,'Janelle','Upton','auer.izaiah@example.org','5705edab886a4c033b2db6cd8d5cc53b6d22f094',89348632380),
(6,'Tyrese','VonRueden','tritchie@example.net','a7af83326c783c4858187c3cb4f5e837e4385a24',89960946687),
(7,'Franco','Prohaska','jamal.grimes@example.com','b471fc886e26ac83fa9ab97e7a56a48eb5b3caa5',89954968657),
(8,'Karianne','Sanford','connie55@example.org','842672a12aad4e602fb1fb30de8d1f4216f00239',89125606847),
(9,'Muhammad','Wehner','frank.eichmann@example.com','f74b0cee2694e33b7fc37ab5a1507feb1ef7505c',89120708670),
(10,'Edmund','Stokes','tturcotte@example.net','38d41e975a92735c71d3b11ab1b62a28065cf45c',89384460047),
(11,'Layne','Maggio','roscoe.schumm@example.org','2dff445415745bffbecfeb72f742b20b13a0c0bf',89147915045),
(12,'Garrick','Turner','perry52@example.org','6f653509a3590a9990562ed4de8b82be6ed6bf5b',89491009591),
(13,'Elliott','Haag','okey.cummerata@example.com','970da44dd5e999381d5ac9c218d0c5308a8ba9c0',89113447474),
(14,'Aron','Wintheiser','ubaldo.nolan@example.com','d57452ee4c9e619a9b33a79ccd7c8708de7123e1',89550797903),
(15,'Violette','Yost','maegan.johnson@example.net','5a2d0c5080a772e76887f68721e7959bd1a0a190',89245789470),
(16,'Lincoln','Stroman','jakubowski.coy@example.net','aaaa87bce8bf88678734b64eb41bcd0de16f9ad6',89311185416),
(17,'Arely','Crooks','pierce88@example.com','db6e027d852b602a2d1fbd0cdf58361bf02f7b8e',89995718013),
(18,'Jayson','Kuvalis','mckenzie.dimitri@example.net','e764ba9e6a6afc18245fce1fce6ab4b20c611286',89526041781),
(19,'Arnold','McGlynn','brian.botsford@example.org','7c1b2604ea3cf266b16832468c511ce4d3b06848',89242883773),
(20,'Francesca','Wiegand','ortiz.gabriella@example.com','f08e9737345b10e77848697d681b17e547b0f66f',89617292947);

INSERT INTO `communities` VALUES 
(1,'Giuseppe',1),
(2,'Nat',2),
(3,'Ray',3),
(4,'Jerel',4),
(5,'Hayden',5),
(6,'Christ',6),
(7,'Nicholas',7),
(8,'Davion',8),
(9,'Quentin',9),
(10,'Deontae',10),
(11,'Jonathon',11),
(12,'Leo',12),
(13,'Wiley',13),
(14,'Bud',14),
(15,'Dell',15),
(16,'Kim',16),
(17,'Presley',17),
(18,'Earnest',18),
(19,'Darrick',19),
(20,'Marlon',20);


INSERT INTO `media_types` VALUES 
(1,'perferendis','1987-08-07 00:26:49','1988-09-04 07:25:59'),
(2,'consequatur','2008-04-25 01:01:26','2005-08-01 19:30:56'),
(3,'impedit','1992-09-28 05:02:55','1980-02-29 07:35:53'),
(4,'qui','2011-04-25 22:59:20','1977-01-06 00:51:22'),
(5,'qui','1974-01-30 19:07:22','2014-05-27 12:51:38'),
(6,'qui','1981-01-08 08:13:55','1990-07-22 09:25:39'),
(7,'officia','2003-06-05 10:04:31','1995-07-04 13:42:35'),
(8,'beatae','2002-02-15 03:49:14','2003-12-02 11:26:21'),
(9,'quis','1987-12-18 04:50:26','1994-04-25 01:33:07'),
(10,'veniam','2006-01-06 22:05:06','1984-05-13 23:54:01'),
(11,'dolores','1977-01-17 00:11:10','2011-12-05 07:57:58'),
(12,'modi','1972-05-12 21:42:01','2003-04-18 05:17:53'),
(13,'qui','2018-12-19 06:00:23','1987-08-13 14:01:29'),
(14,'libero','2000-09-10 20:03:43','2006-08-04 12:37:14'),
(15,'et','1970-01-25 21:03:42','2009-05-15 09:04:28'),
(16,'rerum','2007-08-26 11:56:53','1980-07-10 00:14:12'),
(17,'pariatur','1996-05-06 20:05:33','1976-06-25 03:16:17'),
(18,'qui','1991-01-25 15:39:43','1983-10-27 09:53:01'),
(19,'tempore','1987-11-03 18:29:56','2005-09-21 01:42:06'),
(20,'soluta','1972-10-10 18:07:50','2002-10-16 12:50:19')
;

INSERT INTO `messages` VALUES 
(1,3,18,'Odio natus voluptatem eos numquam ea. Ut a similique neque eum quae et. Sit reprehenderit dolore impedit quam excepturi. Ut dolor aspernatur accusantium dolor ut adipisci voluptas.','1992-06-21 21:01:13'),
(2,8,19,'Corrupti nam voluptas dolorem et qui illo. Et deleniti ratione et rerum. Corrupti quisquam facere ut rerum dignissimos laboriosam est. Aut est nostrum aut quisquam incidunt.','1992-02-14 23:34:39'),
(3,7,11,'Consequatur velit nam cupiditate et laudantium asperiores. Nulla aliquam totam placeat dolor. Iste inventore commodi tempora sit incidunt error accusantium. Natus ut alias rem ducimus perferendis occaecati.','1992-05-08 10:30:08'),
(4,6,14,'Voluptatum voluptas non commodi animi earum in quia rerum. Impedit nobis quaerat unde provident corporis qui veniam id. Et cupiditate tempore soluta corporis. Amet ducimus odit ipsa et.','1992-12-08 10:25:28'),
(5,2,11,'Ut omnis quam excepturi aut tenetur. Rerum aut et quibusdam optio vero. Ut vel maxime enim ea.','2006-01-14 15:09:16'),
(6,3,18,'Quis est ipsum corporis eos numquam expedita repellendus. Enim aut quae maxime excepturi quasi ipsum aspernatur. Earum libero culpa perferendis adipisci eos cumque quaerat.','2025-09-19 23:38:57'),
(7,3,12,'Temporibus exercitationem nostrum aspernatur ad consequatur. Aut ipsam quod fugiat. Maxime autem voluptates nobis adipisci dolorem. Temporibus dignissimos ut placeat culpa tempore itaque iste. Velit assumenda aut placeat earum nam voluptas.','1980-11-06 00:45:17'),
(8,1,10,'Natus natus omnis voluptatum sint est consequatur harum. Delectus rerum neque amet est doloremque vero aut. Libero occaecati molestiae sunt id dolores est dolorem. Cum non dolores maiores nostrum vitae autem error.','2013-08-04 00:20:19'),
(9,1,17,'Quis praesentium perferendis fugiat beatae. Ducimus voluptas officia ea laborum architecto voluptatem. Nihil non nostrum et perferendis non. Est saepe perferendis dolor aut praesentium eos.','1972-11-07 10:03:47'),
(10,6,18,'Et est vel ea sed deserunt ex. Maiores perspiciatis veniam ducimus doloremque delectus praesentium rem. Nemo qui facilis quo dicta praesentium saepe pariatur.','2004-05-14 07:48:01'),
(11,3,18,'Eaque ad inventore eum distinctio voluptatem voluptatum. Modi illo accusamus ducimus distinctio nesciunt nobis officia. Iusto aliquid ab earum ut ea voluptatem. Veritatis saepe maiores veritatis et reiciendis laboriosam.','1978-05-25 17:00:39'),
(12,4,17,'Nostrum et in aut illum rem. Sed aut optio incidunt similique in adipisci. Ut fuga itaque qui et ut ea quia.','1999-01-13 07:22:16'),
(13,6,15,'Non expedita placeat ut aut. Rerum maxime hic consequatur cupiditate cumque. Dolores aspernatur soluta reiciendis tenetur architecto nulla repudiandae. Ullam blanditiis assumenda delectus cupiditate nesciunt doloremque cupiditate.','2022-06-17 19:56:34'),
(14,7,11,'Numquam hic et voluptatem autem quisquam enim est. Molestiae qui quia laboriosam alias qui facilis deleniti. Non cumque voluptatum natus earum quasi minus distinctio.','2009-06-02 21:35:03'),
(15,3,11,'Quidem rem et recusandae et iure qui exercitationem. Expedita soluta voluptatum assumenda est rerum aspernatur. Repellendus voluptatem quo id magnam quidem fuga.','2023-07-10 10:59:18'),
(16,6,14,'Est quaerat praesentium perspiciatis. Sapiente qui est consequatur rerum. Nulla tenetur est explicabo. Atque voluptatem cum aut facilis quae expedita tempore.','2029-03-04 06:57:03'),
(17,4,10,'Enim qui magni sapiente voluptas velit provident eligendi. Alias dolorem eligendi esse est quia repellat. Eveniet quidem est dignissimos praesentium eum dolorem.','1976-10-23 21:22:00'),
(18,8,11,'Reprehenderit doloribus autem dolores labore ipsa repudiandae. Est id dolorum et. Eveniet ut temporibus odit accusamus eligendi possimus.','1973-11-18 23:55:59'),
(19,8,15,'Consequatur atque et consectetur illum voluptas sapiente. Accusantium dignissimos eligendi quaerat possimus numquam assumenda. Repellendus illum hic sed laboriosam.','1988-05-18 03:21:54'),
(20,1,14,'Nihil voluptatibus architecto qui totam dignissimos voluptates. Odit vel labore perspiciatis nesciunt ut. Enim voluptatem inventore molestiae debitis.','1980-03-26 08:21:36')
;

INSERT INTO `profiles` VALUES 
(1,'m','Tillmanhaven', '1954-04-08 20:14:08', '1985-09-20 08:25:10'),
(2,'m','Benville','1970-04-17 03:08:58', '1985-08-13 15:47:27'),
(3,'f','North Elnorafurt','1949-01-30 19:53:37','1982-10-09 18:11:28'),
(4,'f','Claudinemouth','1982-03-26 04:26:38', '2022-05-12 03:53:43'),
(5,'m','Monachester','2000-02-19 16:27:07','2008-11-05 09:08:55'),
(6,'f','North Catalinaburgh','2008-11-10 06:55:41','2019-11-03 05:51:04'),
(7,'f','Lake Keelyton','1947-09-27 17:00:11', '2017-02-28 02:43:15'),
(8,'m','Aldaport','1993-01-05 10:04:06', '2012-11-14 09:45:59'),
(9,'f','Port Kelli','2012-08-14 10:51:34', '2022-05-12 02:44:40'),
(10,'f','Schroederton','1999-03-21 16:39:14', '2001-08-22 21:19:49'),
(11,'f','North Havenville','1978-06-23 13:37:49', '1928-08-25 10:16:20'),
(12,'f','East Kamron','1972-03-24 00:49:06', '1986-05-23 09:53:12'),
(13,'f','Bechtelarchester','2018-02-27 22:21:28', '2022-11-03 05:51:04' ),
(14,'m','Port Kelsi','1972-04-02 19:11:00', '1983-03-23 06:55:06'),
(15,'m','Amirastad','1973-04-19 20:15:55', '1992-08-24 21:50:35'),
(16,'f','Port Cloydmouth','1978-01-09 04:09:03','2010-10-03 15:23:06'),
(17,'f','West Napoleonborough','2000-07-06 03:00:56', '2006-09-02 17:29:53'),
(18,'m','Gottliebfurt','1953-12-13 22:56:13', '2001-01-25 18:03:21'),
(19,'f','Bartonberg', '1958-03-07 08:40:56','1971-02-23 05:04:53'),
(20,'f','Port Cullenville','2008-09-03 11:34:47', '2010-04-18 19:40:28');


INSERT INTO `users_communities` VALUES 
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6),
(7,7),
(8,8),
(9,9),
(10,10),
(11,11),
(12,12),
(13,13),
(14,14),
(15,15),
(16,16),
(17,17),
(18,18),
(19,19),
(20,20);

INSERT INTO `media` VALUES 
(1,1,1,'Saepe molestiae voluptatem fuga exercitationem quia laudantium consectetur.Reprehenderit rerum est dicta quia voluptatem. Sed enim corporis est et. Ratione aut corporis explicabo sint. Animi iste facilis aliquam eos.','quis',88902,NULL,'1989-07-02 16:02:08','2009-09-09 15:32:01'),
(2,2,2,'Vel qui assumenda rerum et sit ullam. Sint molestiae est facere excepturi distinctio. Inventore molestiae aut ut consequatur aut. Quia rerum omnis eum aliquam.','blanditiis',72,NULL,'2009-04-02 05:38:19','1998-12-16 12:37:35'),
(3,3,3,'Explicabo ducimus aut molestias placeat sed nisi ut qui. Qui ut quia reprehenderit sed nisi officiis. Officiis explicabo sed officia velit iure eveniet et.','inventore',77301987,NULL,'1977-10-24 04:30:50','1994-10-01 03:23:28'),
(4,4,4,'Rerum laborum iusto et minus illo. Recusandae corporis tenetur sunt magni ab repudiandae. Velit molestiae exercitationem id soluta nisi quo fugit.','cumque',0,NULL,'1973-09-14 08:21:21','1970-03-20 00:12:44'),
(5,5,5,'Enim cum repudiandae cum aut nemo assumenda et. Aut quia iusto fugiat sit in earum ea dolorum. Nisi odio est labore doloremque quos.','rerum',7,NULL,'2019-05-11 01:16:09','1991-01-06 23:02:53'),
(6,6,6,'Qui reiciendis inventore quo hic. Quia aliquam velit error ipsam. Quam voluptatum eligendi consequatur. Officiis error vel neque quia eveniet et vero. Unde sed quam necessitatibus.','voluptate',22,NULL,'1976-12-12 10:03:07','2022-05-12 15:41:16'),
(7,7,7,'Sed alias molestiae aut nostrum. Magnam molestias ut iure tempore. Omnis ducimus molestias hic atque velit.','modi',7145736,NULL,'2010-02-25 23:57:00','2009-10-09 21:18:04'),
(8,8,8,'Possimus ea vel eaque. Voluptas occaecati quo velit ipsam.','officiis',90,NULL,'1991-10-06 14:46:55','1997-02-05 04:30:12'),
(9,9,9,'Itaque autem maxime ut a blanditiis et ipsum sit. Cum est similique recusandae voluptatem sit ut odit quia. Rerum quae temporibus exercitationem temporibus.','eos',73281,NULL,'2002-12-12 19:04:09','1988-07-26 12:38:44'),
(10,10,10,'Aliquam sapiente eaque necessitatibus voluptates. Dolorem nihil nostrum reprehenderit cumque reprehenderit.','ut',250801,NULL,'1971-11-02 09:55:58','1973-01-02 00:20:43'),
(11,11,11,'Nesciunt nemo quia reiciendis accusantium corporis natus mollitia veritatis. Cupiditate sed maiores amet ullam facere optio. Et cumque asperiores veritatis nam.','quaerat',29824,NULL,'1983-05-02 13:46:59','1982-10-20 21:08:41'),
(12,12,12,'Neque non tempora vitae et quia qui. Ad ut vero voluptatibus ab. Possimus eveniet vero ut deserunt.','qui',0,NULL,'1981-01-10 16:21:43','1998-05-12 01:59:04'),
(13,13,13,'Ut autem consequatur libero ut ipsum voluptatum qui. Sed nihil animi ex magnam eos provident.','tenetur',64017608,NULL,'1977-11-02 00:59:56','2010-05-04 02:48:42'),
(14,14,14,'Est velit suscipit harum. Quisquam eaque eaque et in. Aut numquam est assumenda optio esse. Vel nihil autem aliquid sit et.','ea',9953247,NULL,'2022-06-20 05:16:21','1994-07-14 09:08:12'),
(15,15,15,'Ratione modi labore nisi et aspernatur. Doloribus eligendi dolorem explicabo ut. Et consequuntur dolor odio voluptatum ut laborum nobis. Necessitatibus aut eligendi animi occaecati doloremque voluptate est aperiam.','ut',741555,NULL,'1989-08-07 20:13:30','1971-10-28 19:52:19'),
(16,16,16,'Animi iure doloribus ut minus. Voluptatibus ut delectus illum esse. Ipsam voluptatem placeat tenetur repellendus praesentium sit. Quasi harum qui doloribus expedita enim.','inventore',472078377,NULL,'1995-01-29 02:37:40','1973-09-03 07:34:36'),
(17,17,17,'Perspiciatis eos ab quia. Aut et omnis rerum sequi recusandae. Ducimus non temporibus sunt. Tempora consequatur nam accusamus rem quaerat aut omnis illum. Deleniti culpa error nemo ea delectus quia.','consequatur',95004,NULL,'1990-06-09 09:43:20','1988-02-20 21:20:44'),
(18,18,18,'Veritatis voluptas numquam possimus dolor et. Esse nostrum repellendus expedita dolorum illo ut. In ex exercitationem nisi sit. Aut veniam sint maiores quas asperiores tenetur nobis.','et',3095,NULL,'2008-11-05 07:43:25','2020-11-26 10:00:36'),
(19,19,19,'Eum hic officia optio asperiores accusamus reiciendis ut. Aspernatur fugiat hic laborum atque. Eos aut ut qui ab velit cupiditate odit.','ea',3735077,NULL,'2016-02-15 15:23:47','1984-08-01 04:51:45'),
(20,20,20,'Quia asperiores consequatur doloribus incidunt. Alias voluptate aperiam quidem occaecati nihil minus. Qui iusto quaerat rerum eius illum hic voluptas.','impedit',4,NULL,'2016-02-19 21:20:22','2008-08-19 19:22:20')
;

INSERT INTO `likes` VALUES 
(1,1,1,'2012-05-05 00:17:10'),
(2,2,2,'1988-05-04 21:10:57'),
(3,3,3,'1996-05-09 11:42:16'),
(4,4,4,'1990-10-22 10:35:12'),
(5,5,5,'1988-09-23 07:06:25'),
(6,6,6,'1975-08-27 14:50:04'),
(7,7,7,'1970-03-03 19:26:20'),
(8,8,8,'2018-04-08 14:52:31'),
(9,9,9,'2010-12-24 01:59:06'),
(10,10,10,'2021-09-16 11:15:11'),
(11,11,11,'2002-03-31 14:19:14'),
(12,12,12,'2015-06-29 10:19:54'),
(13,13,13,'2004-07-15 03:42:47'),
(14,14,14,'2022-06-07 20:34:33'),
(15,15,15,'2011-01-22 23:35:23'),
(16,16,16,'1978-08-07 03:52:41'),
(17,17,17,'1996-12-06 13:54:38'),
(18,18,18,'2020-11-23 14:02:13'),
(19,19,19,'2000-10-23 01:09:07'),(
20,20,20,'1974-06-21 02:30:02');


INSERT  IGNORE  INTO friend_requests (initiator_user_id, target_user_id, status)
VALUES 
('1','2','approved'),
('1', '3', 'requested'),
('2','3','declined'),
('3', '4', 'unfriended'),
('1','5','approved'),
('1', '6', 'requested'),
('2','7','declined'),
('3', '8', 'unfriended'),
('4','2','approved'),
('4', '6', 'requested'),
('4','5','declined'),
('13', '18', 'unfriended'),
('14','12','approved'),
('14', '6', 'requested'),
('14','5','declined'),
('14', '6', 'unfriended'),
('14','7','approved'),
('14', '8', 'requested'),
('14','9','declined'),
('14', '10', 'unfriended')
;

INSERT INTO neus_types (id, name)
VALUES 
(1,'video'),
(2,'txt'),
(3,'video'),
(4,'txt'),
(5, 'video'),
(6, 'video'),
(7, 'txt'),
(8, 'video'),
(9, 'txt'),
(10, 'video'),
(11,'txt'),
(12, 'txt'),
(13,'video'),
(14,'txt'),
(15,'video'),
(16, 'txt'),
(17, 'video'),
(18,'txt'),
(19,'txt'),
(20, 'video');


INSERT INTO neus (id, neus_id, neus_name, neus_type_id, data_neus, body)
VALUES 
(1, 1, 'Possimus ea vel eaque.','1','1997-02-05 04:30:12','dgager5yhg'),
(2, 2, 'Possimus ea vel eaque.','2','1997-02-05 04:30:12','sfgdrrhgshghyhy'),
(3, 3, 'Itaque autem maxime ut a blanditiis et ipsum sit.','3','1988-07-26 12:38:44','gseryujykfk,'),
(4, 4, 'Sed alias molestiae aut nostrum','4', '2009-10-09 21:18:04','dfhstruytrkjhmkhfg'),
(5, 5, 'Qui reiciendis inventore quo hic.','5','2022-05-12 15:41:16','dwea4trhst3124ytrh'),
(6, 6, 'Aliquam sapiente eaque necessitatibus voluptates.','6','1973-01-02 00:20:43','dfstkjh;oy'),
(7, 7, 'Et cumque asperiores veritatis nam.','7', '1982-10-20 21:08:41','dxhjhjyutrrefgg'),
(8, 8, 'Ad ut vero voluptatibus ab.','8','1998-05-12 01:59:04',',.l/k;higjkhfhdg'),
(9, 9, 'Ut autem consequatur libero ut ipsum voluptatum qui','9', '2010-05-04 02:48:42','jhaolyftewkghbjk/blk;rj3ui4y'),
(10, 10, 'Quisquam eaque eaque et in','10', '1994-07-14 09:08:12','proywiyhoglkfnsbjkhf;ukfj'),
(11, 11, 'Necessitatibus aut eligendi animi occaecati doloremque voluptate est aperiam.','11','1971-10-28 19:52:19','poiuryhi tjhblkfnbl'),
(12, 12, 'Animi iure doloribus ut minus.','12', '1973-09-03 07:34:36','p[oi80yhiog;o785'),
(13, 13, 'Perspiciatis eos ab quia.','13', '1988-02-20 21:20:44',';ioytgv;'),
(14, 14, 'Esse nostrum repellendus expedita dolorum illo ut.','14', '2020-11-26 10:00:36','862uyutligf'),
(15, 15, 'Alias voluptate aperiam quidem occaecati nihil minus','15', '2016-02-19 21:20:22','ioy;gbutgo67rlu'),
(16, 16, 'Enim cum repudiandae cum aut nemo assumenda et','16', '1991-01-06 23:02:53','dpi7p986ig;uif'),
(17, 17, 'Quam voluptatum eligendi consequatur.','17', '1976-12-12 10:03:07','98[t;gkvgu.f'),
(18, 18, 'Voluptatum eligendi consequatur.','18','2011-12-12 10:03:07','[97-96;g/uirtp7r'),
(19, 19, 'Sed alias molestiae aut nostrum.','19', '2010-02-25 23:57:00','079phb/oitp87'),
(20, 20, 'Possimus ea vel eaque.', '20', '1991-10-06 14:46:55','p987.fiyri7');


INSERT INTO users_neus (neus_id, users_id) VALUES 
(1,1), (2,2), (3,3), (4,4), (5,5), (6,6), (7,7), (8,8), (9,9), (10,10), 
(11,11), (12,12), (13,13), (14,14), (15,15), (16,16), (17,17), (18,18), (19,19), (20,20);

/* Задача 2. 
 Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений 
 в алфавитном порядке */

SELECT DISTINCT firstname 
FROM users 
ORDER BY firstname;

/* Задача 3.
 Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных 
 (поле is_active = false). Предварительно добавить такое поле в таблицу profiles
  со значением по умолчанию = true (или 1)*/ 

ALTER TABLE profiles 
ADD is_active BIT DEFAULT TRUE NULL;


UPDATE profiles
SET
	is_active = false
WHERE (YEAR(CURRENT_DATE) - YEAR(birthday)) < 18;


SELECT birthday FROM profiles
WHERE (YEAR(CURRENT_DATE) - YEAR(birthday)) < 18;

/* Задача 4.
Написать скрипт, удаляющий сообщения «из будущего» (дата больше сегодняшней)*/ 

SELECT id, created_at, body FROM messages
WHERE created_at > NOW()
ORDER BY created_at;


DELETE FROM messages
WHERE created_at > NOW();

/* Задача 5. 
Написать название темы курсового проекта (в комментарии) 
Планируется база данных "Потребительская корзина" на однну семью.
На данный момент запланированно создать следующие таблицы
human - членны семь и их профили
shop - сети магазинов, карты, скидки по картам
Goods - набор стандартных товаров (хлеб, молоко, сыр, ..., одежда, обувь,...)
purchases - совершенные покупки (товар, дата, цена, скидка)
food preferences - любимые блюда для каждого члена семьи
food - список блюд которые вообще можно приготовить (продукты, колличество на порцию, время приготовления)
nutritional value - пищевая ценность (коллории, микроэлементы, норма потребления)
*/