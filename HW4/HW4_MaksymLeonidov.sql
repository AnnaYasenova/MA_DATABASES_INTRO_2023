
/*
    1. Вивести всі фільми, видані в прокат менеджером Mike Hillyer.
       Для визначення менеджера використати таблицю staff і поле staff_id;
       для визначення фільму скористатися таблицею inventory (поле inventory_id), і
       таблиці film (поле film_id).
       (Це завдання ви виконували в другому ДЗ,
       цього разу для виконання завдання потрібно використати common table expression)
*/
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

/*
    2. Вивести користувачів, що брали в оренду фільми
       SWEETHEARTS SUSPECTS, TEEN APOLLO, TIMBERLAND SKY, TORQUE BOUND.
       (Це завдання ви виконували в другому ДЗ,
       цього разу для виконання завдання потрібно використати common table expression)
*/
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

/*
    3. Вивести список фільмів, неповернених в прокат, replacement_cost яких більший 10 доларів.
*/
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

/*
    4. Виведіть назву фільму та загальну кількість грошей
    отриманих від здачі цього фільму в прокат
    (таблиці payment, rental, inventory, film)
*/
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

/*
    5. Виведіть кількість rental, які були повернуті і кількість тих,
       які не були повернуті в прокат.
*/

-- 5.1
SELECT
    COUNT(CASE WHEN return_date IS NOT NULL THEN 1 END) AS "Returned Rental",
    COUNT(CASE WHEN return_date IS NULL THEN 1 END) AS "Not Returned Rental"
FROM rental;

-- 5.2
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

/*
    6. Напишіть запит, що повертає поля "customer", "total_amount".
       За основу взяти таблицю sakila.payment.
       Total_amount - це сума грошей, які заплатив кожен користувач за фільми,
       що брав у прокат.
       Результат має відображати лише тих користувачів, що заплатили більше ніж 190 доларів.
       Customer - це конкатенація першої літери імені та прізвища користувача.
       Наприклад Alan Lipton має бути представлений як A. Lipton.
*/
SELECT
    CONCAT(SUBSTR(c.first_name, 1, 1), '. ', c.last_name) AS customer,
    SUM(amount) AS total_amount
FROM payment AS p
JOIN customer AS c
    ON c.customer_id = p.customer_id
GROUP BY c.customer_id
HAVING total_amount > 190;

/*
    7. Виведіть інформацію про фільми, тривалість яких найменша
       (в даному випадку потрібно використати підзапит з агрегаційною функцією).
       Вивести потрібно назву фільму, категорію до якої він відноситься,
       прізвища та імена акторів які знімалися в фільмі.
*/
SELECT
    f.title AS "Film Title",
    c.name AS "Film Category",
    GROUP_CONCAT(
        CONCAT_WS(' ', a.first_name, a.last_name)
        SEPARATOR '; '
    ) AS "Actors"
FROM film AS f
JOIN film_category AS fc
    ON f.film_id = fc.film_id
JOIN category AS c
    ON c.category_id = fc.category_id
JOIN film_actor AS fa
    ON fa.film_id = f.film_id
JOIN actor AS a
    ON a.actor_id = fa.actor_id
WHERE f.length = (SELECT MIN(length) FROM film)
GROUP BY f.film_id, c.name;

/*
    8. Категоризуйте фільми за ознакою rental_rate наступним чином:
       якщо rental_rate нижчий за 2 - це фільм категорії low_rental_rate,
       якщо rental_rate від 2 до 4 - це фільм категорії medium_rental_rate,
       якщо rental_rate більший за 4 - це фільм категорії high_rental_rate.
       Відобразіть кількість фільмів що належать до кожної з категорій.
*/

-- 8.1
SELECT
    COUNT(CASE WHEN rental_rate < 2 THEN 1 END) AS 'low_rental_rate',
    COUNT(CASE WHEN rental_rate BETWEEN 2 AND 4 THEN 1 END) AS 'medium_rental_rate',
    COUNT(CASE WHEN rental_rate > 4 THEN 1 END) AS 'high_rental_rate'
FROM film;

-- 8.2
SELECT
    CASE
        WHEN rental_rate < 2 THEN 'low_rental_rate'
        WHEN rental_rate BETWEEN 2 AND 4 THEN 'medium_rental_rate'
        ELSE 'high_rental_rate'
    END AS rental_rate_category,
    COUNT(*) AS 'Number of Films'
FROM film
GROUP BY rental_rate_category;

-- 8.3
SELECT
    'low_rental_rate' AS rental_rate_category,
    COUNT(*) AS 'Number of Films'
FROM film
WHERE rental_rate < 2

UNION ALL

SELECT
    'medium_rental_rate',
    COUNT(*)
FROM film
WHERE rental_rate BETWEEN 2 AND 4

UNION ALL

SELECT
    'high_rental_rate',
    COUNT(*)
FROM film
WHERE rental_rate > 4;

-- 8.4
WITH fl_cte AS (
    SELECT
        COUNT(*) AS "low_rental_rate"
    FROM film
    WHERE rental_rate < 2
), fm_cte AS (
    SELECT
        COUNT(*) AS "medium_rental_rate"
    FROM film
    WHERE rental_rate BETWEEN 2 AND 4
), fh_cte AS (
    SELECT
        COUNT(*) AS "high_rental_rate"
    FROM film
    WHERE rental_rate > 4
)
SELECT *
FROM fl_cte
JOIN fm_cte
JOIN fh_cte;
