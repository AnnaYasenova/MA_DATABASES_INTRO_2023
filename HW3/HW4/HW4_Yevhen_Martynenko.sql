/*
	1. Вивести всі фільми, видані в прокат менеджером Mike Hillyer. Для
	   визначення менеджера використати таблицю staff і поле staff_id; для
	   визначення фільму скористатися таблицею inventory (поле inventory_id), і
	   таблиці film (поле film_id).
 */


with staff_cte as (
select
		*
from
	staff as s
where
	s.first_name = "Mike"
	and s.last_name = "Hillyer"),
rental_cte as (
select
	*
from
	rental as r
where
	r.staff_id = (
	select
		staff_id
	from
		staff_cte)),
inventory_cte as (
select
	*
from
	inventory as i
where
	i.inventory_id in (
	select
		inventory_id
	from
		rental_cte)),
film_cte as (
select
	*
from
	film as f
where
	f.film_id in (
	select
		film_id
	from
		inventory_cte))
select
		*
from
		film_cte;

/*
	2. Вивести користувачів, що брали в оренду фільми SWEETHEARTS
	   SUSPECTS, TEEN APOLLO, TIMBERLAND SKY, TORQUE BOUND
*/

with film_cte as (
select
	*
from
	film as f
where
	f.title in ("SWEETHEARTS SUSPECTS", "TEEN APOLLO", "TIMBERLAND SKY", "TORQUE BOUND")),
inventory_cte as (
select
	*
from
	inventory as i
where
	i.film_id in (
	select
		film_id
	from
		film_cte)),
rental_cte as (
select
	*
from
	rental as r
where
	r.inventory_id in (
	select
		inventory_id
	from
		inventory_cte)),
customer_cte as (
select
	*
from
	customer as c
where
	c.customer_id in (
	select
		customer_id
	from
		rental_cte))
select
	*
from
	customer_cte;

/*
	3. Вивести список фільмів, неповернених в прокат, replacement_cost яких
	   більший 10 доларів
*/

select
	distinct
	f.*
from
	film as f
join inventory as i on
	i.film_id = f.film_id
join rental as r on
	r.inventory_id = i.inventory_id
where
	f.replacement_cost > 10
	and r.return_date is null;

select
	f.*
from
	film as f
join inventory as i on
	i.film_id = f.film_id
join rental as r on
	r.inventory_id = i.inventory_id
where
	f.replacement_cost > 10
	and r.return_date is null
group by
	f.film_id;

/*
	4. Виведіть назву фільму та загальну кількість грошей отриманих від здачі
	   цього фільму в прокат (таблиці payment, rental, inventory, film)
*/

select
	f.title,
	sum(p.amount) as total
from
	film as f
join inventory as i on
	i.film_id = f.film_id
join rental as r on
	r.inventory_id = i.inventory_id
join payment as p on
	p.rental_id = r.rental_id
group by
	f.film_id;

/*
	5. Виведіть кількість rental, які були повернуті і кількість тих, які не були
	   повернуті в прокат.
*/

select
	case
		when r.return_date is null then "Not returned"
		when r.return_date is not null then "Returned"
	end as status,
	count(*) as items_count
from
	rental as r
group by
	status;

/*
	6. Напишіть запит, що повертає поля “customer”, “total_amount”. За основу
	   взяти таблицю sakila.payment. Total_amount - це сума грошей, які заплатив
	   кожен користувач за фільми, що брав у прокат. Результат має відображати
	   лише тих користувачів, що заплатили більше ніж 190 доларів. Customer - це
	   конкатенація першої літери імені та прізвища користувача. Наприклад Alan
	   Lipton має бути представлений як A. Lipton
*/

with customer_cte as (
select
	concat_ws(" ", c.first_name, c.last_name) as cutomer,
	sum(p.amount) as total_amount
from
		customer as c
join payment as p on
		p.customer_id = c.customer_id
group by
		c.customer_id)
select
	*
from
	customer_cte
where
	total_amount > 190;

/*
	7. Виведіть інформацію про фільми, тривалість яких найменша (в даному
	   випадку потрібно використати підзапит з агрегаційною функцією). Вивести
	   потрібно назву фільму, категорію до якої він відноситься, прізвища та імена
	   акторів які знімалися в фільмі
*/


select
	*
from
	film as f
where
	f.`length` = (
	select
		min(f2.`length`)
	from
		film as f2)

/*
	8. Категоризуйте фільми за ознакою rental_rate наступним чином: якщо
	   rental_rate нижчий за 2 - це фільм категорії low_rental_rate, якщо rental_rate
	   від 2 до 4 - це фільм категорії medium_rental_rate, якщо rental_rate більший
	   за 4 - це фільм категорії high_rental_rate. Відобразіть кількість фільмів що
	   належать до кожної з категорій. 
*/
		
select
	case
		when f.rental_rate < 2 then "low rental rate"
		when f.rental_rate between 2 and 4 then "medium rental rate"
		else "hight rental rate"
	end as category,
	f.*
from
		film as f;
