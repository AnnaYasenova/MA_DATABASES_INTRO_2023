USE sakila;

SELECT * FROM customer;

SELECT 
	first_name AS 'First Name',
	last_name AS 'Last Name',
	email AS 'Email'
FROM customer;

SELECT
	address AS "Address",
	district AS "District",
	postal_code AS "Postal Code"
FROM address
ORDER BY district, address DESC;

SELECT
	title,
	rental_rate
FROM film
WHERE rental_rate > 3;

SELECT
	title,
	description,
	rating
FROM film
WHERE rating IN ("G","PG","R");

SELECT *
FROM film_text
WHERE description LIKE "%database%";

SELECT *
FROM film
WHERE rental_duration = 3 
	AND replacement_cost < 12;
    
SELECT *
FROM film
WHERE rating = "G" 
	AND replacement_cost > 15;

SELECT *
FROM film
WHERE length BETWEEN 60 AND 90;

SELECT *
FROM film
WHERE length < 60 
	OR length > 90;
    
SELECT
	title
FROM film
WHERE rental_duration IN (6, 7)
	AND NOT rental_rate < 4
    AND (special_features LIKE "%Trailers%" 
		OR special_features LIKE "%Commentaries%");
        
SELECT *
FROM film
WHERE (rating = "G" AND length > 60)
	OR (rating = "R" AND special_features LIKE "%Commentaries%");