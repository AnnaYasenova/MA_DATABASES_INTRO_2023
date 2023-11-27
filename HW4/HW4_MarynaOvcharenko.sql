--Вивести всі фільми, видані в прокат менеджером Mike Hillyer. Для
визначення менеджера використати таблицю staff і поле staff_id; для
визначення фільму скористатися таблицею inventory (поле inventory_id), і
таблиці film (поле film_id). (Це завдання ви виконували в другому ДЗ, цього
разу для виконання завдання потрібно використати common table
expression)

select * from film
select * from inventory
select * from rental
select * from staff

with staff_name_cte as (
	select staff_id from staff
	where first_name = "Mike" and last_name = "Hillyer"
), rental_cte as (
	select inventory_id from rental 
    where staff_id in (select * from staff_name_cte)
), inventory_cte as (
	select film_id from inventory
    where inventory_id in (select * from rental_cte)
), title_cte as (
	select title from film
    where film_id in (select * from inventory_cte)
)
select * from title_cte;

--Вивести користувачів, що брали в оренду фільми SWEETHEARTS
SUSPECTS, TEEN APOLLO, TIMBERLAND SKY, TORQUE BOUND. (Це
завдання ви виконували в другому ДЗ, цього разу для виконання завдання
потрібно використати common table expression)

select * from customer;
select * from rental;
select * from inventory;
select * from film;


with film_cte as (
	select film_id from film
    where title in 
('SWEETHEARTS SUSPECTS' , 'TEEN APOLLO' , 'TIMBERLAND SKY' , 'TORQUE BOUND')
), inventory_cte as (
	select inventory_id from inventory
    where film_id in ( select * from film_cte)
), rental_cte as (
	select customer_id from rental
	where inventory_id in ( select * from inventory_cte)
), customer_cte as (
	select first_name, last_name, customer_id from customer
    where customer_id in ( select * from rental_cte)
)
   select * from customer_cte;
   
--Вивести список фільмів, неповернених в прокат, replacement_cost яких
більший 10 доларів.

select distinct f.title, f.replacement_cost
from film f 
join inventory i on f.film_id = i.film_id
join rental r on r.inventory_id=i.inventory_id
where r.return_date is null and f.replacement_cost >10;

--Виведіть назву фільму та загальну кількість грошей отриманих від здачі
цього фільму в прокат (таблиці payment, rental, inventory, film)

select * from payment
select * from rental
select * from inventory
select * from film

select
    f.title,
    SUM(p.amount) as total_amount
from film f
join inventory i 
	on f.film_id = i.film_id
join rental r 
	on i.inventory_id = r.inventory_id
join payment p 
	on r.rental_id = p.rental_id
group by f.title;
