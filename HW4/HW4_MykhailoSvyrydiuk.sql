-- 1
with s as (
	select staff_id
    from staff
    where first_name = 'Mike' 
		and last_name = 'Hillyer'
),
r as (
	select inventory_id
    from rental
    where staff_id = (select staff_id from s)
),
i as (
	select film_id
    from inventory
    where inventory_id in (select inventory_id from r)
)

select distinct title
from film
where film_id in (select film_id from i)
order by 1;

-- 2
with 
f as (
	select film_id
    from film
    where title in ('SWEETHEARTS', 'SUSPECTS', 'TEEN APOLLO', 'TIMBERLAND SKY', 'TORQUE BOUND')
),

i as (
	select inventory_id
    from inventory
    where film_id in (select film_id from f)
),

r as (
	select customer_id
    from rental
    where inventory_id in (select inventory_id from i)
)

select concat(first_name, ' ', last_name) as name
from customer 
where customer_id in (select customer_id from r)
;

-- 3
select title 
from film 
where replacement_cost > 10;

with r as (select inventory_id
	from rental 
	where return_date is null
),
i as (
	select film_id
    from inventory
    where inventory_id in (select inventory_id from r)
)

select title, replacement_cost
from film
where film_id in (select film_id from i)
    and replacement_cost > 10;
    
-- 4
with p as (
	select rental_id, amount
	from payment
),
r as (
	select inventory_id, rental_id
    from rental 
    where rental_id in (select rental_id from p)
),
i as (
	select film_id, inventory_id
    from inventory
    where inventory_id in (select inventory_id from r)
)

select (f.title), count(p.amount) as amount
from film f
join i on f.film_id = i.film_id
join r on i.inventory_id = r.inventory_id
join p on r.rental_id = p.rental_id
group by f.title;

-- 5
-- v5.1
select 
		count(case when return_date is null then 1 end)as 'not return',
        count(case when return_date is not null then 1 end) as 'return'
	from rental;
-- v5.2
select 
	case 
		when return_date is null then 'not return'
        when return_date is not null then 'return'
        end as  status,
	count(*) as count
    from rental
    group by status;

-- 6
select concat((substring(first_name, 1, 1)), '. ', last_name) as customer,
	count(p.amount) as amount
from customer c
join payment p on c.customer_id = p.customer_id
group by customer;

-- 7
select f.title as title,
    c.name as category,
    group_concat(concat(a.first_name, ' ', a.last_name)separator ', ') as actor
from film f
join film_category fc on fc.film_id = f.film_id
join category c on c.category_id = fc.category_id
join film_actor fa on fa.film_id = f.film_id
join actor a on a.actor_id = fa.actor_id
where  length = (select min(length) from film)
group by title, category;

-- 8
select 
	case
		when rental_rate < 2 then 'low_rental_rate'
        when rental_rate between 2 and 4 then 'medium_rental_rate'
        when rental_rate > 4 then 'high_rental_rate'
        end as rental_rate,
    count(title)
from film
group by rental_rate;