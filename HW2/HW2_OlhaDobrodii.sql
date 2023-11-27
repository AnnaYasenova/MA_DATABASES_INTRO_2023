use sakila;

-- 1
select a.address, c.city from city c
join address a
	on c.city_id = a.address_id;

select a.address,
	(
	select c.city from city c
	where c.city_id = a.address_id
	) 
as city from address a;
    
-- 2
select city.city from city
join country 
	on city.country_id = country.country_id
    where country.country in ("Argentina", "Austria")
    order by city.city asc;

select city from city
where country_id in 
	(
	select country_id from country 
	where country_id = country_id and country.country in ("Argentina", "Austria")
   );
    
-- 3
select first_name, last_name from actor 
where actor_id in (
	select actor_id from film_actor
	where  film_id in (
			select film_id from film_category
			where category_id in (
					select category_id from category
					where name in ('Music', 'Sports')
					)));
                        
select distinct first_name, last_name from actor as ac
join film_actor as fa on ac.actor_id = fa.actor_id
join film_category as fc on fa.film_id = fc.film_id
join category as c on fc.category_id = c.category_id
	where name in ('Music', 'Sports');

-- 4
select distinct title as 'title' from film as f
join inventory as i on f.film_id = i.film_id
join rental as r on i.inventory_id = r.inventory_id
join staff as s on r.staff_id = s.staff_id
	where s.first_name = 'Mike' and s.last_name = 'Hillyer'
	order by title;

select title from film 
where film_id in (
	select film_id from inventory
	where  inventory_id in (
			select inventory_id from rental
			where staff_id in (
					select staff_id from staff
					where first_name = 'Mike' and last_name = 'Hillyer'
                        )));

-- 5 
select first_name, last_name from customer
where customer_id in (
	select customer_id from rental
    where inventory_id in (
		select inventory_id from inventory
        where film_id in (
			select film_id from film
			where title in ("Sweethearts", "Suspects", "Teen Apollo", "Timberland Sky", "Torque Bound")
        )));
              
-- 6
select title, length, language_id from film;
select language_id from film;
select* from language;

select f.title, f.length, e.name from film as f
join language as e on f.language_id = e.language_id
	where e.name in ('Italian', 'English');

-- 7
select payment_date, amount from payment
where customer_id in (
	select customer_id from customer 
    where active = 1);

select  payment_date, amount from payment as p
join customer as c on p.customer_id = c.customer_id
	where active = 1;

-- 8
select payment_date, amount from payment
where customer_id in (
	select customer_id from customer 
    where active = 1);

select n.first_name, n.last_name, p.payment_date, p.amount from payment as p
join customer as n on p.customer_id = n.customer_id;

-- 9
select amount, payment_date,
	(
        select first_name from customer as c
        where c.customer_id = p.customer_id 
	) as first_name,
     
	(
		select last_name from customer as c 
        where c.customer_id = p.customer_id 
	) as last_name
    
    from payment as p
    where amount > 10
    order by payment_date;

select c.first_name, c.last_name, p.payment_date, p.amount from customer as c
join payment as p on c.customer_id = p.customer_id;

-- 10
select first_name, last_name, last_update, 'actor' as 'User type'
from actor
union
select first_name, last_name, last_update, 'actor' as 'User type'
from customer;

-- 11
select last_name from actor
union
select last_name from customer
union
select last_name from staff;

select last_name,  'staff' as category from staff
union
select last_name,  'customer' as category from customer
union
select last_name,   'actor' as category from actor;
