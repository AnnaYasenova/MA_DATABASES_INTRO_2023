SELECT * 
FROM customer;

SELECT first_name as "First Name", last_Name as "Last Name", email as "Email" 
FROM customer;

SELECT address as "Address", district as "District", postal_code "Postal Code" 
FROM address
ORDER BY district ASC, address DESC;
 
SELECT title, rental_rate
FROM film
WHERE rental_rate > 3;
 
SELECT title, description, rating
FROM film
WHERE rating in ("G", "PG", "R");
 
SELECT * 
FROM film_text
WHERE description LIKE '%database%';
 
SELECT *
FROM film
WHERE rental_duration = 3 and replacement_cost < 12;
 
SELECT *
FROM film
WHERE rating = "G" and replacement_cost > 15;

SELECT *
FROM film
WHERE length BETWEEN 60 AND 90;

SELECT *
FROM film
WHERE length < 60 OR length > 90;

SELECT title
FROM film
WHERE (rental_duration = 6 or rental_duration = 7)
AND rental_rate >= 4 
AND (special_features LIKE '%Trailers%' OR special_features LIKE '%Commentaries');

SELECT title
FROM film
WHERE (rating = "G" AND length > 60)
OR (rating = 'R' AND special_features LIKE '%Commentaries%');