select 
	concat(first_name," ",last_name) as customer from customer
join rental on 
	customer.customer_id = rental.customer_id
where return_date is null;

-- 
select 
	concat(first_name," ",last_name) as people from actor
union
select 
	concat(first_name," ",last_name) as people from customer
union
select 
	concat(first_name," ",last_name) as people from staff;

--
select country,
		count(city_id) as cities_count
from country join city on 
		country.country_id = city.country_id
group by country.country_id;

--
select name as category,
	 count(film_id) as quantity_of_films
from film_category join category on
	 film_category.category_id = category.category_id
group by  category.category_id;

--
select title,
	   count(actor_id) as quantity_of_actors
from film join film_actor on 
	   film.film_id = film_actor.film_id
group by film.title;

--
select name,
	   count(actor_id) as quantity_of_actors
from category 
join film_category on 
	  category.category_id = film_category.category_id
join film_actor on 
	  film_actor.film_id = film_category.film_id
group by category.category_id;

--
select district,
	   count(address_id) as quantity_of_address
from address
where district like "Central%"
group by district;

--
select count(film_id) as total_of_films,
	   min(rental_rate) as low_rental_rate,
       avg(rental_rate) as average_rental_rate,
       max(rental_rate) as hight_rental_rate,
       avg(replacement_cost) as average_replacement_cost,
       min(length) as short_duration,
       avg(length) as average_duration,
       max(length) as long_duration
from film;

--
select 'active' as status, 
		count(active) from customer
where active = 1
union
select 'no active' as status, 
		count(active) from customer
where active = 0;

--
select 
	concat(first_name," ",last_name) as customer,
    min(payment_date) as first_payment_date,
    max(payment_date) as last_payment_date,
    sum(amount) as total_paymanet
from customer join payment on
	customer.customer_id = payment.customer_id
group by customer.customer_id;

    
