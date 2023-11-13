-- 1 Вивести адресу і місто до якого відноситься ця адреса. (таблиці address, city)

-- aliases:
SELECT 
	c.city,
    a.address
FROM
	city AS c,
    address AS a
WHERE c.city_id=a.city_id;

-- subquery:
SELECT 
	a.address,
	(
		SELECT c.city FROM city AS c
        WHERE a.city_id=c.city_id
	) AS city
FROM address AS a;

-- join:
SELECT 
	c.city,
    a.address
FROM city AS c
JOIN address AS a
	ON c.city_id=a.city_id;


-- 2 Вивести список міст Аргентини і Австрії. (таблиці city, country). Відсортувати за алфавітом.

-- aliases:
SELECT city
FROM 
	city AS c,
    country AS ctr
WHERE c.country_id=ctr.country_id 
	AND ctr.country IN ('Argentina', 'Austria')
ORDER BY c.city;

-- subquery:
SELECT city
FROM city AS c
WHERE c.country_id IN (
	SELECT ctr.country_id
    FROM country AS ctr
    WHERE ctr.country IN ('Argentina', 'Austria')
)
ORDER BY c.city;

-- join:
SELECT city
FROM city AS c
JOIN country AS ctr
	ON c.country_id=ctr.country_id
WHERE ctr.country IN ('Argentina', 'Austria')
ORDER BY c.city;


-- 3 Вивести список акторів, що знімалися в фільмах категорій Music, Sports. (використати таблиці actor, film_actor, film_category, category).

-- aliases:
SELECT DISTINCT 
	ac.first_name AS "First Name",
	ac.last_name AS "Last Name"
FROM actor AS ac,
	film_actor AS f_ac,
    film_category AS f_c,
    category AS c
WHERE ac.actor_id=f_ac.actor_id
	AND f_ac.film_id=f_c.film_id
    AND f_c.category_id=c.category_id
    AND c.name IN ('Music', 'Sports');
    
-- subquery:
SELECT DISTINCT
	ac.first_name AS "First Name",
	ac.last_name AS "Last Name"
FROM actor AS ac
WHERE ac.actor_id IN (
	SELECT f_ac.actor_id
    FROM film_actor AS f_ac
    WHERE f_ac.film_id IN (
		SELECT f_c.film_id
		FROM film_category AS f_c
		WHERE f_c.category_id IN (
			SELECT c.category_id
            FROM category AS c
            WHERE c.name IN ('Music', 'Sports')
        )
    )
);

-- join:
SELECT DISTINCT 
	ac.first_name AS "First Name",
	ac.last_name AS "Last Name"
FROM actor AS ac
JOIN film_actor AS f_ac
	ON ac.actor_id=f_ac.actor_id
JOIN film_category AS f_c
	ON f_ac.film_id=f_c.film_id
JOIN category AS c
	ON f_c.category_id=c.category_id
WHERE c.name IN ('Music', 'Sports');


-- 4 Вивести всі фільми, видані в прокат менеджером Mike Hillyer. Для визначення менеджера використати таблицю staff і поле staff_id; для
-- визначення фільму скористатися таблицею inventory (поле inventory_id), і таблиці film (поле film_id).

-- aliases:
SELECT DISTINCT	f.title 
FROM film AS f,
	inventory AS i,
    rental AS r,
    staff AS s
WHERE f.film_id=i.film_id
	AND i.inventory_id=r.inventory_id
    AND r.staff_id=s.staff_id
    AND s.first_name='Mike'
    AND s.last_name='Hillyer';
    
-- subquery:
SELECT DISTINCT f.title 
FROM film AS f
WHERE f.film_id IN (
	SELECT i.film_id
    FROM inventory AS i
    WHERE i.inventory_id IN (
		SELECT r.inventory_id
		FROM rental AS r
		WHERE r.staff_id IN (
			SELECT s.staff_id
            FROM staff AS s
            WHERE s.first_name='Mike' AND s.last_name='Hillyer'
        )
    )
);

-- join:
SELECT DISTINCT	f.title 
FROM film AS f
JOIN inventory AS i
	ON f.film_id=i.film_id
JOIN rental AS r
	ON i.inventory_id=r.inventory_id
JOIN staff AS s
	ON r.staff_id=s.staff_id
WHERE s.first_name='Mike'
    AND s.last_name='Hillyer';


-- 5 Вивести користувачів, що брали в оренду фільми SWEETHEARTS SUSPECTS, TEEN APOLLO, TIMBERLAND SKY, TORQUE BOUND

-- aliases:
SELECT DISTINCT	
	c.first_name AS "First Name",
	c.last_name AS "Last Name"
FROM customer AS c,
	inventory AS i,
    rental AS r,
    film AS f
WHERE c.customer_id=r.customer_id
	AND r.inventory_id=i.inventory_id
    AND i.film_id=f.film_id
    AND f.title IN ('SWEETHEARTS SUSPECTS', 'TEEN APOLLO', 'TIMBERLAND SKY', 'TORQUE BOUND')
ORDER BY c.first_name;
    
-- subquery:
SELECT DISTINCT	
	c.first_name AS "First Name", 
	c.last_name AS "Last Name"
FROM customer AS c 
WHERE c.customer_id IN (
	SELECT r.customer_id
    FROM rental AS r
    WHERE r.inventory_id IN (
		SELECT i.inventory_id
		FROM inventory AS i
		WHERE i.film_id IN (
			SELECT f.film_id
            FROM film AS f
            WHERE f.title IN ('SWEETHEARTS SUSPECTS', 'TEEN APOLLO', 'TIMBERLAND SKY', 'TORQUE BOUND')
        )
    )
)
ORDER BY c.first_name;

-- join:
SELECT DISTINCT	
	c.first_name AS "First Name",
	c.last_name AS "Last Name"
FROM customer AS c
JOIN rental AS r
	ON c.customer_id=r.customer_id
JOIN inventory AS i
	ON r.inventory_id=i.inventory_id
JOIN film AS f
	ON i.film_id=f.film_id
WHERE f.title IN ('SWEETHEARTS SUSPECTS', 'TEEN APOLLO', 'TIMBERLAND SKY', 'TORQUE BOUND')
ORDER BY c.first_name;


-- 6 Вивести назву фільму, тривалість фільму і мову фільму. Фільтр: мова Англійська або італійська. (таблиці film, language)

-- aliases:
SELECT 
	f.title,
    f.length,
    l.name AS language
FROM
	film AS f,
    language AS l
WHERE f.language_id=l.language_id
	AND l.name IN ('English', 'Italian');
    
-- subquery:
SELECT
	f.title,
    f.length,
    (
		SELECT name FROM language AS l
        WHERE f.language_id=l.language_id
			AND l.name IN ('English', 'Italian')
    ) as language
FROM film AS f;

-- join:
SELECT 
	f.title,
    f.length,
    l.name AS language
FROM film AS f
JOIN language AS l
	ON f.language_id=l.language_id
WHERE l.name IN ('English', 'Italian');
    

-- 7 Вивести payment_date i amount всіх записів активних клієнтів (поле active таблиці customer).

-- aliases:
SELECT
	p.payment_date,
    p.amount
FROM
	payment AS p,
    customer AS c
WHERE p.customer_id=c.customer_id
	AND c.active=1;
    
-- subquery:
SELECT
	p.payment_date,
    p.amount
FROM payment AS p
WHERE p.customer_id IN (
	SELECT c.customer_id
    FROM customer AS c
    WHERE c.active=1
);

-- join:
SELECT
	p.payment_date,
    p.amount
FROM payment AS p
JOIN customer AS c
	ON p.customer_id=c.customer_id
WHERE c.active=1;


-- 8 Вивести прізвище та ім’я клієнтів, payment_date i amount для активних клієнтів (поле active таблиці customer)

-- aliases:
SELECT
	c.last_name,
    c.first_name,
    p.payment_date,
    p.amount
FROM
	payment AS p,
    customer AS c
WHERE p.customer_id=c.customer_id
	AND c.active=1;
    
-- subquery:
SELECT
	(
		SELECT last_name FROM customer AS c
        WHERE c.customer_id=p.customer_id
    ) AS last_name,
    (
		SELECT first_name FROM customer AS c
        WHERE c.customer_id=p.customer_id
    ) AS first_name,
    p.payment_date,
    p.amount
FROM payment AS p
WHERE p.customer_id IN (
    SELECT c.customer_id
    FROM customer AS c
    WHERE c.active=1
);

-- join:
SELECT
	c.last_name,
    c.first_name,
    p.payment_date,
    p.amount
FROM payment AS p
JOIN customer AS c
	ON p.customer_id=c.customer_id
WHERE c.active=1;


-- 9 Вивести прізвище та ім'я користувачів (customer), які здійснювали оплату в розмірі більшому, 
-- ніж 10 доларів (таблиця payment, поле amount), також вивести amount, дату оплати. Відсортувати за датою оплати.

-- aliases:
SELECT 
	c.last_name,
    c.first_name,
    p.amount,
    p.payment_date
FROM 
	payment AS p,
    customer AS c
WHERE p.customer_id=c.customer_id
	AND p.amount>10
ORDER BY p.payment_date;
    
-- subquery:
SELECT 
	(
		SELECT last_name FROM customer AS c
        WHERE c.customer_id=p.customer_id
    ) AS last_name,
    (
		SELECT first_name FROM customer AS c
        WHERE c.customer_id=p.customer_id
    ) AS first_name,
    p.amount,
    p.payment_date
FROM payment AS p
WHERE p.amount>10
ORDER BY payment_date;

-- join:
SELECT 
	c.last_name,
    c.first_name,
    p.amount,
    p.payment_date
FROM payment AS p
JOIN customer AS c
	ON p.customer_id=c.customer_id
WHERE p.amount>10
ORDER BY p.payment_date;

SELECT * FROM customer;

-- 10 Вивести прізвище та ім’я, а також дату останнього оновлення запису (поле last_update) для людей наявних в 
-- таблицях actor, customer. Також в результуючому запиті передбачити можливість розрізняти акторів і користувачів.

SELECT
	last_name,
	first_name,
    last_update,
    'actor' as category
FROM actor
UNION ALL
SELECT
	last_name,
	first_name,
    last_update,
    'customer' as category
FROM customer;


-- 11 Вивести всі унікальні прізвища таблиць actor, customer, staff.

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