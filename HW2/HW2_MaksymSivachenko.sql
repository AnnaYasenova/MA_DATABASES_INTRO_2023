USE sakila;

-- 1.
SELECT 
	a.address,
    c.city
FROM address AS a
JOIN city AS c ON a.city_id = c.city_id;

SELECT 
	address,
    (
		SELECT city FROM city
		WHERE city_id = address.city_id
    ) AS city
FROM address;

-- 2.
SELECT city FROM city
JOIN country ON country.country_id = city.country_id
WHERE country = 'Argentina' OR country = 'Austria'
ORDER BY city;

SELECT city FROM city
WHERE country_id IN (
	SELECT country_id FROM country
    WHERE country = 'Argentina' OR country = 'Austria'
)
ORDER BY city;
 
 -- 3.
SELECT DISTINCT actor.* FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film_category ON film_actor.film_id = film_category.film_id
JOIN category ON category.category_id = film_category.category_id
WHERE name = 'Music' OR name = 'Sports'; 

SELECT * FROM actor
WHERE actor_id IN (
	SELECT actor_id FROM film_actor 
    WHERE film_id IN (
		SELECT film_id FROM film_category 
        WHERE category_id IN (
			SELECT category_id FROM category
			WHERE name = 'Music' OR name = 'Sports'
        )
    )
);

-- 4. 
SELECT DISTINCT film.* FROM film
JOIN inventory ON inventory.film_id = film.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
JOIN staff ON staff.staff_id = rental.staff_id
WHERE first_name = 'Mike' AND last_name = 'Hillyer'; 

SELECT * FROM film
WHERE film_id IN (
	SELECT film_id FROM inventory 
    WHERE inventory_id IN (
		SELECT inventory_id FROM rental 
        WHERE staff_id IN (
			SELECT staff_id FROM staff
			WHERE first_name = 'Mike' AND last_name = 'Hillyer'
        )
    )
);

-- 5. 
SELECT DISTINCT customer.* FROM customer
JOIN rental ON rental.customer_id = customer.customer_id
JOIN inventory ON inventory.inventory_id = rental.inventory_id
JOIN film ON film.film_id = inventory.film_id
WHERE film.title IN ('SWEETHEARTS SUSPECTS', 'TEEN APOLLO', 'TIMBERLAND SKY', 'TORQUE BOUND');

SELECT * FROM customer
WHERE customer_id IN (
	SELECT customer_id FROM rental 
    WHERE inventory_id IN (
		SELECT inventory_id FROM inventory 
        WHERE film_id IN (
			SELECT film_id FROM film
			WHERE film.title IN ('SWEETHEARTS SUSPECTS', 'TEEN APOLLO', 'TIMBERLAND SKY', 'TORQUE BOUND')
        )
    )
);

-- 6.
SELECT 
	f.title,
    f.length,
    l.name
FROM film AS f
JOIN language AS l ON l.language_id = f.language_id
WHERE l.name IN ('English', 'Italian');

SELECT 
	title,
    length,
    (
		SELECT name FROM language
		WHERE language_id = film.language_id
			AND name IN ('English', 'Italian')
    ) AS name
FROM film
WHERE language_id IN (
	SELECT language_id FROM language
    WHERE name IN ('English', 'Italian')
);

-- 7.
SELECT 
	payment_date,
    amount
FROM payment    
JOIN customer AS c ON c.customer_id = payment.customer_id
WHERE c.active;

SELECT 
	payment_date,
    amount
FROM payment    
WHERE customer_id IN (
	SELECT customer_id FROM customer
	WHERE active
);

-- 8.
SELECT
	c.first_name,
    c.last_name,
	p.payment_date,
    p.amount
FROM payment AS p    
JOIN customer AS c ON c.customer_id = p.customer_id
WHERE c.active;

SELECT 
	(
		SELECT first_name FROM customer
		WHERE customer_id = p.customer_id 
			AND active
    ) AS first_name,
    (
		SELECT last_name FROM customer
		WHERE customer_id = p.customer_id
			AND active
    ) AS last_name,
	p.payment_date,
    p.amount
FROM payment AS p   
WHERE customer_id IN (
	SELECT customer_id FROM customer
	WHERE active
);

-- 9.
SELECT
	c.first_name,
    c.last_name,
	p.payment_date,
    p.amount
FROM payment AS p    
JOIN customer AS c ON c.customer_id = p.customer_id
WHERE p.amount > 10
ORDER BY p.payment_date;

SELECT 
	(
		SELECT first_name FROM customer
		WHERE customer_id = p.customer_id 
    ) AS first_name,
    (
		SELECT last_name FROM customer
		WHERE customer_id = p.customer_id
    ) AS last_name,
	p.payment_date,
    p.amount
FROM payment AS p   
WHERE p.amount > 10
ORDER BY p.payment_date;

-- 10.
WITH cte AS (
	SELECT 
		first_name,
		last_name,
		last_update AS last_update,
		'customer' AS type
	FROM customer
	UNION ALL
	SELECT 
		first_name,
		last_name,
		last_update,
		'actor'
	FROM actor
)
SELECT 
	first_name,
    last_name,
    MAX(last_update) AS last_update,
    type
FROM cte
GROUP BY 
	first_name,
    last_name,
    type;
    
-- 11.
SELECT 
	last_name
FROM customer
UNION
SELECT 
	last_name
FROM actor
UNION
SELECT 
	last_name
FROM staff;