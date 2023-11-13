use sakila;

-- 1.
SELECT 
	first_name,
    last_name
FROM customer
WHERE customer_id in (
		SELECT customer_id FROM rental
		WHERE return_date IS NULL
    ); 

-- 2.
SELECT
	CONCAT(first_name, ' ', last_name) AS person
FROM actor
UNION
SELECT
	CONCAT(first_name, ' ', last_name)
FROM customer
UNION
SELECT
	CONCAT(first_name, ' ', last_name)
FROM staff;

-- 3. 
SELECT 
	country,
    count(city_id) AS city_count
FROM country
JOIN city ON country.country_id = city.country_id
GROUP BY country;

-- 4.
SELECT 
	name,
    COUNT(film_id) AS film_count
FROM category
JOIN film_category ON film_category.category_id = category.category_id
GROUP BY name;

-- 5. 
SELECT 
	title,
    COUNT(actor_id) AS film_count
FROM film
JOIN film_actor ON film_actor.film_id = film.film_id
GROUP BY title;

-- 6.
SELECT 
	name,
    COUNT(actor_id) AS film_count
FROM category
JOIN film_category ON film_category.category_id = category.category_id
JOIN film_actor ON film_actor.film_id = film_category.film_id
GROUP BY name; 

-- 7.
SELECT 
	district,
    COUNT(address) AS address_count
FROM address
WHERE district LIKE '%Central%' 
GROUP BY district; 

-- 8.
SELECT
    COUNT(*) AS total_films,
    MIN(rental_rate) AS min_rental_rate,
    AVG(rental_rate) AS avg_rental_rate,
    MAX(rental_rate) AS max_rental_rate,
    AVG(replacement_cost) AS avg_replacement_cost,
    MIN(length) AS min_length,
    AVG(length) AS avg_length,
    MAX(length) AS max_length
FROM film;

 -- 9.
SELECT 
	COUNT(*) AS count
FROM customer
GROUP BY active; 

-- 10.
SELECT 
	first_name,
    last_name,
    MIN(payment_date) AS first_pay,
    MAX(payment_date) AS last_pay,
    SUM(amount) AS amount
FROM customer
JOIN payment ON payment.customer_id = customer.customer_id
GROUP BY 
	first_name,
    last_name;  
    
    
    

 


