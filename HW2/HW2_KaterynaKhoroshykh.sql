select a.address, c.city 
from address as a
join city as c
on a.city_id = c.city_id;

select a.address,
(select city from city as c 
where c.city_id = a.city_id) as city
from address as a;

select c.city
from city as c
join country as co
on c.country_id = co.country_id
where co.country in ('Argentina', 'Austria')
order by c.city;

select c.city
from city as c
where c.country_id in 
(select co.country_id
from country as co
where co.country in ('Argentina', 'Austria'))
order by c.city;

select distinct first_name, last_name
from actor as a
join film_actor as fa
on a.actor_id = fa.actor_id
join film_category as fc
on fa.film_id = fc.film_id
join category as c
on fc.category_id = c.category_id
where name in ('Music','Sports');

select distinct first_name, last_name
from actor as a
where a.actor_id in
(select fa.actor_id from film_actor as fa
	where fa.film_id in 
	(select fc.film_id from film_category as fc
		where fc.category_id in
		(select c.category_id from category as c
        where name in ('Music','Sports')
        )
	)
);

select distinct title from film as f
join inventory as i on f.film_id = i.film_id
join rental as r on i.inventory_id = r.inventory_id
join staff as s on r.staff_id = s.staff_id
where s.first_name = "Mike" and s.last_name = "Hillyer";

select distinct title from film as f
where f.film_id in
(select i.film_id from inventory as i
	where i.inventory_id in
    (select r.inventory_id from rental as r
		where r.staff_id in
        (select s.staff_id from staff as s
        where s.first_name = "Mike" and s.last_name = "Hillyer"
        )
	)
);

select distinct first_name, last_name from customer as c
join rental as r on c.customer_id = r.customer_id
join inventory as i on r.inventory_id = i.inventory_id
join film as f on i.film_id = f.film_id
where title in ("SWEETHEARTS", "SUSPECTS", "TEEN APOLLO", "TIMBERLAND SKY", "TORQUE BOUND");

select distinct first_name, last_name from customer as c
where c.customer_id in
	(select r.customer_id from rental as r
    where r.inventory_id in
		(select i.inventory_id from inventory as i
        where i.film_id in
			(select f.film_id from film as f 
            where title in ("SWEETHEARTS", "SUSPECTS", "TEEN APOLLO", "TIMBERLAND SKY", "TORQUE BOUND")
            )
		)
	);
    

select f.title, f.length, l.name from film as f
join language as l on f.language_id = l.language_id
where name in ("English", "Italian");

select title, length,
(select name from language as l
where l.language_id = f.language_id) as name from film as f;

select payment_date, amount from payment as p
join customer as c on p.customer_id = c.customer_id
where active = 1;
            
select payment_date, amount from payment as p
where p.customer_id in
	(select c.customer_id from customer as c
    where active = 1);
    
select c.first_name, c.last_name, p.payment_date, p.amount from payment as p
join customer as c on p.customer_id = c.customer_id
where active = 1;

select
(select first_name from customer as c
where c.customer_id = p.customer_id) as first_name,
    (select last_name from customer as c
    where c.customer_id = p.customer_id) as last_name,
		p.payment_date, p.amount from payment as p
		where customer_id in 
			(select customer_id from customer
			where active = 1);

select c.first_name, c.last_name, p.payment_date, p.amount from payment as p
join customer as c on p.customer_id = c.customer_id
where p.amount >=10
order by payment_date;

SELECT
	(select first_name from customer as c
    where c.customer_id = p.customer_id) as first_name,
		(select last_name from customer as c
		where c.customer_id = p.customer_id) as last_name,
		p.payment_date, p.amount from payment as p
		where p.amount >= 10
		order by p.payment_date;
        
select first_name, last_name, last_update, "actor" as catergory from actor
union
select first_name, last_name, last_update, "customer" as catergory from customer;

select first_name, last_name, last_update, "actor" as catergory from actor
union
select first_name, last_name, last_update, "customer" as catergory from customer
union
select null as email, first_name, last_name, "staff" as catergory from staff;