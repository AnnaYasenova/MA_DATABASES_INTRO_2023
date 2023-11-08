use sakila;

/* 1. Вивести адресу і місто до якого відноситься ця адреса. (таблиці address, city). */
select 
	a.address as "Address",
	(
		select c.city 
        from city as c
        where a.city_id = c.city_id
    ) as "City"
from address as a;

select 
	a.address as "Address",
	c.city as "City"
	from address as a
join city as c
on a.city_id = c.city_id; 

/* 2. Вивести список міст Аргентини і Австрії. (таблиці city, country). Відсортувати за алфавітом. */
select city as "City"
from city
where country_id in 
(
	select country_id
    from country
    where country in ("Argentina", "Austria")
)
order by city asc;

select city as "City"
from city
join country
on city.country_id = country.country_id and country.country in ("Argentina", "Austria")
order by city asc; 

/* 3. Вивести список акторів, що знімалися в фільмах категорій Music, Sports.
(використати таблиці actor, film_actor, film_category, category). */
select distinct
	first_name as "First name",
    last_name as "Last name"
from actor
where actor_id in
(
	select actor_id
    from film_actor
    where film_id in
    (
		select film_id
        from film_category
        where category_id in
        (
			select category_id
            from category
            where name in ("Music", "Sports")
        )
    )
)
order by first_name asc, last_name asc; 

select distinct
	first_name as "First name",
    last_name as "Last name"
from actor as a
join film_actor as fa on a.actor_id = fa.actor_id
join film_category as fc on fa.film_id = fc.film_id
join category as c on fc.category_id = c.category_id
where c.name in ("Music", "Sports")
order by first_name asc, last_name asc; 

/* 4. Вивести всі фільми, видані в прокат менеджером Mike Hillyer. 
Для визначення менеджера використати таблицю staff і поле staff_id; 
для визначення фільму скористатися таблицею inventory (поле inventory_id), і таблиці film (поле film_id). */
select title as "Title"
from film
where film_id in
(
	select film_id
    from inventory
    where inventory_id in
    (
		select inventory_id
        from rental
        where staff_id in
		(
			select staff_id
			from staff
			where first_name = "Mike" and last_name = "Hillyer"
		)
    )
)
order by title;

select distinct title as "Title"
from film as f
join inventory as i on f.film_id = i.film_id
join rental as r on i.inventory_id = r.inventory_id
join staff as s on r.staff_id = s.staff_id
where s.first_name = "Mike" and s.last_name = "Hillyer"
order by title; 

/* 5. Вивести користувачів, що брали в оренду фільми SWEETHEARTS SUSPECTS, TEEN APOLLO, TIMBERLAND SKY, TORQUE BOUND. */
select 
	first_name as "First name",
    last_name as "Last name"
from customer
where customer_id in 
(
	select customer_id
    from rental
    where inventory_id in
    (
		select inventory_id
        from inventory
        where film_id in
        (
			select film_id
            from film
            where title in ("SWEETHEARTS SUSPECTS", "TEEN APOLLO", "TIMBERLAND SKY", "TORQUE BOUND")
        )
    )
)
order by first_name asc, last_name asc;

select distinct
	first_name as "First name",
    last_name as "Last name"
from customer as c
join rental as r on c.customer_id = r.customer_id
join inventory as i on r.inventory_id = i.inventory_id
join film as f on i.film_id = f.film_id
where f.title in ("SWEETHEARTS SUSPECTS", "TEEN APOLLO", "TIMBERLAND SKY", "TORQUE BOUND")
order by first_name asc, last_name asc; 

/* 6. Вивести назву фільму, тривалість фільму і мову фільму. 
Фільтр: мова Англійська або італійська. (таблиці film, language). */
select
	title as "Title",
    length as "Duration",
    (
		select name
        from language as l 
        where l.language_id = f.language_id
    ) as "Language"
from film as f
where language_id in
(
	select language_id
    from language
    where name in ("English", "Italian")
)
order by title asc;

select
	f.title as "Title",
    f.length as "Duration",
    l.name as "Language"
from film as f
join language as l on f.language_id = l.language_id
where l.name in ("Italian", "English")
order by title asc; 

/* 7. Вивести payment_date i amount всіх записів активних клієнтів (поле active таблиці customer). */
select 
	payment_date as "Payment date",
    amount as "Amount"
from payment
where customer_id in
(
	select customer_id
    from customer
    where active = 1
);

select
    p.payment_date as "Payment date",
    p.amount as "Amount"
from customer as c
join payment as p on c.customer_id = p.customer_id
where c.active = 1; 

/* 8. Вивести прізвище та ім’я клієнтів, payment_date i amount для активних клієнтів (поле active таблиці customer). */
select 
	(
		select first_name
        from customer as c
        where c.customer_id = p.customer_id
    ) as "First name",
    (
		select last_name
        from customer as c
        where c.customer_id = p.customer_id
    ) as "Last name",
	payment_date as "Payment date",
    amount as "Amount"
from payment as p
where customer_id in
(
	select customer_id
    from customer
    where active = 1
);

select
	c.first_name as "First name",
    c.last_name as "Last name",
    p.payment_date as "Payment date",
    p.amount as "Amount"
from customer as c
join payment as p on c.customer_id = p.customer_id
where c.active = 1;  

/* 9. Вивести прізвище та ім'я користувачів (customer), 
які здійснювали оплату в розмірі більшому, ніж 10 доларів (таблиця payment, поле amount), 
також вивести amount, дату оплати. Відсортувати за датою оплати. */
select 
	(
		select first_name
        from customer as c
        where c.customer_id = p.customer_id
    ) as "First name", 
    (
		select last_name
        from customer as c
        where c.customer_id = p.customer_id
    ) as "Last name",
    amount as "Amount",
    payment_date  as "Payment date"
from payment as p
where amount > 10
order by payment_date;

select
	c.first_name as "First name", 
    c.last_name as "Last name",
    p.amount as "Amount",
    p.payment_date as "Payment date"
from customer as c
join payment as p on c.customer_id = p.customer_id
where p.amount > 10
order by p.payment_date asc;

/* 10. Вивести прізвище та ім’я, а також дату останнього оновлення запису (поле last_update) 
для людей наявних в таблицях actor, customer. 
Також в результуючому запиті передбачити можливість розрізняти акторів і користувачів. */
select first_name, last_name, last_update, "actor" as "WHO?"
from actor
union all
select first_name, last_name, last_update, "customer" as "WHO?"
from customer; 

/* 11. Вивести всі унікальні прізвища таблиць actor, customer, staff. */
select last_name as "Last name" from actor
union
select last_name from customer
union
select last_name from staff; 