use sakila;

select * from sakila.customer;

select 
first_name as "First_Name",
last_name as "Last_Name",
email as "Email"
from customer;

select Address, District, Postal_code from address;

select District from address
order by District asc;

select Address from address
order by Address desc;

select title, rental_rate from film
where rental_rate > 3;

select title, description, rating from film
where rating in ("G", "PG", "R");

select * from film_text
where description like '%database%';

select * from film
where rental_rate = 3 and replacement_cost < 12;

select * from film
where rating = 'G' and replacement_cost > 15;

select * from film
where length <= 90 and length  >= 60;

select * from film
where length > 90 or length  < 60;

select title from film
where rental_duration = 6 or 7
and rental_rate >= 4 
and special_features 
and special_features like '%Trailers%' 
and special_features like '%Commentaries%';

select * from film
where rating = 'G' and length  < 60
or rating = 'R' and special_features like '%Commentaries%';
