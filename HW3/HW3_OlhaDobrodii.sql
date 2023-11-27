use sakila;

-- 1
select first_name from customer c
join rental r
on c.customer_id = r.customer_id
and return_date is null;

-- 2
select 
	concat (first_name, ' ', last_name) as people
from actor
union
select 
	concat (first_name, ' ', last_name) as people
from customer
union
select 
	concat (first_name, ' ', last_name) as people
from staff;

-- 3
select country, count(city.city_id) as count_city from country country
join  city city
on country.country_id = city.country_id
group by country.country;

-- 4
-- 5
select f.title,
	count(a.actor_id)
    from film f
    
    join film_actor fa
    on fa.film_id = f.film_id
    
    join actor a 
    on fa.actor_id = a.actor_id
    
    group by f.title;

-- 6
select c.name,
	count(a.actor_id)	from category c
    
join film_category fc
on c.category_id = fc.category_id

join film f
on fc.film_id = f.film_id

join film_actor fa
on fa.film_id = f.film_id

join actor a
on fa.actor_id = a.actor_id
group by c.name;

-- 7
select district,
	count(address_id) from address
    where district like 'Central'
    group by district;
    
-- 8 
select 
	count(f.film_id) as films_rental_rate,
    min(f.rental_rate) as min_rental_rate,
    avg(f.rental_rate) as average_rental_rate,
    max(f.rental_rate) as max_rental_rate,
    avg(replacement_cost) as average_cost,
    min(f.length) as min_length,
    avg(f.length) as average_length,
    max(f.length) as max_length
    
from film f;

-- 9
select 	case
	when active = 1 then 'active'
	else 'unknown'
	end as statuses,
	count(customer_id) as client_count
	from customer
group by active;

-- 10
select c.first_name, c.last_name,

min(p.payment_date) as min_payment_date,
max(p.payment_date) as max_payment_date,
sum(p.amount) as average_payment_date

from customer c
join payment p
on c.customer_id = p.customer_id
group by c.customer_id;