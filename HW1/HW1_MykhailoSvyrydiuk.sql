
use sakila;

-- 1
select * from customer;

-- 2
select
	first_name AS 'FIRST NAME',
    last_name AS 'LAST NAME',
    email AS 'EMAIL'
FROM customer;

-- 3
SELECT 
	address AS 'Address',
    district AS 'District',
    postal_code AS 'Postal Code'
FROM address
ORDER BY district ASC, address DESC;

-- 4
SELECT 
	title,
    rental_rate
FROM film
WHERE rental_rate > 3;

-- 5
SELECT 
	title,
    description,
    rating
FROM film
WHERE 
	rating IN ('G', 'PG', 'R');

-- 6
select * 
from 
	film_text
where 
	description like '%database%';
    
-- 7
select *
from 
	film
where 
	rental_duration = 3;
    
-- 8
select *
from 
	film
where 
	rating = 'G' 
    and replacement_cost > 15;
    
-- 9 
select *
from 
	film
where 
	length BETWEEN 60 AND 90;
    
-- 10
select *
from 
	film
where 
	length < 60;
    
-- 11
select title
from 
	film
where 
	rental_duration = 6 or rental_duration = 7
    and rental_rate >= 4
    and special_features in ('Trailers', 'Commentaries');
    
-- 12
select title
from 
	film
where 
	(rating = 'G'
    and length > 60)
    or
    (rating = 'R'
    and special_features in ('Commentaries'))
    
