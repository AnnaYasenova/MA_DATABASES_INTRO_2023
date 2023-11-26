select first_name, last_name 
from customer as c
join rental as r
on c.customer_id = r.customer_id 
and return_date is null;

select concat (first_name, ' ', last_name) as humans from actor
union 
select concat (first_name, ' ', last_name) as humans from customer
union
select concat (first_name, ' ', last_name) as humans from staff;

select country, count(c.city_id) as cities_number
from country as co
join city as c
on co.country_id=c.country_id
group by co.country;

select c.name as category_name, 
count(f.film_id) as film_number
from category as c
join film_category as fc
on c.category_id=fc.category_id
join film as f 
on fc.film_id=f.film_id
group by c.name;

select f.title as film_title,
count(a.actor_id) as actors_number
from film as f
join film_actor as fa 
on fa.film_id = f.film_id
join actor as a
on fa.actor_id = a.actor_id
group by f.title;

select c.name as category_name, 
count(a.actor_id) as actors_number
from category as c
join film_category as fc 
on c.category_id = fc.category_id
join film as f 
on fc.film_id = f.film_id
join film_actor as fa
on fa.film_id = f.film_id
join actor as a 
on fa.actor_id = a.actor_id
group by c.name;

select district,
count(address_id) as address_count
from address
where district like 'Central%'
group by district;

select 
count(f.film_id) as all_films,
min(f.rental_rate) as min_rental_rate,
avg(f.rental_rate) as avg_rental_rate,
max(f.rental_rate) as max_rental_rate,
avg(replacement_cost) as avg_replacement_cost,
min(f.length) as min_length,
avg(f.length) as avg_length,
max(f.length) as max_length
from film as f;

select case
when active = 1 then 'active' 
else 'inactive' 
end as statuses,
count(customer_id) as client_count
from customer
group by active;

select customer.first_name, customer.last_name,
min(payment.payment_date) as first_payment,
max(payment.payment_date) as last_payment,
sum(payment.amount) as total_paid
from customer
join payment
on customer.customer_id = payment.customer_id
group by customer.customer_id;