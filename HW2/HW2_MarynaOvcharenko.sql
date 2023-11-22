--Вивести адресу і місто до якого відноситься ця адреса. (таблиці address,city).

--under request

select address, 
	  (select city from city 
	   where city.city_id = address.city_id) 
	as city
from address;   

--join

select address, city from address
join city 
on address.city_id=city.city_id;

--Вивести список міст Аргентини і Австрії. (таблиці city, country). Відсортувати
за алфавітом.

--under request

select city from city 
where country_id in (
		select country_id from country
		where country in ('Austria' , 'Argentina')
        )
order by city;

--join
        
select city.city, country.country from city
join country
on city.country_id = country.country_id
	where country.country in ('Austria' , 'Argentina')
order by city.city;
       
--Вивести список акторів, що знімалися в фільмах категорій Music, Sports.
(використати таблиці actor, film_actor, film_category, category).

--under request

select distinct first_name, last_name from actor
where actor_id in (
select actor_id from film_actor
where film_id in (
select film_id from film_category
where category_id in (
select category_id from category
		where name in ('Music','Sports')
        )));
        
--join

select distinct actor.first_name, actor.last_name from actor 
join film_actor on actor.actor_id=film_actor.actor_id
join film_category on film_actor.film_id=film_category.film_id
join category on film_category.category_id=category.category_id
		where name in ('Music','Sports');
 
 --join alias
 
select distinct a.* from actor as a
join film_actor as f_a on a.actor_id=f_a.actor_id
join film_category as f_c on f_a.film_id=f_c.film_id
join category as c on f_c.category_id=c.category_id
		where name in ('Music','Sports');       
        
--Вивести всі фільми, видані в прокат менеджером Mike Hillyer. Для 
визначення менеджера використати таблицю staff і поле staff_id; для
визначення фільму скористатися таблицею inventory (поле inventory_id), і таблиці film (поле film_id).
 
--under request
        
select title from film 
where film_id in(
select film_id from inventory
where inventory_id in (
select inventory_id from rental
where staff_id in (
 select staff_id from staff
 where first_name = 'Mike'and last_name = 'Hillyer')));     
 
 --join 
 
 select title from film
 join inventory on inventory.film_id=film.film_id
 join rental on rental.inventory_id=inventory.inventory_id
 join staff on rental.staff_id=staff.staff_id
     where first_name = 'Mike'and last_name = 'Hillyer';
     
--Вивести користувачів, що брали в оренду фільми SWEETHEARTS
SUSPECTS, TEEN APOLLO, TIMBERLAND SKY, TORQUE BOUND.

--under request

select * from customer;
select * from rental;
select * from inventory;
select * from film;

select first_name, last_name, customer_id from customer 
where customer_id in (
select customer_id from rental
where inventory_id in (
select inventory_id from inventory 
where film_id in ( 
select film_id from film 
where title in 
('SWEETHEARTS SUSPECTS' , 'TEEN APOLLO' , 'TIMBERLAND SKY' , 'TORQUE BOUND'))));

--join 

select distinct * from customer as c
join rental as r on c.customer_id=r.customer_id 
join inventory as i on i.inventory_id=r.inventory_id
join film as f on i.film_id=f.film_id
   where title in 
  ('SWEETHEARTS SUSPECTS' , 'TEEN APOLLO' , 'TIMBERLAND SKY' , 'TORQUE BOUND');

--Вивести назву фільму, тривалість фільму і мову фільму. Фільтр: мова
Англійська або італійська. (таблиці film, language).

select * from film;
select * from language;

--under request

select f.title, f.length, (
	select name from language as l
	where l.language_id=f.language_id
	and name in ( 'English' , 'Italian'))
	as language
from film as f;

--join 

select distinct f.title, f.length, l.name as language from film as f
	join language as l on l.language_id=f.language_id
    where name in ( 'English' , 'Italian');
    
--Вивести payment_date i amount всіх записів активних клієнтів (поле active
таблиці customer).

select * from customer;
select * from payment;

--under request

select payment_date, amount 
from payment
where customer_id in (
select customer_id from customer 
where active =1
);

--join

select payment_date, amount 
from payment as p
join customer as c on p.customer_id=c.customer_id 
where active =1;

--Вивести прізвище та ім’я клієнтів, payment_date i amount для активних
клієнтів (поле active таблиці customer).

select * from customer;
select * from payment;

--under request

select 
(
  select first_name from customer as c
  where c.customer_id=p.customer_id
  ) as first_name,
 (
  select last_name from customer as c
  where c.customer_id=p.customer_id
  )
  as last_name, 
  p.payment_date,
  p.amount
  from payment as p
  where customer_id in (
	select customer_id from customer 
	where active =1);
    
--join
    
select 
    c.first_name, 
    c.last_name,
    p.payment_date,
    p.amount
from payment as p
join customer as c on c.customer_id=p.customer_id
	where c.active =1;

-- Вивести прізвище та ім'я користувачів (customer), які здійснювали оплату в
розмірі більшому, ніж 10 доларів (таблиця payment, поле amount), також
вивести amount, дату оплати. Відсортувати за датою оплати.

select 
(
  select first_name from customer as c
  where c.customer_id=p.customer_id
  ) as first_name,
 (
  select last_name from customer as c
  where c.customer_id=p.customer_id
  )as last_name, 
  p.payment_date,
  p.amount
from payment as p
where p.amount>10
order by payment_date;

--join
    
select 
    c.first_name, 
    c.last_name,
    p.payment_date,
    p.amount
from payment as p
join customer as c on c.customer_id=p.customer_id
where p.amount>10
order by payment_date;

--Вивести прізвище та ім’я, а також дату останнього оновлення запису (поле
last_update) для людей наявних в таблицях actor, customer. Також в
результуючому запиті передбачити можливість розрізняти акторів і
користувачів

select first_name, last_name, last_update, 'actor' as category from actor
union 
select first_name, last_name, last_update, 'customer' as category from customer;

--Вивести всі унікальні прізвища таблиць actor, customer, staff

select last_name from actor
union
select last_name from customer
union
select last_name from staff;

