/*
    1. Вивести адресу і місто до якого відноситься ця адреса. (таблиці address, city).
*/
SELECT a.address, c.city
FROM address AS a
JOIN city AS c
    ON a.city_id = c.city_id;

SELECT
    a.address,
    (
        SELECT city
        FROM city AS c
        WHERE a.city_id = c.city_id
    ) AS city
FROM address AS a;

/*
    2. Вивести список міст Аргентини і Австрії. (таблиці city, country). Відсортувати за алфавітом.
*/
SELECT ci.city
FROM city AS ci
JOIN country AS co
    ON ci.country_id = co.country_id
WHERE co.country IN ('Argentina', 'Austria')
ORDER BY ci.city;

SELECT ci.city
FROM city AS ci
WHERE ci.country_id IN (
    SELECT co.country_id
    FROM country AS co
    WHERE co.country IN ('Argentina', 'Austria')
)
ORDER BY ci.city;

/*
    3. Вивести список акторів, що знімалися в фільмах категорій Music, Sports.
       (використати таблиці actor, film_actor, film_category, category).
*/

-- The WITH clause was spied on in class work.
-- I use it here to avoid showing the actor_id in the final result.
WITH actors_cte AS (
    SELECT DISTINCT
        a.first_name,
        a.last_name,
        a.actor_id -- I am forced to use actor_id to get the correct result.
    FROM actor AS a
    JOIN film_actor AS fa
        ON a.actor_id = fa.actor_id
    JOIN film_category AS fc
        ON fa.film_id = fc.film_id
    JOIN category AS c
        ON fc.category_id = c.category_id
    WHERE c.name IN ('Music', 'Sports')
)
SELECT first_name, last_name
FROM actors_cte;

-- Does it make any sense to change the order of the joined tables?
-- For example, if the JOINs from the previous example are written as:
SELECT DISTINCT
    a.first_name,
    a.last_name,
    a.actor_id
FROM category AS c
JOIN film_category AS fc
    ON fc.category_id = c.category_id
JOIN film_actor AS fa
    ON fa.film_id = fc.film_id
JOIN actor AS a
    ON fa.actor_id = a.actor_id
WHERE c.name IN ('Music', 'Sports');

SELECT
    a.first_name,
    a.last_name
FROM actor AS a
WHERE a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor AS fa
    WHERE fa.film_id IN (
        SELECT fc.film_id
        FROM film_category AS fc
        WHERE fc.category_id IN (
            SELECT c.category_id
            FROM category AS c
            WHERE c.name IN ('Music', 'Sports')
        )
    )
);

/*
    4. Вивести всі фільми, видані в прокат менеджером Mike Hillyer.
       Для визначення менеджера використати таблицю staff і поле staff_id;
       для визначення фільму скористатися таблицею inventory (поле inventory_id),
       і таблиці film (поле film_id).
*/
SELECT DISTINCT
    f.title
FROM film AS f
JOIN inventory AS i
    ON f.film_id = i.film_id
JOIN store
    ON store.store_id = i.store_id
JOIN staff
    ON staff.staff_id = store.manager_staff_id
WHERE staff.first_name = 'Mike' AND staff.last_name = 'Hillyer';

SELECT
    f.title
FROM film AS f
WHERE f.film_id IN (
    SELECT i.film_id
    FROM inventory AS i
    WHERE i.store_id IN (
        SELECT store.store_id
        FROM store
        WHERE store.manager_staff_id IN (
            SELECT staff.staff_id
            FROM staff
            WHERE staff.first_name = 'Mike' AND staff.last_name = 'Hillyer'
        )
    )
);

/*
    5. Вивести користувачів, що брали в оренду фільми
       SWEETHEARTS SUSPECTS, TEEN APOLLO, TIMBERLAND SKY, TORQUE BOUND.
*/
SELECT DISTINCT
    c.first_name,
    c.last_name,
    c.customer_id
FROM customer AS c
JOIN store AS s
    ON s.store_id = c.store_id
JOIN inventory AS i
    ON i.store_id = s.store_id
JOIN film AS f
    ON f.film_id = i.film_id
WHERE f.title IN ('SWEETHEARTS SUSPECTS', 'TEEN APOLLO', 'TIMBERLAND SKY', 'TORQUE BOUND');

SELECT
    c.first_name,
    c.last_name
FROM customer AS c
WHERE c.store_id IN (
    SELECT s.store_id
    FROM store AS s
    WHERE s.store_id IN (
        SELECT i.store_id
        FROM inventory AS i
        WHERE i.film_id IN (
            SELECT f.film_id
            FROM film AS f
            WHERE f.title IN ('SWEETHEARTS SUSPECTS', 'TEEN APOLLO', 'TIMBERLAND SKY', 'TORQUE BOUND')
        )
    )
);

/*
    6. Вивести назву фільму, тривалість фільму і мову фільму.
       Фільтр: мова Англійська або італійська. (таблиці film, language).
*/
SELECT
    f.title,
    f.length,
    l.name AS Language
FROM film AS f
JOIN language AS l
    ON f.language_id = l.language_id
WHERE l.name IN ('English', 'Italian');

SELECT
    f.title,
    f.length,
    (
        SELECT l.name
        FROM language AS l
        WHERE l.language_id = f.language_id
    ) AS Language
FROM film AS f
WHERE f.language_id IN (
    SELECT l.language_id
    FROM language AS l
    WHERE l.name IN ('English', 'Italian')
);

/*
    7. Вивести payment_date i amount всіх записів активних клієнтів (поле active таблиці customer).
*/
SELECT
    p.payment_date,
    p.amount
FROM payment AS p
JOIN customer AS c
    ON c.customer_id = p.customer_id
WHERE c.active = 1;

SELECT
    p.payment_date,
    p.amount
FROM payment AS p
WHERE p.customer_id IN (
    SELECT c.customer_id
    FROM customer AS c
    WHERE c.active = 1
);

/*
    8. Вивести прізвище та ім’я клієнтів, payment_date i amount для активних клієнтів
       (поле active таблиці customer).
*/
SELECT
    c.last_name,
    c.first_name,
    p.payment_date,
    p.amount
FROM customer AS c
JOIN payment AS p
    ON p.customer_id = c.customer_id
WHERE c.active = 1;

SELECT
    (
        SELECT c.last_name
        FROM customer AS c
        WHERE c.customer_id = p.payment_id
    ) AS last_name,
    (
        SELECT c.first_name
        FROM customer AS c
        WHERE c.customer_id = p.payment_id
    ) AS first_name,
    p.payment_date,
    p.amount
FROM payment AS p
WHERE p.customer_id IN (
    SELECT c.customer_id
    FROM customer AS c
    WHERE c.active = 1
);

/*
    9. Вивести прізвище та ім'я користувачів (customer),
       які здійснювали оплату в розмірі більшому, ніж 10 доларів (таблиця payment, поле amount),
       також вивести amount, дату оплати. Відсортувати за датою оплати.
*/
SELECT
    c.last_name,
    c.first_name,
    p.amount,
    p.payment_date
FROM customer AS c
JOIN payment AS p
    ON p.customer_id = c.customer_id
WHERE p.amount > 10
ORDER BY p.payment_date;

SELECT
    (
        SELECT
            c.last_name
        FROM customer AS c
        WHERE c.customer_id = p.customer_id
    ) AS last_name,
    (
        SELECT
            c.first_name
        FROM customer AS c
        WHERE c.customer_id = p.customer_id
    ) AS first_name,
    p.amount,
    p.payment_date
FROM payment AS p
WHERE p.amount > 10
ORDER BY p.payment_date;

/*
    10. Вивести прізвище та ім’я, а також дату останнього оновлення запису (поле last_update)
        для людей наявних в таблицях actor, customer.
        Також в результуючому запиті передбачити можливість розрізняти акторів і користувачів.
*/
SELECT
    last_name,
    first_name,
    last_update,
    'Actor' AS person_appointment
FROM actor
UNION ALL
SELECT
    last_name,
    first_name,
    last_update,
    'Customer' AS person_appointment
FROM customer;

/*
    11. Вивести всі унікальні прізвища таблиць actor, customer, staff.
*/
SELECT
    last_name
FROM actor
UNION
SELECT
    last_name
FROM customer
UNION
SELECT
    last_name
FROM staff;
