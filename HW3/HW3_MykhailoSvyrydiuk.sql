-- 1
select distinct 
	c.first_name,
	c.last_name,
    r.return_date
 from customer c
 join rental r
	on c.customer_id = r.customer_id
    where r.return_date is null
order by r.return_date asc;

-- 2
select concat(first_name, ' ', last_name), 'customer' as category
from customer
union
select concat(first_name, ' ', last_name), 'actor' as category
from actor
union 
select concat(first_name, ' ', last_name), 'staff' as category
from staff;

-- 3
select count(ct.city) as cnt_city,
	cr.country as country
from city ct
join country cr
	on ct.country_id = cr.country_id
group by country;

-- 4
select c.name as categoty_name,
	count(f.film_id) as cnt_films
from film f
join film_category fc
 on fc.film_id = f.film_id
join category c
	on c.category_id = fc.category_id
group by categoty_name;

-- 5
select f.title as title,
	count(a.actor_id) as cnt_actors
from actor a 
join film_actor fa
	on a.actor_id = fa.actor_id
join film f
	on fa.film_id = f.film_id
group by title
order by cnt_actors desc;

-- 6
select c.name as category_name,
	count(a.actor_id) as cnt_actors
from actor a 
join film_actor fa
	on a.actor_id = fa.actor_id
join film_category fc
	on fa.film_id = fc.film_id
join category c
	on fc.category_id = c.category_id
group by category_name;

-- 7 
select district,
	count(address) as cnt_address
from address
where district like 'Central%'
group by district
order by cnt_address desc;

-- 8
select count(film_id) as cnt_films,
	round((avg(rental_rate)), 0),
    max(rental_rate),
    round((avg(replacement_cost)), 0),
    min(length),
    round((avg(length)), 0),
    max(length)
from film;

-- 9
select active,
	count(customer_id) as cnt_customer
from customer
group by active;

-- 10
select concat(c.first_name, ' ', c.last_name) as customer_name,
	min(p.payment_date) as min_payment,
    max(p.payment_date) as max_payment,
    sum(amount) as total_amount
from customer c
join payment p
	on p.customer_id  = c.customer_id
group by customer_name
order by total_amount desc

