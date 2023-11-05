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

/*
    5. Вивести користувачів, що брали в оренду фільми
       SWEETHEARTS SUSPECTS, TEEN APOLLO, TIMBERLAND SKY, TORQUE BOUND.
*/

/*
    6. Вивести назву фільму, тривалість фільму і мову фільму.
       Фільтр: мова Англійська або італійська. (таблиці film, language).
*/

/*
    7. Вивести payment_date i amount всіх записів активних клієнтів (поле active таблиці customer).
*/

/*
    8. Вивести прізвище та ім’я клієнтів, payment_date i amount для активних клієнтів
       (поле active таблиці customer).
*/

/*
    9. Вивести прізвище та ім'я користувачів (customer),
       які здійснювали оплату в розмірі більшому, ніж 10 доларів (таблиця payment, поле amount),
       також вивести amount, дату оплати. Відсортувати за датою оплати.
*/

/*
    10. Вивести прізвище та ім’я, а також дату останнього оновлення запису (поле last_update)
        для людей наявних в таблицях actor, customer.
        Також в результуючому запиті передбачити можливість розрізняти акторів і користувачів.
*/

/*
    11. Вивести всі унікальні прізвища таблиць actor, customer, staff.
*/
