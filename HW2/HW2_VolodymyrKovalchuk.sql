USE sakila;

SELECT a.address, c.city 
FROM address a JOIN city c ON a.city_id=c.city_id;

SELECT
	a.address,
	(SELECT city
    FROM city c
    WHERE c.city_id=a.city_id
    ) as city
FROM address a;

SELECT c.city
FROM city c 
	JOIN country co ON c.country_id=co.country_id AND co.country IN ('Argentina', 'Austria')
ORDER BY c.city;

SELECT
    c.city
FROM city c
WHERE c.country_id IN (
    SELECT co.country_id
    FROM country co
    WHERE co.country IN ('Argentina', 'Austria')
)
ORDER BY c.city;

SELECT DISTINCT a.actor_id, a.first_name, a.last_name
FROM actor a
	JOIN film_actor fa ON a.actor_id=fa.actor_id
    JOIN film_category fc ON fa.film_id=fc.film_id
    JOIN category c ON fc.category_id=c.category_id AND c.name IN ('Music', 'Sports');

SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE a.actor_id IN 
	(SELECT fa.actor_id
    FROM film_actor fa
    WHERE fa.film_id IN
		(SELECT fc.film_id
		FROM film_category fc
		WHERE fc.category_id IN
			(SELECT c.category_id
			FROM category c
			WHERE c.name IN ('Music', 'Sports')
			)
		)
	);

SELECT DISTINCT f.film_id, f.title
FROM film f
	JOIN inventory i ON i.film_id=f.film_id
    JOIN staff s ON s.store_id=i.store_id AND s.staff_id=1;
    
SELECT DISTINCT f.film_id, f.title
FROM film f
WHERE f.film_id IN
	(SELECT i.film_id
	FROM inventory i
	WHERE i.store_id IN
		(SELECT s.store_id
		FROM staff s
		WHERE s.staff_id=1));

SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customer c
	JOIN rental r ON c.customer_id=r.customer_id
    JOIN inventory i ON r.inventory_id=i.inventory_id
    JOIN film f ON i.film_id=f.film_id AND f.title IN ('SWEETHEARTS SUSPECTS', 'TEEN APOLLO', 'TIMBERLAND SKY', 'TORQUE BOUND');

SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
WHERE c.customer_id IN 
	(SELECT r.customer_id
    FROM rental r
    WHERE r.inventory_id IN
		(SELECT i.inventory_id
		FROM inventory i
		WHERE i.film_id IN
			(SELECT f.film_id
			FROM film f
			WHERE f.title IN ('SWEETHEARTS SUSPECTS', 'TEEN APOLLO', 'TIMBERLAND SKY', 'TORQUE BOUND'))));

SELECT f.title, f.length, l.name
FROM film f
	JOIN language l ON f.language_id=l.language_id AND l.name IN ('English', 'Italian');

SELECT 
	f.title,
	f.length,
    (SELECT l.name
    FROM language l
    WHERE f.language_id=l.language_id AND l.name IN ('English', 'Italian')
    ) as language
FROM film f;

SELECT p.payment_date, p.amount
FROM payment p
	JOIN customer c ON p.customer_id=c.customer_id AND c.active=1;
    
SELECT p.payment_date, p.amount
FROM payment p
WHERE p.customer_id IN
	(SELECT c.customer_id
    FROM customer c
    WHERE c.active=1);

SELECT c.first_name, c.last_name, p.amount, p.payment_date
FROM customer c
	JOIN payment p ON p.customer_id=c.customer_id AND c.active=1;    

SELECT
	(SELECT c.first_name
    FROM customer c
    WHERE c.customer_id = p.customer_id) as first_name,
    (SELECT c.last_name
    FROM customer c
    WHERE c.customer_id = p.customer_id) as last_name,
    p.amount,
    p.payment_date, p. payment_id
FROM payment p
WHERE p.customer_id IN
	(SELECT c.customer_id
    FROM customer c
    WHERE c.active=1);

SELECT c.first_name, c.last_name, p.amount, p.payment_date
FROM customer c
	JOIN payment p ON p.customer_id=c.customer_id AND p.amount > 10
ORDER BY p.payment_date;

SELECT 
	(SELECT c.first_name
    FROM customer c
    WHERE c.customer_id = p.customer_id) as first_name,
    (SELECT c.last_name
    FROM customer c
    WHERE c.customer_id = p.customer_id) as last_name,
    p.amount,
    p.payment_date
FROM payment p
WHERE p.amount > 10
ORDER BY p.payment_date;

SELECT a.last_name, a.first_name, a.last_update, 'actor' as role
FROM actor a
UNION ALL
SELECT c.last_name, c.first_name, c.last_update, 'customer'
FROM customer c;

SELECT a.last_name
FROM actor a
UNION
SELECT c.last_name
FROM customer c
UNION
SELECT s.last_name
FROM staff s;