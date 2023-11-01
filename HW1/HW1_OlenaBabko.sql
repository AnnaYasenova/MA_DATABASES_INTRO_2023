#1
SELECT * FROM sakila.customer;

#2
SELECT 
	first_name AS "First Name", 
    last_name AS "Last Name",
    email AS "Email"
FROM customer;

#3
SELECT 
	address AS "Address", 
    district AS "District",
    postal_code AS "Postal Code"
FROM address
ORDER BY district ASC, address DESC;

#4
SELECT title, rental_rate
FROM film
WHERE 
	rental_rate >= 3;

#5    
SELECT title, description, rating
FROM film
WHERE rating in ("G", "PG", "R");

#6
SELECT * FROM film_text
WHERE description LIKE "database";

#7
SELECT * FROM film
WHERE
	rental_duration = 3
    AND
    replacement_cost < 12;

#8    
SELECT * FROM film
WHERE
	rating = "G"
    AND
    replacement_cost > 15;

#9
-- SELECT * FROM film
-- WHERE length BETWEEN 60 AND 90;

SELECT * FROM film
WHERE length>=60 AND length<=90;

#10
SELECT * FROM film
WHERE length<60 OR length>90;

#11
SELECT title 
FROM film
WHERE
	(rental_duration = 6 OR rental_duration = 7)
    AND rental_rate >= 4
    AND
    (special_features LIKE '%Trailers%'
	OR special_features LIKE '%Commentaries%');

#12    
SELECT * FROM film
WHERE
	(rating = "G" AND length > 60)
    OR
    (rating = "R" AND special_features LIKE '%Commentaries%');