/*1. Вивести адресу і місто до якого відноситься ця адреса. (таблиці address,
city).*/

select a.address,
	(select c.city from city c
    where c.city_id = a.address_id) as city
from address a;

select a.address, c.city
	from address a
join city c
	on c.city_id = a.address_id;


/*2. Вивести список міст Аргентини і Австрії. (таблиці city, country). Відсортувати
за алфавітом. country_id
*/

select city from city
where country_id in
	(select country_id from country
    where country_id = country_id
    and country in ("Argentina", "Australia") 
    )
order by city asc;


select city from city
join country
	on city.country_id = country.country_id    
where country in ("Argentina", "Australia")
order by city asc;


/*3. Вивести список акторів, що знімалися в фільмах категорій Music, Sports.
(використати таблиці actor, film_actor, film_category, category).
*/

select first_name, last_name from actor
	where actor_id in ( 
		select actor_id from film_actor
        where film_id in (
			select film_id from film_category
            where category_id in (
				select category_id from category
                where name in ("Music", "Sports")
                )
			)
		);

select distinct first_name, last_name
from actor AS ac
join film_actor as fa on ac.actor_id = fa.actor_id
join film_category as fc on fa.film_id = fc.film_id
join category as c on fc.category_id = c.category_id
where name in ("Music", "Sports");


/*4. Вивести всі фільми, видані в прокат менеджером Mike Hillyer. Для
визначення менеджера використати таблицю staff і поле staff_id; для
визначення фільму скористатися таблицею inventory (поле inventory_id), і
таблиці film (поле film_id).*/

select title from film
where film_id in (
	select film_id from inventory
    where inventory_id in (
		select inventory_id from rental
        where staff_id in (
			select staff_id from staff
			where first_name = "Mike" and last_name = "Hillyer"
        )
    )
);

select distinct title as "Title"
from film as f
join inventory as inv on f.film_id = inv.film_id
join rental as r on inv.inventory_id = r.inventory_id
join staff as s on r.staff_id = s.staff_id
where s.first_name = "Mike" and s.last_name = "Hillyer"
order by title; 


/*5. Вивести користувачів, що брали в оренду фільми SWEETHEARTS
SUSPECTS, TEEN APOLLO, TIMBERLAND SKY, TORQUE BOUND.*/

select first_name, last_name from customer
where customer_id in (
	select customer_id from rental
    where inventory_id in (
		select inventory_id from inventory
        where film_id in (
			select film_id from film
			where title in ("Sweethearts", "Suspects", "Teen Apollo", "Timberland Sky", "Torque Bound")
        )
    )
);

select distinct
	first_name as "First name",
    last_name as "Last name"
from customer as c
join rental as r on c.customer_id = r.customer_id
join inventory as i on r.inventory_id = i.inventory_id
join film as f on i.film_id = f.film_id
where f.title in ("Sweethearts", "Suspects", "Teen Apollo", "Timberland Sky", "Torque Bound");


/*6. Вивести назву фільму, тривалість фільму і мову фільму. Фільтр: мова
Англійська або італійська. (таблиці film, language).*/

select title, length,
    (select name from language AS l
    WHERE l.language_id = f.language_id) AS name
FROM film AS f;

select f.title, f.length, l.name
from film as f
join language as l on f.language_id = l.language_id
where l.name in ("Italian", "English"); 


/*7. Вивести payment_date i amount всіх записів активних клієнтів (поле active
таблиці customer).*/

select payment_date, amount
from payment
where customer_id in (
	select customer_id from customer
    where active = 1
);

select payment_date, amount
from payment as p
join customer as c on p.customer_id = c.customer_id
where c.active = 1;


/*8. Вивести прізвище та ім’я клієнтів, payment_date i amount для активних
клієнтів (поле active таблиці customer).*/

select payment_date, amount,
	(select first_name from customer as c
     where c.customer_id = p.customer_id
    ) as first_name,	
    (select last_name from customer as c
	 where c.customer_id = p.customer_id
    ) as last_name
from payment as p
where customer_id in
	(select customer_id
	 from customer
	 where active = 1);
 
select c.first_name, c.last_name, p.payment_date, p.amount
from payment as p
join customer as c on p.customer_id = c.customer_id;


/*9. Вивести прізвище та ім'я користувачів (customer), які здійснювали оплату в
розмірі більшому, ніж 10 доларів (таблиця payment, поле amount), також
вивести amount, дату оплати. Відсортувати за датою оплати.*/

select amount, payment_date,
	(select first_name
	 from customer as c
	 where c.customer_id = p.customer_id
    ) as first_name, 
    (select last_name
     from customer as c
     where c.customer_id = p.customer_id
    ) as last_name
from payment as p
where amount > 10
order by payment_date;

select c.first_name, c.last_name, p.amount, p.payment_date
from customer as c
join payment as p on c.customer_id = p.customer_id
where p.amount > 10
order by p.payment_date;


/*10.Вивести прізвище та ім’я, а також дату останнього оновлення запису (поле
last_update) для людей наявних в таблицях actor, customer. Також в
результуючому запиті передбачити можливість розрізняти акторів і
користувачів*/

select first_name, last_name, last_update, "actor" as "User type" 
from actor
union
select first_name, last_name, last_update, "customer" as "User type"  
from customer;


/*11. Вивести всі унікальні прізвища таблиць actor, customer, staff
*/

select last_name from actor
union
select last_name from customer
union
select last_name from staff; 
