-- #1 under request
select address, 
	(select city from sakila.city as c 
	where c.city_id = a.city_id) as city
	from sakila.address as a 
	order by city;
-- #1 join 
select a.address, c.city from sakila.address as a
	join sakila.city as c
	on c.city_id = a.city_id;
-- #2 under request
select c.city from sakila.city as c
	where c.country_id in (
    select cn.country_id from sakila.country as cn
    where cn.country in ('Argentina', 'Australia'))
    order by c.city;
-- #2 join
select c.city from sakila.city as c
	join sakila.country as cn
    on cn.country_id=c.country_id
    where cn.country in ('Argentina', 'Australia')
    order by c.city;
-- #3 under request 
select * from sakila.actor as a
	where a.actor_id in (
    select actor_id from sakila.film_actor as f_a
    where f_a.film_id in (
    select film_id from sakila.film_category as f_c
    where f_c.category_id in (
    select category_id from sakila.category as c
    where c.name in ('Music', 'Sports'))));
-- #3 join 
select distinct a.* from sakila.actor as a
	join sakila.film_actor as f_a
		on f_a.actor_id=a.actor_id
    join sakila.film_category as f_c
		on f_c.film_id = f_a.film_id
	join sakila.category as c
		on c.category_id=f_c.category_id
	where c.name in ('Music', 'Sports');
-- #4 under request 
select f.title from sakila.film as f
	where f.film_id in (
    select i.film_id from sakila.inventory as i
    where i.inventory_id in (
    select r.inventory_id from sakila.rental as r
    where staff_id in (
    select s.staff_id from sakila.staff as s
    where concat(s.first_name , " ", s.last_name) like "Mike Hillyer")));
-- #4 join 
select distinct f.title from sakila.film as f
	join sakila.inventory as i
    on i.film_id = f.film_id
    join sakila.rental as r
    on r.inventory_id = i.inventory_id
    join sakila.staff as s
    on s.staff_id = r.staff_id
    where concat(s.first_name , " ", s.last_name) like "Mike Hillyer";
-- #5 under request
select * from sakila.customer as c
where c.customer_id in (
select r.customer_id from sakila.rental as r
where r.inventory_id in (
select i.inventory_id from sakila.inventory as i
where i.film_id in (
select f.film_id from sakila.film as f
where f.title in ('SWEETHEARTS SUSPECTS',
					'TEEN APOLLO',
                    'TIMBERLAND SKY',
                    'TORQUE BOUND'))));
-- #5 join 
select distinct c.first_name, c.last_name, c.customer_id from sakila.customer as c
	join sakila.rental as r
    on r.customer_id = c.customer_id
    join sakila.inventory as i
    on i.inventory_id = r.inventory_id
    join sakila.film as f
    on f.film_id = i.film_id
    where f.title in ('SWEETHEARTS SUSPECTS',
					'TEEN APOLLO',
                    'TIMBERLAND SKY',
                    'TORQUE BOUND');
-- #6 under request
select f.title, f.length, (
	select l.name from sakila.language as l
	where l.language_id = f.language_id
	and l.name in ('English', 'Italian')) as language 
	from sakila.film as f;
-- #6 join 
select f.title, f.length, l.name from sakila.film as f
	join sakila.language as l
    on l.language_id = f.language_id;
-- #7 under request
select p.payment_date, p.amount from sakila.payment as p
	where p.customer_id in (
    select c.customer_id from sakila.customer as c
    where c.active = 1);
-- #7 join 
select p.payment_date, p.amount from sakila.payment as p
	join sakila.customer as c
    on c.customer_id = p.customer_id
    where c.active = 1;
-- #8 under request 
select p.payment_date, p.amount, (
	select c.first_name from sakila.customer as c
	where c.customer_id = p.customer_id) as first_name,(
	select c.last_name from sakila.customer as c
	where c.customer_id = p.customer_id) as last_name
	from sakila.payment as p
	where p.customer_id in (
	select c.customer_id from sakila.customer as c
	where c.active = 1);
-- #8 join 
select p.payment_date, p.amount, c.first_name, c.last_name from sakila.payment as p
	join sakila.customer as c 
	on c.customer_id = p.customer_id
    where c.active = 1;
-- #9 under request
select p.payment_date, p.amount, (
	select c.first_name from sakila.customer as c
	where c.customer_id = p.customer_id) as first_name,(
	select c.last_name from sakila.customer as c
	where c.customer_id = p.customer_id) as last_name
	from sakila.payment as p
    where p.amount > 10
    order by p.payment_date;
-- #9 join 
select p.payment_date, p.amount, c.first_name, c.last_name from sakila.payment as p
	join sakila.customer as c 
	on c.customer_id = p.customer_id
    where p.amount > 10
    order by p.payment_date;
-- #10
select 'Actor' as persone, first_name, last_name, last_update
from sakila.actor
union all
select 'Customer', first_name, last_name, last_update
from sakila.customer;
-- #11
select last_name from sakila.actor
union
select last_name from sakila.customer
union
select last_name from sakila.staff;

	
    

    









