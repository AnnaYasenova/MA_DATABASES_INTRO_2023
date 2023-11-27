#Вивести всі фільми, видані в прокат менеджером Mike Hillyer. Для
#визначення менеджера використати таблицю staff і поле staff_id; для
#визначення фільму скористатися таблицею inventory (поле inventory_id), і
#таблиці film (поле film_id). (Це завдання ви виконували в другому ДЗ, цього
#разу для виконання завдання потрібно використати common table
#expression)

WITH specific_staff_cte AS (
    SELECT staff_id
    FROM staff
    WHERE first_name = "Mike" AND last_name = "Hillyer"
), specific_staff_rental_cte AS (
    SELECT inventory_id
    FROM rental
    WHERE staff_id = (
        SELECT staff_id FROM specific_staff_cte
    )
), specific_staff_inventory_cte AS (
    SELECT film_id
    FROM inventory
    WHERE inventory_id IN (
        SELECT inventory_id
        FROM specific_staff_rental_cte
    )
)
SELECT DISTINCT
    title
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM specific_staff_inventory_cte
);

#Вивести користувачів, що брали в оренду фільми SWEETHEARTS
#SUSPECTS, TEEN APOLLO, TIMBERLAND SKY, TORQUE BOUND. (Це
#завдання ви виконували в другому ДЗ, цього разу для виконання завдання
#потрібно використати common table expression)

WITH specific_films_cte AS (
    SELECT film_id
    FROM film
    WHERE title IN ("SWEETHEARTS SUSPECTS", "TEEN APOLLO", "TIMBERLAND SKY", "TORQUE BOUND")
), specific_films_inventory_cte AS (
    SELECT inventory_id
    FROM inventory
    WHERE film_id IN (
        SELECT film_id
        FROM specific_films_cte
    )
), specific_films_rental_cte AS (
    SELECT customer_id
    FROM rental
    WHERE inventory_id IN (
        SELECT inventory_id
        FROM specific_films_inventory_cte
    )
)
SELECT
    c.last_name,
    c.first_name
FROM customer AS c
WHERE c.customer_id IN (
    SELECT customer_id
    FROM specific_films_rental_cte
);

#Вивести список фільмів, неповернених в прокат, replacement_cost яких
#більший 10 доларів.

WITH not_returned_films_inventory_cte AS (
    SELECT inventory_id
    FROM rental
    WHERE return_date IS NULL
), not_returned_films_cte AS (
    SELECT DISTINCT film_id
    FROM inventory
    WHERE inventory_id IN (
        SELECT inventory_id
        FROM not_returned_films_inventory_cte
    )
)
SELECT
    title
FROM film
WHERE film_id IN (
    SELECT film_id
    FROM not_returned_films_cte
) AND replacement_cost > 10;

#Виведіть назву фільму та загальну кількість грошей отриманих від здачі
#цього фільму в прокат (таблиці payment, rental, inventory, film)

SELECT
    f.title AS film_title,
    SUM(p.amount) AS total_revenue
FROM
    payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
GROUP BY
    f.title;
    
#Виведіть кількість rental, які були повернуті і кількість тих, які не були
#повернуті в прокат.

SELECT
    COUNT(CASE WHEN return_date IS NOT NULL THEN 1 END) AS returned_rentals,
    COUNT(CASE WHEN return_date IS NULL THEN 1 END) AS not_returned_rentals
FROM
    rental;
    
SELECT
    CASE
        WHEN return_date IS NULL THEN "Not Returned"
        ELSE "Returned"
    END AS Rental_Status,
    COUNT(*) AS "Number of Rental"
FROM rental
GROUP BY Rental_Status;

-- 5.3
SELECT
    "Returned" AS "Rental Status",
    COUNT(*) AS "Number of Rental"
FROM rental
WHERE return_date IS NOT NULL

UNION ALL

SELECT
    "Not Returned",
    COUNT(*)
FROM rental
WHERE return_date IS NULL;

-- 5.4
WITH returned_rental_cte AS (
    SELECT
        COUNT(*) AS "Returned Rental"
    FROM rental
    WHERE return_date IS NOT NULL
), not_returned_rental_cte AS (
    SELECT
        COUNT(*) AS "Not Returned Rental"
    FROM rental
    WHERE return_date IS NULL
)
SELECT *
FROM returned_rental_cte
JOIN not_returned_rental_cte;

#Напишіть запит, що повертає поля “customer”, “total_amount”. За основу
#взяти таблицю sakila.payment. Total_amount - це сума грошей, які заплатив
#кожен користувач за фільми, що брав у прокат. Результат має відображати
#лише тих користувачів, що заплатили більше ніж 190 доларів. Customer - це
#конкатенація першої літери імені та прізвища користувача. Наприклад Alan
#Lipton має бути представлений як A. Lipton.

SELECT
    CONCAT(SUBSTRING(customer.first_name, 1, 1), '. ', customer.last_name) AS customer,
    SUM(payment.amount) AS total_amount
FROM
    payment
    JOIN customer ON payment.customer_id = customer.customer_id
GROUP BY
    customer.customer_id
HAVING
    total_amount > 190;
    
#Виведіть інформацію про фільми, тривалість яких найменша (в даному
#випадку потрібно використати підзапит з агрегаційною функцією). Вивести
#потрібно назву фільму, категорію до якої він відноситься, прізвища та імена
#акторів які знімалися в фільмі.

SELECT
    f.title AS film_title,
    c.name AS category,
    GROUP_CONCAT(CONCAT(a.last_name, ' ', a.first_name) ORDER BY fa.actor_id) AS actors
FROM
    film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    JOIN film_actor fa ON f.film_id = fa.film_id
    JOIN actor a ON fa.actor_id = a.actor_id
WHERE
    f.length = (SELECT MIN(length) FROM film)
GROUP BY
    f.film_id, c.category_id;
    
#Категоризуйте фільми за ознакою rental_rate наступним чином: якщо
#rental_rate нижчий за 2 - це фільм категорії low_rental_rate, якщо rental_rate
#від 2 до 4 - це фільм категорії medium_rental_rate, якщо rental_rate більший
#за 4 - це фільм категорії high_rental_rate. Відобразіть кількість фільмів що
#належать до кожної з категорій.

SELECT
    CASE
        WHEN rental_rate < 2 THEN 'low_rental_rate'
        WHEN rental_rate >= 2 AND rental_rate <= 4 THEN 'medium_rental_rate'
        WHEN rental_rate > 4 THEN 'high_rental_rate'
    END AS rental_rate_category,
    COUNT(*) AS film_count
FROM
    film
GROUP BY
    rental_rate_category;