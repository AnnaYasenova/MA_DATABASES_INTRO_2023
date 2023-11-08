/*
	1. Вивести адресу і місто до якого відноситься ця адреса. (таблиці address,
 	   city)
 */

select
	address,
	(
	select
		c.city
	from
		city as c
	where
		a.city_id = c.city_id ) as city
from
	address as a;


select
	address,
	city
from
	address as a
join city as c on
	c.city_id = a.city_id;
	
/*
	2. Вивести список міст Аргентини і Австрії. (таблиці city, country). Відсортувати
	   за алфавітом
*/

select
	c.city
from
	city as c
where
	c.country_id in (
	select
		c2.country_id
	from
		country as c2
	where
		c2.country in ("Argentina", "Austria"))
order by
	c.city;


select
	c.city
from
	city as c
join country as c2 on
	c.country_id = c2.country_id
where
	c2.country in ("Argentina", "Austria")
order by
	c.city;

/*
	3. Вивести список акторів, що знімалися в фільмах категорій Music, Sports.
	   (використати таблиці actor, film_actor, film_category, category)
*/

select
	a.actor_id,
	a.first_name,
	a.last_name
from
	actor as a
where
	a.actor_id in (
	select
		fa.actor_id
	from
		film_actor as fa
	where
		fa.film_id in (
		select
			fc.film_id
		from
			film_category as fc
		where
			fc.category_id in (
			select
				c.category_id
			from
				category as c
			where
				c.name in("Music", "Sports"))))
				


				
select
	distinct
	a.actor_id,
	a.first_name,
	a.last_name
from
	actor as a
join film_actor as fa on
	fa.actor_id = a.actor_id
join film_category as fc on
	fa.film_id = fc.film_id
join category as c on
	c.category_id = fc.category_id
where
	c.name in ("Music", "Sports");

/*
	4. Вивести всі фільми, видані в прокат менеджером Mike Hillyer. Для
	   визначення менеджера використати таблицю staff і поле staff_id; для
	   визначення фільму скористатися таблицею inventory (поле inventory_id), і
	   таблиці film (поле film_id) 
*/

select
	f.film_id,
	f.title
from
	film as f
where
	f.film_id in (
	select
		i.film_id
	from
		inventory as i
	where
		i.inventory_id in (
		select
			r.inventory_id
		from
			rental as r
		where
			r.staff_id in (
			select
				s.staff_id
			from
				staff as s
			where
				concat(s.first_name , " ", s.last_name) like "Mike Hillyer") ))
	ORDER by
	f.title 
				
				

select
	distinct
	f.film_id ,
	f.title
from
	film as f
join inventory as i on
	i.film_id = f.film_id
join rental as r on
	r.inventory_id = i.inventory_id
join staff as s
on
	s.staff_id = r.staff_id
where
	concat(s.first_name, " ", s.last_name) like "Mike Hillyer"

/*
	5. Вивести користувачів, що брали в оренду фільми SWEETHEARTS
	   SUSPECTS, TEEN APOLLO, TIMBERLAND SKY, TORQUE BOUND
*/

select
	c.first_name,
	c.last_name
from
	customer as c
where
	c.customer_id in (
	select
		r.customer_id
	from
		rental as r
	where
		r.inventory_id in(
		select
			i.inventory_id
		from
			inventory as i
		where
			i.film_id in (
			select
				f.film_id
			from
				film as f
			where
				f.title in("SWEETHEARTS SUSPECTS", "TEEN APOLLO", "TIMBERLAND SKY", "TORQUE BOUND"))));
	

select
	distinct
	c.first_name,
	c.last_name
from
	customer as c
join rental as r on
	r.customer_id = c.customer_id
join inventory as i on
	i.inventory_id = r.inventory_id
join film as f on
	f.film_id = i.film_id
where
	f.title in("SWEETHEARTS SUSPECTS", "TEEN APOLLO", "TIMBERLAND SKY", "TORQUE BOUND")
order by
	c.last_name;

/*
	6. Вивести назву фільму, тривалість фільму і мову фільму. Фільтр: мова
	   Англійська або італійська. (таблиці film, language)
 */

select
	f.title ,
	f.`length`,
	(
	select
		l.name
	from
		`language` as l
	where
		l.language_id = f.language_id) as "language"
from
	film as f
where
	f.language_id in (
	select
		l.language_id
	from
		`language` as l
	where
		l.name in ("English", "Italian"));
	
select
	f.title,
	f.`length`,
	l.name
from
	film as f
join `language` as l on
	l.language_id = f.language_id
where
	l.name in ("English", "Italian")

/*
	7. Вивести payment_date i amount всіх записів активних клієнтів (поле active
	   таблиці customer)
 */

select
	p.payment_date,
	p.amount
from
	payment as p
where
	p.customer_id in (
	select
		c.customer_id
	from
		customer as c
	where
		c.active = 1);

select
	p.payment_date,
	p.amount
from
	payment as p
join customer as c on
	c.customer_id = p.customer_id
where
	c.active = 1;


/*
	8. Вивести прізвище та ім’я клієнтів, payment_date i amount для активних
	   клієнтів (поле active таблиці customer)
 */

select
	*
from
	(
	select
		p.payment_date,
		p.amount,
		(
		select
			concat(c.first_name, " ", c.last_name)
		from
			customer as c
		where
			c.customer_id = p.customer_id
			and c.active = 1) as customer
	from
		payment as p) as p
where
	customer is not null


select
	p.payment_date,
	p.amount,
	concat(c.first_name, " ", c.last_name) as customer
from
	payment as p
join customer as c on
	p.customer_id = p.customer_id
where
	c.active = 1;

/*
	9. Вивести прізвище та ім'я користувачів (customer), які здійснювали оплату в
	   розмірі більшому, ніж 10 доларів (таблиця payment, поле amount), також
	   вивести amount, дату оплати. Відсортувати за датою оплати
 */

select
	p.amount,
	p.payment_date,
	(
	select
		concat(c.first_name, "  ", c.last_name)
	from
		customer as c
	where
		c.customer_id = p.customer_id) as customer
from
	payment as p
where
	p.amount > 10
order by
	p.payment_date;


select
	p.payment_date,
	p.amount,
	concat(c.first_name, " ", c.last_name) as customer
from
	payment as p
join customer as c
where
	p.amount > 10
order by
	p.payment_date;

/*
	10. Вивести прізвище та ім’я, а також дату останнього оновлення запису (поле
		last_update) для людей наявних в таблицях actor, customer. Також в
		результуючому запиті передбачити можливість розрізняти акторів і
		користувачів
 */

select
	c.first_name,
	c.last_name ,
	c.last_update,
	'customer' as type
from
	customer as c
union all
select
	s.first_name,
	s.last_name ,
	s.last_update,
	'staff' as type
from
	staff as s
	
	
/*
	11. Вивести всі унікальні прізвища таблиць actor, customer, staff
 */
	
select
	a.first_name,
	a.last_name
from
	actor as a
union
	select
	c.first_name,
	c.last_name
from
	customer as c
union
	select
	s.first_name,
	s.last_name
from
	staff as s;
	
	
