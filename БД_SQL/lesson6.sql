 /* Задача № 1
 Пусть задан некоторый пользователь. 
 Из всех пользователей соц. сети найдите человека, который больше всех общался 
 с выбранным пользователем (написал ему сообщений).*/
 
 SELECT id, firstname, lastname  FROM users
 	WHERE id = (SELECT from_user_id FROM messages 
	WHERE to_user_id = 1
	GROUP BY from_user_id
	ORDER BY count(from_user_id) DESC
	LIMIT 1);
	
-- почему если убрать limit 1  запрос не работает, при этом сам подзапрос вполне жизнеспособен?
SELECT from_user_id, count(*) FROM messages 
	WHERE to_user_id = 1
	GROUP BY from_user_id
	ORDER BY count(from_user_id) DESC;


/* Задача № 2
 Подсчитать общее количество лайков, которые получили пользователи младше 10 лет*/

SELECT  user_id 
	FROM profiles
	WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 10; -- всего 9 пользователей младше 10
	-- из них лайки получил один
SELECT media_id, COUNT(*) as 'likes count'
FROM likes
WHERE user_id IN (
	SELECT user_id 
	FROM profiles
	WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 10);
	
/* Задача № 3
 Определить кто больше поставил лайков (всего): мужчины или женщины*/

SELECT
CASE (gender)
         WHEN 'm' THEN 'мужчин'
         WHEN 'f' THEN 'женщин'
END AS 'gender', COUNT(*)
FROM profiles
WHERE user_id IN (
	SELECT user_id
	FROM likes)
GROUP BY gender 
LIMIT 1;