use sakila;

-- 1. 
WITH rental_cte AS (
	SELECT inventory_id 
    FROM rental
    JOIN staff ON staff.staff_id = rental.staff_id
	WHERE first_name = 'Mike' AND last_name = 'Hillyer'
)
SELECT DISTINCT film.* FROM film
JOIN inventory ON inventory.film_id = film.film_id
JOIN rental_cte ON rental_cte.inventory_id = inventory.inventory_id; 

-- 2. 
WITH film_cte AS (
	SELECT film_id FROM film
    WHERE film.title IN ('SWEETHEARTS SUSPECTS', 'TEEN APOLLO', 'TIMBERLAND SKY', 'TORQUE BOUND')
)
SELECT DISTINCT customer.* FROM customer
JOIN rental ON rental.customer_id = customer.customer_id
JOIN inventory ON inventory.inventory_id = rental.inventory_id
JOIN film_cte ON film_cte.film_id = inventory.film_id;

-- 3.
SELECT title FROM film
WHERE replacement_cost > 10 
	AND film_id IN (
			SELECT film_id FROM inventory
			WHERE inventory_id IN (
				SELECT inventory_id FROM rental
                WHERE return_date IS NULL
            )
    );  
    
-- 4. 
SELECT
	title,
	SUM(amount) AS amount
FROM film
JOIN inventory ON inventory.film_id = film.film_id
JOIN rental ON rental.inventory_id = inventory.inventory_id
JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY title;

-- 5.  
SELECT 
	return_date IS NOT NULL AS returned, 
	COUNT(*) 
FROM rental
GROUP BY returned;

-- 6.  
SELECT
	CONCAT(SUBSTRING(first_name, 1, 1), '. ', last_name) AS person,
    SUM(amount) AS total_amount
FROM sakila.payment AS p
JOIN sakila.customer AS c ON p.customer_id = c.customer_id 
GROUP BY person
HAVING SUM(amount) > 190; 

-- 7.
SELECT * FROM film
WHERE length = (SELECT MIN(length) FROM film);

-- 8.
SELECT 
	CASE 
		WHEN rental_rate < 2 THEN "low_rental_rate"
        WHEN rental_rate BETWEEN 2 AND 4 then "medium_rental_rate"
        WHEN rental_rate > 4 THEN "high_rental_rate"
	ELSE "unknown_rate"
	END AS rate, 
	count(*) 
FROM film
GROUP BY rate;