 /* Задача № 1
 Пусть задан некоторый пользователь. 
 Из всех пользователей соц. сети найдите человека, который больше всех общался 
 с выбранным пользователем (написал ему сообщений).
 
 решение с вложенными запросами из урока №6
 
  SELECT id, firstname, lastname  FROM users
 	WHERE id = (SELECT from_user_id FROM messages 
	WHERE to_user_id = 1
	GROUP BY from_user_id
	ORDER BY count(from_user_id) DESC
	LIMIT 1);
 
 */
use vk;

SELECT u.id, CONCAT (u.firstname, '  ', u.lastname)  
	FROM users AS u
	JOIN messages AS m
	WHERE m.from_user_id = u.id AND m.to_user_id = 1
	GROUP BY m.from_user_id
	ORDER BY count(from_user_id) DESC
	LIMIT 1;


/* Задача № 2
 Подсчитать общее количество лайков, которые получили пользователи младше 10 лет

решение с вложенными запросами из урока №6

SELECT COUNT(*) as 'likes count'
FROM likes
WHERE user_id IN (
	SELECT user_id 
	FROM profiles
	WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 10); */
	

SELECT COUNT(*) AS 'likes count'
FROM likes AS l 
JOIN
profiles AS p 
WHERE p.user_id = l.user_id AND TIMESTAMPDIFF(YEAR, p.birthday, NOW()) < 10
;




/* Задача № 3
 Определить кто больше поставил лайков (всего): мужчины или женщины

решение с вложенными запросами из урока №6

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
LIMIT 1;*/

SELECT CASE (gender)
        WHEN 'm' THEN 'мужчин'
        WHEN 'f' THEN 'женщин'
END AS 'gender', COUNT(*) 
FROM profiles AS  p 
JOIN
likes AS l 
WHERE l.user_id = p.user_id
GROUP BY gender 
LIMIT 1;

