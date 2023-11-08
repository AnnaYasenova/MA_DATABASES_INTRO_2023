-- 1
SELECT * FROM customer;


-- 2
SELECT first_name AS "First Name", 
		last_name AS "Last Name", 
		email AS "Email" 
FROM customer;


-- 3
SELECT address AS "Address", 
		district AS "District", 
		postal_code AS "Postal code" 
FROM address
ORDER BY district ASC, address DESC;


-- 4
SELECT title, rental_rate 
FROM film
WHERE rental_rate > 3;


-- 5
SELECT title AS "Title", 
		description AS "Description", 
		rating AS "Rating" 
FROM film
WHERE rating in ('G', 'PG', 'R');


-- 6
SELECT * FROM film_text
WHERE description LIKE '%database%';


-- 7
SELECT * FROM film
WHERE rental_duration = 3 AND replacement_cost < 12;


-- 8
SELECT * FROM film
WHERE rating = "G" AND replacement_cost > 15;


-- 9
SELECT * FROM film
WHERE length BETWEEN 60 AND 90;


-- 10
SELECT * FROM film
WHERE length NOT BETWEEN 60 AND 90;


-- 11
SELECT title FROM film
WHERE rental_duration in (6, 7) 
	AND rental_rate >= 4
    AND (special_features LIKE "%Trailers%"
		OR special_features LIKE "%Commentaries%");
    

-- 12    
select title from film
WHERE (rating = "G" AND length > 60)
	OR (rating = "R" AND special_features LIKE "%Commentaries%");