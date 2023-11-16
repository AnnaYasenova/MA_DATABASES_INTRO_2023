-- 1 Вивести прізвища та імена всіх клієнтів (customer), які не повернули фільми
-- в прокат.

-- subquery:
SELECT
	CONCAT(c.last_name, ' ', c.first_name) AS "Active rental customers"
FROM customer AS c
WHERE c.customer_id IN (
	SELECT r.customer_id
    FROM rental AS r
    WHERE r.return_date IS NULL
);

-- join:
SELECT
	CONCAT(c.last_name, ' ', c.first_name) AS "Active rental customers"
FROM customer AS c
JOIN rental AS r
	ON c.customer_id = r.customer_id
WHERE r.return_date IS NULL
GROUP BY c.customer_id;


-- 2 Виведіть список всіх людей наявних в базі даних (таблиці actor, customer,
-- staff). Для виконання використайте оператор union. Вивести потрібно
-- конкатенацію полів прізвище та ім’я.

SELECT
	CONCAT(a.last_name, ' ', a.first_name) AS Person
FROM actor AS a
UNION ALL
SELECT
	CONCAT(c.last_name, ' ', c.first_name)
FROM customer AS c
UNION ALL
SELECT
	CONCAT(s.last_name, ' ', s.first_name)
FROM staff AS s;


-- 3 Виведіть кількість міст для кожної країни.

SELECT
	ctr.country,
    count(c.country_id) AS cities_amount
FROM country AS ctr
JOIN city AS c
	ON c.country_id = ctr.country_id
GROUP BY ctr.country;


-- 4 Виведіть кількість фільмів знятих в кожній категорії.

SELECT
	c.name AS Category,
    count(*) AS films_amount
FROM category AS c
JOIN film_category AS f_c
	ON c.category_id = f_c.category_id
JOIN film AS f
	ON f_c.film_id = f.film_id
GROUP BY c.name;


-- 5 Виведіть кількість акторів що знімалися в кожному фільмі.

SELECT
	f.title AS Film,
    count(*) AS Actors
FROM film AS f
JOIN film_actor AS f_a
	ON f.film_id = f_a.film_id
JOIN actor AS a
	ON f_a.actor_id = a.actor_id
GROUP BY f.title
ORDER BY Actors DESC;



-- 6 Виведіть кількість акторів що знімалися в кожній категорії фільмів.

SELECT
	c.name AS Category,
    count(*) AS Actors
FROM category AS c
JOIN film_category AS f_c
	ON c.category_id = f_c.category_id
JOIN film_actor AS f_a
	ON f_c.film_id = f_a.film_id
JOIN actor AS a
	ON f_a.actor_id = a.actor_id
GROUP BY c.name;


-- 7 Виведіть district та кількість адрес для кожного district, за умови, що district
-- починається на “Central”.

SELECT
	district,
    count(*) AS addresses_amount
FROM address
WHERE district LIKE 'Central%'
GROUP BY district;


-- 8 За допомогою одного запиту вивести кількість фільмів в базі даних,
-- мінімальну, середню та максимальну вартість здачі в прокат (rental_rate),
-- середню replacement_cost, мінімальну, середню та максимальну тривалість
-- фільмів.

SELECT 
	count(*) AS films_amount,
    MIN(f.rental_rate) AS Min_rental_rate,
    MAX(f.rental_rate) AS Max_rental_rate,
    AVG(f.rental_rate) AS Avg_rental_rate,
    AVG(f.replacement_cost) AS Avg_replacement_cost,
    MIN(f.length) AS Min_film_length,
    AVG(f.length) AS Avg_film_length,
    MAX(f.length) AS Max_film_length
FROM film AS f;


-- 9 Виведіть кількість активних та неактивних клієнтів.(формат: active, кількість
-- клієнтів).

SELECT 
	IF(active = 0, 'Inactive', 'Active') AS "Type",
    count(c.customer_id) AS "Number of customers"
FROM customer AS c
GROUP BY c.active;


-- 10 Виведіть ім’я та прізвище клієнта, дату його першого та останнього платежу
-- та загальну кількість грошей які він заплатив. (таблиці payment, customer)

SELECT
	concat(c.first_name, ' ', c.last_name) AS Customer,
    MIN(p.payment_date) AS First_payment,
    MAX(p.payment_date) AS Last_payment,
    SUM(p.amount) AS Money_amount
FROM customer AS c
JOIN payment AS p
	ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY Money_amount DESC;

