-- #1
select c.first_name, c.last_name from sakila.customer as c
join sakila.rental as r
on r.customer_id = c.customer_id
where r.return_date is null;
-- #2
select concat(a.first_name, ' ', a.last_name) as name 
from sakila.actor as a
union all
select concat(c.first_name, ' ', c.last_name) as name 
from sakila.customer as c
union all 
select concat(s.first_name, ' ', s.last_name) as name 
from sakila.staff as s;
-- #3
select ct.country ,count(c.city) as 'amount city' 
from sakila.city as c
join sakila.country as ct
on ct.country_id = c.country_id
group by ct.country;
-- #4
select c.name, count(f.film_id) as 'amount film'
from sakila.category as c
join sakila.film_category as f_c
on f_c.category_id = c.category_id
join sakila.film as f
on f.film_id = f_c.film_id
group by c.name;
-- #5
select f.title, count(a.actor_id) as 'amount acrot'
from sakila.film as f
join sakila.film_actor as f_a
on f_a.film_id = f.film_id
join sakila.actor as a
on a.actor_id = f_a.actor_id
group by f.title;
-- #6 
select c.name, count(a.actor_id) as 'amount actor' 
from sakila.category as c
join sakila.film_category as f_c
on f_c.category_id = c.category_id
join sakila.film as f
on f.film_id = f_c.film_id
join sakila.film_actor as f_a
on f_a.film_id = f.film_id
join sakila.actor as a
on a.actor_id = f_a.actor_id 
group by c.name;
-- #7
select a.district, count(a.address) from sakila.address as a
where a.district like 'Central%'
group by a.district;
-- #8
select 
count(f.film_id) as 'amount films',
min(f.rental_rate) as 'minimum rental rate',
avg(f.rental_rate) as 'average rental rate',
max(f.rental_rate) as 'max rental rate',
avg(f.replacement_cost) as 'average repalacement cost',
min(f.length) as 'minimum length film',
avg(f.length) as 'average length film',
max(f.length) as 'max length film'
from sakila.film as f;
-- #9
select 'active' as status, count(c.active) from sakila.customer as c
where c.active = 1
union
select 'no active' as status, count(c.active) from sakila.customer as c
where c.active = 0;
-- #10
select c.first_name, c.last_name,
min(p.payment_date) as 'first pay day',
max(p.payment_date) as 'last pay day',
sum(p.amount) as 'sum'
from sakila.payment as p
join sakila.customer as c
on c.customer_id = p.customer_id
group by c.customer_id


