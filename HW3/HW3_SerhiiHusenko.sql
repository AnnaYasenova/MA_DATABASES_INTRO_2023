use sakila;

/*
1. Вивести прізвища та імена всіх клієнтів (customer), які не повернули фільми в прокат.
*/
select distinct
	first_name as "First name",
    last_name as "Last name"
from customer as c
join rental as r on c.customer_id = r.customer_id
where return_date is null
order by first_name asc, last_name asc;

/*
2. Виведіть список всіх людей наявних в базі даних (таблиці actor, customer, staff). 
Для виконання використайте оператор union. Вивести потрібно конкатенацію полів прізвище та ім’я.
*/
select concat(first_name, " ", last_name) as "Literally, who?" from actor
union all
select concat(first_name, " ", last_name) from customer
union all
select concat(first_name, " ", last_name) from staff;

/*
3. Виведіть кількість міст для кожної країни.
*/
select 
	country as "Country",
	count(city) as "Number of cities"
from city as ct
join country as cr on ct.country_id = cr.country_id
group by country
order by country asc;

/*
4. Виведіть кількість фільмів знятих в кожній категорії.
*/
select
	c.name as "Category",
    count(f.title) as "Number of films"
from film as f
join film_category as fc on f.film_id = fc.film_id
join category as c on fc.category_id = c.category_id
group by c.name
order by c.name asc;

/*
5. Виведіть кількість акторів що знімалися в кожному фільмі.
*/
select
	f.title as "Film title",
    count(fa.actor_id) as "Number of actors"
from film_actor as fa
join film as f on f.film_id = fa.film_id
group by f.title
order by f.title asc;

/*
6. Виведіть кількість акторів що знімалися в кожній категорії фільмів.
*/
select
	c.name as "Category name",
    count(fa.actor_id) as "Number of actors"
from film_actor as fa
join film as f on f.film_id = fa.film_id
join film_category as fc on fc.film_id = f.film_id
join category as c on c.category_id = fc.category_id
group by c.name
order by c.name asc;

/*
7. Виведіть district та кількість адрес для кожного district, за умови, що district починається на “Central”.
*/
select
	district as "District",
    COUNT(address_id) as "Number of addresses"
from address
where district like "Central%"
group by district
order by district asc;

/*
8. За допомогою одного запиту вивести кількість фільмів в базі даних, мінімальну, 
середню та максимальну вартість здачі в прокат (rental_rate), середню replacement_cost, 
мінімальну, середню та максимальну тривалість фільмів.
*/
select
	count(film_id) as "Number of films",
    min(rental_rate) as "Min rental rate",
    avg(rental_rate) as "Average rental rate",
    max(rental_rate) as "Max rental rate",
    avg(replacement_cost) as "Average rempacement cost",
    min(length) as "Min duration",
    avg(length) as "Average duration",
    max(length) as "Max duration"
from film;

/*
9. Виведіть кількість активних та неактивних клієнтів.(формат: active, кількість клієнтів).
*/
select
	active as "Customer status",
    count(customer_id) as "Number of customers"
from customer
group by active
order by active desc;

-- Альтернатива, бо 0 та 1 для читача то фу
select
    IF(active = 0, 'Inactive', 'Active') as "Customer status",
    count(customer_id) as "Number of customers"
from customer
group by active
order by "Customer status" asc;

/*
10. Виведіть ім’я та прізвище клієнта, дату його першого та останнього платежу 
та загальну кількість грошей які він заплатив. (таблиці payment, customer)
*/
select
	concat(c.first_name, " ", c.last_name) as "Customer",
    min(payment_date) as "First payment",
    max(payment_date) as "Last payment",
    sum(amount) as "Total spent"
from customer as c
join payment as p on c.customer_id = p.customer_id
group by c.customer_id
order by c.first_name asc, c.last_name asc;