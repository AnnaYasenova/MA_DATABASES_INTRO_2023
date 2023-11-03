select * from film;

select * from film_category;

select * from category;

select * from film_category
where film_id = 5;

select * from category
where category_id = 8;

select * from film_category
where category_id = 7;

select * from film
where film_id in (33, 61, 63, 79);


-- sub queries
select * from film_category
where category_id = (
    select category_id from category
    where name = 'Comedy'
);

select title, description from film
where film_id in (
    select film_id from film_category
    where category_id in (
        select category_id from category
        where name = 'Comedy'
    )
);

select title, rating from film
where film_id in (
    select film_id from film_category
    where category_id in (
        select category_id from category
        where name = 'Comedy'
    )
) and rating = 'PG';


-- JOIN
select * from film_category as fc
join category as c
    on fc.category_id = c.category_id;

select fc.film_id, c.name as category_name -- fc.*
from film_category as fc
join category as c
    on fc.category_id = c.category_id;

select
    c.name as category_name,
    f.title,
    f.description,
    f.special_features
from film_category as fc
join category as c
    on fc.category_id = c.category_id
join film as f
    on f.film_id = fc.film_id;

select
    c.name as category_name,
    f.title,
    f.description,
    f.special_features
from film_category as fc
join category as c
    on fc.category_id = c.category_id
join film as f
    on f.film_id = fc.film_id
where c.name = 'Comedy';

select * from payment;

select * from customer;

-- JOIN vs sub queries
select
    c.first_name,
    c.last_name,
    p.amount,
    p.payment_date
from payment as p
join customer as c
    on c.customer_id = p.customer_id;

select
    (
        select first_name from customer as c
        where c.customer_id = p.customer_id
    ) as first_name,
    (
        select last_name from customer as c
        where c.customer_id = p.customer_id
    ) as last_name,
    payment_date,
    amount
from payment as p;



select
    c.first_name,
    c.last_name,
    sum(p.amount) as total_amount
from payment as p
join customer as c
    on c.customer_id = p.customer_id
group by c.customer_id;


-- UNION
select * from actor;

select * from customer;

select * from staff;

select first_name, last_name, 'staff' as category from staff
union
select first_name, last_name, 'customer' as category from customer
union
select first_name, last_name, 'actor' as category from actor;


-- UION and UNION ALL
select first_name from actor
union
select first_name from customer;

select first_name from actor
union all
select first_name from customer;

with cte as (
    select first_name from actor
    union
    select first_name from customer
)
select * from cte where first_name = 'MARY';

with cte as (
    select first_name from actor
    union all
    select first_name from customer
)
select * from cte where first_name = 'MARY';
