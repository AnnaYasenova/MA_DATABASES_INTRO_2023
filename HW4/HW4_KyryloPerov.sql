-- 1. Вивести всі фільми, видані в прокат менеджером Mike Hillyer. Для
-- визначення менеджера використати таблицю staff і поле staff_id; для
-- визначення фільму скористатися таблицею inventory (поле inventory_id), і
-- таблиці film (поле film_id). (Це завдання ви виконували в другому ДЗ, цього
-- разу для виконання завдання потрібно використати common table
-- expression)

WITH staff_cte AS (
	SELECT staff_id
	FROM staff
	WHERE first_name = 'Mike' AND last_name = 'Hillyer'
), rental_cte AS (
	SELECT inventory_id
    FROM rental
    WHERE staff_id IN (SELECT staff_id FROM staff_cte)
), inventory_cte AS (
	SELECT film_id
    FROM inventory
    WHERE inventory_id IN (SELECT inventory_id FROM rental_cte)
)
SELECT DISTINCT title
FROM film
WHERE film_id IN (SELECT film_id FROM inventory_cte);



-- 2 Вивести користувачів, що брали в оренду фільми SWEETHEARTS
-- SUSPECTS, TEEN APOLLO, TIMBERLAND SKY, TORQUE BOUND. (Це
-- завдання ви виконували в другому ДЗ, цього разу для виконання завдання
-- потрібно використати common table expression)

WITH film_cte AS (
	SELECT film_id
	FROM film
	WHERE title IN ('SWEETHEARTS SUSPECTS', 'TEEN APOLLO', 'TIMBERLAND SKY', 'TORQUE BOUND')
), inventory_cte AS (
	SELECT inventory_id
    FROM inventory
    WHERE film_id IN (SELECT film_id FROM film_cte)
), rental_cte AS (
	SELECT customer_id
    FROM rental
    WHERE inventory_id IN (SELECT inventory_id FROM inventory_cte)
)
SELECT DISTINCT	
	first_name AS "First Name", 
	last_name AS "Last Name"
FROM customer 
WHERE customer_id IN (SELECT customer_id FROM rental_cte)
ORDER BY first_name;



-- 3 Вивести список фільмів, неповернених в прокат, replacement_cost яких
-- більший 10 доларів.

WITH rental_cte AS (
	SELECT inventory_id FROM rental
	WHERE return_date IS NULL
), inventory_cte AS (
	SELECT film_id FROM inventory
    WHERE inventory_id IN (SELECT * FROM rental_cte)
)
SELECT title
FROM film
WHERE film_id IN (SELECT * FROM inventory_cte)
	AND replacement_cost > 10;



-- 4 Виведіть назву фільму та загальну кількість грошей отриманих від здачі
-- цього фільму в прокат (таблиці payment, rental, inventory, film)

SELECT
    f.title,
    SUM(p.amount) AS "Total Amount"
FROM film AS f
JOIN inventory AS i
    ON i.film_id = f.film_id
JOIN rental AS r
    ON r.inventory_id = i.inventory_id
JOIN payment AS p
    ON p.rental_id = r.rental_id
GROUP BY f.film_id;



-- 5 Виведіть кількість rental, які були повернуті і кількість тих, які не були
-- повернуті в прокат.

WITH returned_cte AS (
    SELECT
        COUNT(*) AS "Returned"
    FROM rental
    WHERE return_date IS NOT NULL
), not_returned_cte AS (
    SELECT
        COUNT(*) AS "Not Returned"
    FROM rental
    WHERE return_date IS NULL
)
SELECT *
FROM returned_cte
JOIN not_returned_cte;



-- 6 Напишіть запит, що повертає поля “customer”, “total_amount”. За основу
-- взяти таблицю sakila.payment. Total_amount - це сума грошей, які заплатив
-- кожен користувач за фільми, що брав у прокат. Результат має відображати
-- лише тих користувачів, що заплатили більше ніж 190 доларів. Customer - це
-- конкатенація першої літери імені та прізвища користувача. Наприклад Alan
-- Lipton має бути представлений як A. Lipton.

WITH payment_cte AS (
	SELECT customer_id, SUM(amount) AS total_amount
    FROM payment
	GROUP BY customer_id
),
	customer_cte AS (
	SELECT customer_id, CONCAT(SUBSTRING(first_name, 1, 1), '. ', last_name) AS customer 
    FROM customer
    WHERE customer_id IN (SELECT customer_id FROM payment_cte)
)
SELECT c_cte.customer, p_cte.total_amount FROM customer_cte AS c_cte
JOIN payment_cte AS p_cte ON c_cte.customer_id = p_cte.customer_id
WHERE p_cte.total_amount > 190;



-- 7 Виведіть інформацію про фільми, тривалість яких найменша (в даному
-- випадку потрібно використати підзапит з агрегаційною функцією). Вивести
-- потрібно назву фільму, категорію до якої він відноситься, прізвища та імена
-- акторів які знімалися в фільмі.

WITH actor_cte AS (
	SELECT 
		actor_id, 
        CONCAT(first_name, ' ', last_name) AS actor
    FROM actor
)
SELECT 
	f.title, 
    c.name AS category, 
    a_cte.actor 
FROM film AS f
JOIN film_category AS f_c
	ON f_c.film_id = f.film_id
JOIN category AS c
	ON c.category_id = f_c.category_id
JOIN film_actor AS f_a
	ON f_a.film_id = f.film_id
JOIN actor_cte AS a_cte
	ON a_cte.actor_id = f_a.actor_id
WHERE f.length = (SELECT MIN(length) FROM film);



-- 8 Категоризуйте фільми за ознакою rental_rate наступним чином: якщо
-- rental_rate нижчий за 2 - це фільм категорії low_rental_rate, якщо rental_rate
-- від 2 до 4 - це фільм категорії medium_rental_rate, якщо rental_rate більший
-- за 4 - це фільм категорії high_rental_rate. Відобразіть кількість фільмів що
-- належать до кожної з категорій.

SELECT
    COUNT(CASE WHEN rental_rate < 2 THEN 1 END) AS 'low_rental_rate',
    COUNT(CASE WHEN rental_rate BETWEEN 2 AND 4 THEN 1 END) AS 'medium_rental_rate',
    COUNT(CASE WHEN rental_rate > 4 THEN 1 END) AS 'high_rental_rate'
FROM film;