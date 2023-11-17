# 1 Вивести всі фільми, видані в прокат менеджером Mike Hillyer. Для
# визначення менеджера використати таблицю staff і поле staff_id; для
# визначення фільму скористатися таблицею inventory (поле inventory_id), і
# таблиці film (поле film_id).
#(за допомогою cte = common table expression)

WITH staff_cte AS (
	SELECT staff_id
    FROM staff
	WHERE first_name = "Mike" AND last_name = "Hillyer"
),
	rental_cte AS (
    SELECT inventory_id
    FROM rental
    WHERE staff_id IN (SELECT staff_id FROM staff_cte)
),    
    inventory_cte AS (
	SELECT film_id
    FROM inventory
    WHERE inventory_id IN (SELECT inventory_id FROM rental_cte)
),
	film_cte AS (
	SELECT title
    FROM film
    WHERE film_id IN (SELECT film_id FROM inventory_cte)
)
SELECT title FROM film_cte;




# 2 Вивести користувачів, що брали в оренду фільми SWEETHEARTS
# SUSPECTS, TEEN APOLLO, TIMBERLAND SKY, TORQUE BOUND.
# (за допомогою cte = common table expression)

WITH film_cte AS (
	SELECT film_id
    FROM film
    WHERE title in ("SWEETHEARTS", "SUSPECTS", "TEEN APOLLO", "TIMBERLAND SKY", "TORQUE BOUND")
),
	inventory_cte AS (
    SELECT inventory_id
    FROM inventory
    WHERE film_id IN (SELECT film_id FROM film_cte)
),
	customer_cte AS (
	SELECT customer_id
    FROM rental
    WHERE inventory_id IN (SELECT inventory_id FROM inventory_cte)
)
SELECT first_name, last_name FROM customer
WHERE customer_id IN (SELECT customer_id FROM customer_cte);




# 3 Вивести список фільмів, неповернених в прокат, replacement_cost
# яких більший 10 доларів.
WITH rental_cte AS (
	SELECT inventory_id
    FROM rental
    WHERE return_date IS NULL
),
	inventory_cte AS (
	SELECT film_id
    FROM inventory
    WHERE inventory_id IN (SELECT inventory_id FROM rental_cte)
),
	film_cte AS (
	SELECT title
    FROM film
    WHERE film_id IN (SELECT film_id FROM inventory_cte)
    AND replacement_cost > 10
)
SELECT title FROM film_cte;





# 4 Виведіть назву фільму та загальну кількість грошей отриманих від 	
# здачі цього фільму в прокат (таблиці payment, rental, inventory, film)

-- title, film_id FROM film - 
-- film_id, inventory_id FROM inventory -
-- inventory_id, rental_id FROM rental -
-- amount, rental_id FROM payment

WITH payment_cte AS (
	SELECT rental_id, SUM(amount) AS total_rental_amount
    FROM payment
    GROUP BY rental_id
    ORDER BY total_rental_amount DESC
)
SELECT f.title, cte.total_rental_amount FROM payment_cte AS cte
JOIN rental AS r ON r.rental_id = cte.rental_id
JOIN inventory AS i ON i.inventory_id = r.inventory_id
JOIN film AS f ON f.film_id = i.film_id;




# 5  Виведіть кількість rental, які були повернуті і кількість тих,
# які не були повернуті в прокат
SELECT
	COUNT(CASE WHEN return_date IS NOT NULL THEN 1 END) AS "returned",
	COUNT(CASE WHEN return_date IS NULL THEN 1 END) AS "not returned"
FROM rental;




# 6 Напишіть запит, що повертає поля “customer”, “total_amount”. За основу
# взяти таблицю sakila.payment. Total_amount - це сума грошей, які заплатив
# кожен користувач за фільми, що брав у прокат. Результат має відображати
# лише тих користувачів, що заплатили більше ніж 190 доларів. Customer - це
# конкатенація першої літери імені та прізвища користувача. Наприклад Alan
# Lipton має бути представлений як A. Lipton.

-- customer whos -- total_amount >190
-- customer = CONCAT(A. Lipton)
-- total_amount = SUM(amount) AS total_amount FROM payment WHERE total_amount > 190
-- first_name, last_name, customer_id FROM customer
-- customer_id, total_amount FROM payment

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
SELECT ccte.customer, pcte.total_amount FROM customer_cte AS ccte
JOIN payment_cte AS pcte ON ccte.customer_id = pcte.customer_id
WHERE pcte.total_amount > 190;





# 7 Виведіть інформацію про фільми, тривалість яких найменша (в даному
# випадку потрібно використати підзапит з агрегаційною функцією). Вивести
# потрібно назву фільму, категорію до якої він відноситься, прізвища та імена
# акторів які знімалися в фільмі.

-- title, film_id, length FROM film
-- film_id, category_id FROM film_category
-- category_id, name FROM category
-- film_id, actor_id FROM film_actor
-- actor_id, actor CONCAT() FROM actor

WITH actor_cte AS (
	SELECT actor_id, CONCAT(first_name, ' ', last_name) AS actor
    FROM actor
)
SELECT f.title, c.name AS category, acte.actor FROM film f
JOIN film_category AS fc
	ON fc.film_id = f.film_id
JOIN category AS c
	ON c.category_id = fc.category_id
JOIN film_actor AS fa
	ON fa.film_id = f.film_id
JOIN actor_cte AS acte
	ON acte.actor_id = fa.actor_id
WHERE f.length = (SELECT MIN(length) FROM film);





# 8 Категоризуйте фільми за ознакою rental_rate наступним чином: якщо
# rental_rate нижчий за 2 - це фільм категорії low_rental_rate, якщо rental_rate
# від 2 до 4 - це фільм категорії medium_rental_rate, якщо rental_rate більший
# за 4 - це фільм категорії high_rental_rate. Відобразіть кількість фільмів що
# належать до кожної з категорій.

-- WHEN rental_rate <2 THEN "low_rental_rate"
-- WHEN rental_rate >=2 AND rental_rate <4 THEN "medium_rental_rate"
-- WHEN rental_rate >=4 THEN "high_rental_rate"

WITH film_cte as (
	SELECT 
		film_id,
		CASE
			WHEN rental_rate <2 THEN "low_rental_rate"
            WHEN rental_rate >=2 AND rental_rate <4 THEN "medium_rental_rate"
            WHEN rental_rate >=4 THEN "high_rental_rate"
		END AS rental_rate
	FROM film
)
SELECT rental_rate, COUNT(*) AS films_with_rate
FROM film_cte
GROUP BY rental_rate;


## 8
SELECT
	COUNT(CASE WHEN rental_rate <2 THEN 1 END) AS low_rental_rate,
    COUNT(CASE WHEN rental_rate >=2 AND rental_rate <4 THEN 1 END) AS medium_rental_rate,
    COUNT(CASE WHEN rental_rate >=4 THEN 1 END) AS high_rental_rate
FROM film;