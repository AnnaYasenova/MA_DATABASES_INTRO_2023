/*
    1. Вивести прізвища та імена всіх клієнтів (customer), які не повернули фільми в прокат.
*/
SELECT
    CONCAT_WS(' ', c.last_name, c.first_name) AS "Customer with current Rental"
FROM customer AS c
JOIN rental AS r
    ON c.customer_id = r.customer_id
WHERE r.return_date IS NULL
GROUP BY c.customer_id;

SELECT
    CONCAT_WS(' ', c.last_name, c.first_name) AS "Customer with current Rental"
FROM customer AS c
WHERE
    c.customer_id IN (
        SELECT r.customer_id
        FROM rental AS r
        WHERE r.return_date IS NULL
    );

/*
    2. Виведіть список всіх людей наявних в базі даних (таблиці actor, customer, staff).
       Для виконання використайте оператор union.
       Вивести потрібно конкатенацію полів прізвище та ім’я.
*/
SELECT
    CONCAT_WS(' ', a.last_name, a.first_name) AS Person
FROM actor AS a
UNION ALL
SELECT
    CONCAT_WS(' ', c.last_name, c.first_name)
FROM customer AS c
UNION ALL
SELECT
    CONCAT_WS(' ', s.last_name, s.first_name)
FROM staff AS s;

/*
    3. Виведіть кількість міст для кожної країни.
*/
SELECT
    co.country,
    COUNT(*) AS "Number of Cities"
FROM city AS ci
JOIN country AS co
    ON ci.country_id = co.country_id
GROUP BY co.country_id;

SELECT
    (
        SELECT co.country
        FROM country AS co
        WHERE ci.country_id = co.country_id
    ) AS Country,
    COUNT(*) AS "Number of Cities"
FROM city AS ci
WHERE ci.country_id IN (
    SELECT co.country_id
    FROM country AS co
    WHERE ci.country_id = co.country_id
)
GROUP BY Country;

SELECT
    co.country,
    (
        SELECT COUNT(*)
        FROM city AS ci
        WHERE ci.country_id = co.country_id
    ) AS "Number of Cities"
FROM country AS co;

/*
    4. Виведіть кількість фільмів знятих в кожній категорії.
*/
SELECT
    c.name AS "Film Category",
    COUNT(*) AS "Number of Films"
FROM film AS f
JOIN film_category AS fc
    ON f.film_id = fc.film_id
JOIN category AS c
    ON c.category_id = fc.category_id
GROUP BY c.category_id;

SELECT
    c.name AS "Film Category",
    COUNT(*) "Number of Films"
FROM category AS c
JOIN film_category AS fc
    ON fc.category_id = c.category_id
GROUP BY c.category_id;

SELECT
    (
        SELECT c.name
        FROM category AS c
        WHERE c.category_id IN (
            SELECT fc.category_id
            FROM film_category AS fc
            WHERE fc.film_id = f.film_id
        )
    ) AS Category,
    COUNT(*) AS "Number of Films"
FROM film AS f
GROUP BY Category;

SELECT
    c.name,
    (
        SELECT COUNT(*)
        FROM film_category AS fc
        WHERE fc.category_id = c.category_id
    ) AS "Number of Films"
FROM category AS c;


/*
    5. Виведіть кількість акторів що знімалися в кожному фільмі.
*/
SELECT
    f.title AS Film,
    COUNT(*) AS "Number of Actors"
FROM film_actor AS fa
JOIN film AS f
    ON f.film_id = fa.film_id
GROUP BY fa.film_id;

SELECT
    (
        SELECT f.title
        FROM film AS f
        WHERE f.film_id = fa.film_id
    ) AS Film,
    COUNT(*) AS "Number of Actors"
FROM film_actor AS fa
GROUP BY fa.film_id;

SELECT
    f.title AS Film,
    (
        SELECT COUNT(*)
        FROM film_actor AS fa
        WHERE fa.film_id = f.film_id
    ) AS "Number of Actors"
FROM film AS f;

/*
    6. Виведіть кількість акторів що знімалися в кожній категорії фільмів.
*/
SELECT
    c.name AS "Film Category",
    COUNT(*) AS "Number of Actors"
FROM actor AS a
JOIN film_actor AS fa
    ON fa.actor_id = a.actor_id
JOIN film_category AS fc
    ON fc.film_id = fa.film_id
JOIN category AS c
    ON c.category_id = fc.category_id
GROUP BY c.category_id;

SELECT
    c.name AS "Film Category",
    COUNT(*) AS "Number of Actors"
FROM film_actor AS fa
JOIN film_category AS fc
    ON fc.film_id = fa.film_id
JOIN category AS c
    ON c.category_id = fc.category_id
GROUP BY c.category_id;

SELECT
    c.name AS "Film Category",
    (
        SELECT COUNT(*)
            FROM film_actor AS fa
            WHERE fa.film_id IN (
                SELECT fc.film_id
                FROM film_category AS fc
                WHERE fc.category_id = c.category_id
            )
    ) AS "Number of Actors"
FROM category AS c;

/*
    7. Виведіть district та кількість адрес для кожного district,
       за умови, що district починається на "Central".
*/
SELECT
    a.district,
    COUNT(*) AS "Number of Addresses"
FROM address AS a
WHERE district like "Central%"
    AND address IS NOT NULL
GROUP BY a.district;

/*
    8. За допомогою одного запиту вивести кількість фільмів в базі даних,
       мінімальну, середню та максимальну вартість здачі в прокат (rental_rate),
       середню replacement_cost, мінімальну, середню та максимальну тривалість фільмів.
*/
SELECT
    COUNT(*) AS "Number of Films",
    MIN(f.rental_rate) AS "Minimum rental rate",
    AVG(f.rental_rate) AS "Average rental rate",
    MAX(f.rental_rate) AS "Maximum rental rate",
    AVG(f.replacement_cost) AS "Average Replacement Cost",
    MIN(f.length) AS "Minimum Duration of the Film",
    AVG(f.length) AS "Average Duration of the Film",
    MAX(f.length) AS "Maximum Duration of the Film"
FROM film AS f;

/*
    9. Виведіть кількість активних та неактивних клієнтів.(формат: active, кількість клієнтів).
*/
SELECT
    c.active,
    COUNT(*) AS "Number of Customers"
FROM customer AS c
GROUP BY c.active;

/*
   10.Виведіть ім’я та прізвище клієнта, дату його першого та останнього платежу
      та загальну кількість грошей які він заплатив. (таблиці payment, customer)
*/
SELECT
    c.first_name,
    c.last_name,
    MIN(p.payment_date) AS "Date of First Payment",
    MAX(p.payment_date) as "Date of Last Payment",
    SUM(p.amount) AS "Total Amount"
FROM customer AS c
JOIN payment AS p
    ON c.customer_id = p.customer_id
GROUP BY c.customer_id;

SELECT
    c.first_name,
    c.last_name,
    (
        SELECT MIN(p.payment_date)
        FROM payment AS p
        WHERE p.customer_id = c.customer_id
    ) AS "Date of First Payment",
    (
        SELECT MAX(p.payment_date)
        FROM payment AS p
        WHERE p.customer_id = c.customer_id
    ) AS "Date of Last Payment",
    (
        SELECT SUM(p.amount)
        FROM payment AS p
        WHERE p.customer_id = c.customer_id
    ) AS "Total Amount"
FROM customer AS c;
