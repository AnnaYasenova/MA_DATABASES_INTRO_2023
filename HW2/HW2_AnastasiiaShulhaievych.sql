-- Вивести адресу і місто до якого відноситься ця адреса. (таблиці address, city).
select
	address.address, 
	city.city
from address join city 
	on address.city_id = city.city_id;
    
select address, 
	  (select city from city where address.city_id = city.city_id) as city
from address;

-- Вивести список міст Аргентини і Австрії. (таблиці city, country). Відсортувати за алфавітом
select city from city
join country on city.country_id = country.country_id
	where country in ("Argentina", "Australia")
    order by city;

select city from city
where country_id in( select country_id from country
					where city.country_id = country.country_id 
                    and country in("Argentina", "Australia")
)
order by city;

-- Вивести список акторів, що знімалися в фільмах категорій Music, Sports.
-- (використати таблиці actor, film_actor, film_category, category).

select distinct actor.* from actor
join film_actor on actor.actor_id = film_actor.actor_id
	join film_category on film_actor.film_id = film_category.film_id
		join category on film_category.category_id = category.category_id
		where name in ("Music", "Sports");
        
select distinct * from actor
where actor_id in (
		select actor_id from film_actor
		where film_id in (
			select film_id from film_category
            where category_id in (
				select category_id from category
                where name in ("Music", "Sports")
)));

-- Вивести всі фільми, видані в прокат менеджером Mike Hillyer. Для
-- визначення менеджера використати таблицю staff і поле staff_id; для
-- визначення фільму скористатися таблицею inventory (поле inventory_id), і
-- таблиці film (поле film_id).

select distinct title as film from film
join inventory on film.film_id = inventory.film_id
	join rental on inventory.inventory_id = rental.rental_id
		join staff on rental.staff_id = staff.staff_id
		where staff.first_name = "Mike" and staff.last_name = "Hillyer";
        
select title as film from film
where film_id in(
		select film_id from inventory
        where inventory_id in(
			select inventory_id from rental
            where staff_id in(
				select staff_id from staff
                where staff.first_name = "Mike" and staff.last_name = "Hillyer"
)));

-- Вивести користувачів, що брали в оренду фільми SWEETHEARTS
-- SUSPECTS, TEEN APOLLO, TIMBERLAND SKY, TORQUE BOUND.

select distinct first_name, last_name from customer
join rental on customer.customer_id = rental.customer_id
	join inventory on rental.inventory_id = inventory.inventory_id
		join film on inventory.film_id = film.film_id
        where film.title in ("SWEETHEARTS SUSPECTS", "TEEN APOLLO", "TIMBERLAND SKY", "TORQUE BOUND");

select first_name, last_name from customer
where customer_id in(
	select customer_id from rental
    where inventory_id in (
		select inventory_id from inventory
        where film_id in(
			select film_id from film
            where title in ("SWEETHEARTS SUSPECTS", "TEEN APOLLO", "TIMBERLAND SKY", "TORQUE BOUND")
)));

-- . Вивести назву фільму, тривалість фільму і мову фільму. Фільтр: мова
-- Англійська або італійська. (таблиці film, language).

select 
	film.title, 
    film.length, 
    language.name as language
from film join language on film.language_id = language.language_id
where language.name = "English" or language.name = "Italian";

select 
	title, 
    length,
    (select name from language
    where language_id = film.language_id
    and (language.name = "English" or language.name = "Italian")) as language
from film;

-- Вивести payment_date i amount всіх записів активних клієнтів (поле active
-- таблиці customer).

select payment_date, amount from payment
join customer on payment.customer_id = customer.customer_id
where active = 1;

select payment_date, amount from payment
where customer_id in (
	select customer_id from customer
    where active = 1
);

-- Вивести прізвище та ім’я клієнтів, payment_date i amount для активних
-- клієнтів (поле active таблиці customer).

select
	customer.last_name,
    customer.first_name,
    payment.payment_date,
    payment.amount
from customer join payment on customer.customer_id = payment.customer_id
where customer.active = 1;

select 
	(select last_name from customer
    where customer_id = payment.customer_id and active = 1) as last_name,
    (select first_name from customer
    where customer_id = payment.customer_id and  active = 1) as first_name,
    payment_date,
    amount
from payment;

--  Вивести прізвище та ім'я користувачів (customer), які здійснювали оплату в
-- розмірі більшому, ніж 10 доларів (таблиця payment, поле amount), також
-- вивести amount, дату оплати. Відсортувати за датою оплати.

select 
	customer.last_name,
    customer.first_name,
    payment.amount,
    payment.payment_date
from customer join payment on customer.customer_id = payment.customer_id
where payment.amount > 10
order by payment.payment_date;

select 
	(select last_name from customer
    where customer.customer_id = payment.customer_id) as last_name,
	(select first_name from customer
    where customer.customer_id = payment.customer_id) as first_name,
    amount,
    payment_date
from payment
where payment.amount > 10
order by payment_date;

-- .Вивести прізвище та ім’я, а також дату останнього оновлення запису (поле
-- last_update) для людей наявних в таблицях actor, customer. Також в
-- результуючому запиті передбачити можливість розрізняти акторів і
-- користувачів.

select first_name, last_name, last_update, "customer" as category from customer
union all
select first_name, last_name, last_update, "actor" as category from actor;

--  Вивести всі унікальні прізвища таблиць actor, customer, staff.

select last_name from actor
union
select last_name from customer
union
select last_name from staff;


