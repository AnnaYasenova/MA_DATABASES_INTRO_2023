/*
	1. Вивести прізвища та імена всіх клієнтів (customer), які не повернули фільми
	   в прокат.
*/


select
	c.first_name,
	c.last_name
from
	rental as r
join customer as c on
	r.customer_id = c.customer_id
where
	r.return_date is null;
	

/*
	2. Виведіть список всіх людей наявних в базі даних (таблиці actor, customer,
	   staff). Для виконання використайте оператор union. Вивести потрібно
	   конкатенацію полів прізвище та ім’я.
*/

select
	concat_ws(" ",
	first_name,
	last_name) as name
from
	actor as a
union
select
	concat_ws(" ",
	first_name,
	last_name) as name
from
	customer as c
union
select
	concat_ws(" ",
	first_name,
	last_name) as name
from
	staff as s;


/*
	3. Виведіть кількість міст для кожної країни
*/


select
	c2.country,
	count(*) as city_count
from
	city as c
join country as c2 on
	c.country_id = c2.country_id
group by
	c.country_id;


/*
	4. Виведіть кількість фільмів знятих в кожній категорії.
*/


select
	c.name,
	count(*) as film_count
from
	film as f
join film_category as fc on
	fc.film_id = f.film_id
join category as c on
	c.category_id = fc.category_id
group by
	fc.category_id;

/*
	5. Виведіть кількість акторів що знімалися в кожному фільмі
*/

select
	f.title ,
	count(*) as actor_count
from
	actor as a
join film_actor as fa on
	fa.actor_id = a.actor_id
join film as f on
	fa.film_id = f.film_id
group by
	fa.film_id;


/*
	6. Виведіть кількість акторів що знімалися в кожній категорії фільмів
*/

select
	c.name,
	count(*) as actor_count
from
	actor as a
join film_actor as fa on
	fa.actor_id = a.actor_id
join film_category as fc on
	fa.film_id = fc.film_id
join category as c on
	c.category_id = fc.category_id
group by
	fc.category_id;


/*
	7. Виведіть district та кількість адрес для кожного district, за умови, що district
	   починається на “Central”.
*/

select
	a.district, 
	count(*) as address_count
from
	address as a
where
	a.district like "Central%"
group by
	a.district;


/*
	8. За допомогою одного запиту вивести кількість фільмів в базі даних,
	   мінімальну, середню та максимальну вартість здачі в прокат (rental_rate),
	   середню replacement_cost, мінімальну, середню та максимальну тривалість
	   фільмів
*/

select
	count(film_id) as count,
	min(rental_rate) as min_renatl_rate,
	avg(rental_rate) as avg_renatl_rate,
	max(rental_rate) as max_renatl_rate,
	avg(replacement_cost) as avg_replacement_cost,
	min(`length`) as min_length,
	avg(`length`) as avg_length,
	max(`length`) as max_length
from
	film as f;


/*
	9. Виведіть кількість активних та неактивних клієнтів.(формат: active, кількість
	   клієнтів).
*/

select
	active,
	count(*) as count
from
	customer as c
group by
	c.active;


/*
	0. Виведіть ім’я та прізвище клієнта, дату його першого та останнього платежу
	   та загальну кількість грошей які він заплатив. (таблиці payment, customer)
*/

select
	c.first_name,
	c.last_name,
	min(p.payment_date) as first_payment,
	max(p.payment_date) as last_payment,
	sum(p.amount) as total_amount
from
	customer as c
join payment as p on
	p.customer_id = c.customer_id
group by
	c.customer_id





































