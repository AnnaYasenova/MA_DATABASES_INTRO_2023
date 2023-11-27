use sakila;
-- 1
select * from sakila.customer;

-- 2
select 
first_name as "First_Name",
last_name as "Last_Name",
email as "Email"
from customer;

-- 3
select 
address as "Address",
district as "District",
postal_code as "Postal_code"
from address
order by address, district desc;

-- 4
select title, rental_rate from film
where rental_rate > 3;

-- 5
select title, description, rating from film
where rating in ("G", "PG", "R");

-- 6
select * from film_text
where description like '%database%';

-- 7
select * from film
where rental_duration = 3 and replacement_cost < 12;

-- 8
select * from film
where rating = 'G' and replacement_cost > 15;

-- 9
select * from film
where length between 60 and 90;

-- 10
select * from film
where length < 60 or length  > 90;

-- 11
select title from film
where rental_duration = 6 or 7
and rental_rate >= 4 
and (special_features like '%Trailers%' 
or special_features like '%Commentaries%');

-- 12
select * from film
where (rating = 'G' and length < 60)
or (rating = 'R' and special_features like '%Commentaries%');
