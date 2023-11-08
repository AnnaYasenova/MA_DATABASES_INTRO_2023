use sakila;

-- 1
select a.address, 
		c.city
from address AS a

JOIN city AS c 
ON a.city_id = c.city_id;
--
select a.address, 
	(select city from city c where a.city_id = c.city_id )AS city
from address a;

-- 2
select 
	c.city
from city c
join country ct
ON c.country_id = ct.country_id
WHERE ct.country IN ('Argentina', 'Austria');
--
select city
from city
where country_id in (
						select country_id 
						from country 
						where country in ('Argentina', 'Austria')
	);

-- 3
select 
	a.first_name,
    a.last_name,
    c.name
from actor a

join film_actor fa
	on a.actor_id = fa.actor_id

join film_category fc
	on fc.film_id = fa.film_id
    
join category c
	on c.category_id = fc.category_id
	where c.name in ('Music', 'Sports');
    --
select   a.first_name,
    a.last_name
from actor a
where actor_id in (
		select actor_id from film_actor
        where film_id in (
			select film_id from film_category
            where category_id in (
				select category_id from category 
                where name in ('Music', 'Sports')
                )
			)
		);
    
-- 4
select distinct (f.title),
	s.first_name, s.last_name
from staff s

join rental r
 on s.staff_id = r.staff_id
 
join inventory i
 on i.inventory_id = r.inventory_id
 
 join film f
  on f.film_id = i.film_id
 
where s.first_name = 'Mike' 
	and s.last_name = 'Hillyer';
--
select distinct (title)
from film 
where film_id in (
			select film_id from inventory
            where inventory_id in (
				select inventory_id from rental
                where staff_id in (
					select staff_id from staff
                    where first_name = 'Mike' 
						and last_name = 'Hillyer'
                        )
					)
				);
    
-- 5
select distinct (first_name),
	last_name
from customer
where customer_id in (
	select customer_id from rental
    where inventory_id in (
		select inventory_id from inventory
        where film_id in (
			select film_id from film
            where title in ('SWEETHEARTS' , 'SUSPECTS', 'TEEN APOLLO', 'TIMBERLAND SKY', 'TORQUE BOUND')
            )
		)
	)
    order by last_name;
--
select distinct (c.first_name),
	c.last_name
from customer c

 join rental r
	on r.customer_id = c.customer_id
 
 join inventory i
	on i.inventory_id = r.inventory_id
    
join film f
	on f.film_id = i.film_id
	where f.title in ('SWEETHEARTS' , 'SUSPECTS', 'TEEN APOLLO', 'TIMBERLAND SKY', 'TORQUE BOUND')
order by c.last_name;

-- 6
select distinct (title),
	length,
	(select name from language  where language_id = f.language_id) as language
from film f;
--
select distinct(f.title),
	f.length,
    l.name as language
    
from film f
join language l
	on f.language_id = l.language_id;
    
-- 7
select payment_date,
	amount
from payment
where customer_id in (
	select customer_id from customer
    where active != 0);
--
select p.payment_date,
	p.amount
from payment p

join customer c
 on c.customer_id = p.customer_id
 where c.active != 0;

-- 8
select 
    (select last_name from customer c
		where c.customer_id = p.customer_id and c.active != 0) as last_name,
	(select first_name from customer c
    where c.customer_id = p.customer_id and c.active != 0) as first_name,
		payment_date,
		amount
from payment p
where (select c.active from customer c
    where c.customer_id = p.customer_id) != 0
;
--
select c.last_name,
	c.first_name,
    p.payment_date,
    p.amount
from customer c
join payment p
	on c.customer_id = p.customer_id
where c.active != 0;

-- 9
SELECT (SELECT last_name FROM customer c 
			WHERE c.customer_id = p.customer_id) AS last_name,
		(SELECT first_name FROM customer c 
			WHERE c.customer_id = p.customer_id) AS first_name,
		amount,
        payment_date
FROM payment p
WHERE p.amount > 10
ORDER BY p.payment_date ASC;
--
SELECT c.last_name,
	c.first_name,
    p.amount,
    p.payment_date
FROM customer c
JOIN payment p
	ON c.customer_id = p.customer_id
WHERE p.amount > 10
ORDER BY p.payment_date ASC;
		
-- 10
SELECT first_name, last_name, last_update, 'customer' AS category FROM customer
UNION 
SELECT first_name, last_name, last_update, 'actor' AS category FROM actor;

-- 11
SELECT DISTINCT (last_name) FROM actor
UNION
SELECT DISTINCT (last_name) FROM customer
UNION
SELECT DISTINCT (last_name) FROM staff
ORDER BY 1 ASC;
