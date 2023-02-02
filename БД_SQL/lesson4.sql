/* Домашняя работа №3 
Практическое задание по теме “Введение в проектирование БД”
Написать крипт, добавляющий в БД vk, которую создали на занятии, 3 новые таблицы (с перечнем полей, указанием индексов и внешних ключей)
тема DDL = data Definition language (язык определения данных)
Набор команд create  - создание
alter - правка
drop  - удаление */


DROP DATABASE IF EXISTS vk; # удаляем базу данных ВК в том случае если она есть
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	firstname VARCHAR(50),
	lastname VARCHAR(50),
	amail VARCHAR(100) UNIQUE,
	phone BIGINT UNSIGNED,
	INDEX idx_users_usernsme (firstname,lastname)
)COMMENT 'юзеры...';


DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	gender CHAR(1),
	hometown VARCHAR(50),
	#berthday DATETIME,
	created_at DATETIME DEFAULT NOW()
);
 

ALTER TABLE profiles ADD CONSTRAINT fk_profiles_user_id
FOREIGN KEY (user_id) REFERENCES users (id);


ALTER TABLE profiles ADD COLUMN berthday DATETIME;

ALTER TABLE profiles MODIFY COLUMN berthday DATE;

ALTER TABLE profiles RENAME COLUMN berthday TO data_of_birth;

ALTER TABLE profiles DROP COLUMN data_of_birth;

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

/* создам таблици для хранения новостей, типов медиа файлов которыми представленны новости и
списка подписанных на эти новости людей. Таблицы организованы по принципу таблиц mepdia и
communuty*/

DROP TABLE IF EXISTS neus_types;
CREATE TABLE neus_types(
	id SERIAL,
    name VARCHAR(255),
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