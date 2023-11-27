USE sakila;

#1. Вивести всі фільми, видані в прокат менеджером Mike Hillyer. Для
#визначення менеджера використати таблицю staff і поле staff_id; для
#визначення фільму скористатися таблицею inventory (поле inventory_id), і
#таблиці film (поле film_id). (Це завдання ви виконували в другому ДЗ, цього
#разу для виконання завдання потрібно використати common table
#expression)

with staff_cte as (
	select * from staff
    where first_name = 'Mike' and last_name = 'Hillyer'
), rental_cte as (
	select * from rental
    where staff_id in (select staff_id from staff_cte)
), inventory_cte as (
	select * from inventory
    where inventory_id in (select inventory_id from rental_cte)
)
select * from film
where film_id in (select film_id from inventory_cte);

#2. Вивести користувачів, що брали в оренду фільми SWEETHEARTS
#SUSPECTS, TEEN APOLLO, TIMBERLAND SKY, TORQUE BOUND. (Це
#завдання ви виконували в другому ДЗ, цього разу для виконання завдання
#потрібно використати common table expression)

with film_cte as (
	select * from film
	where title in ('SWEETHEARTS SUSPECTS', 'TEEN APOLLO', 'TIMBERLAND SKY', 'TORQUE BOUND')
), inventory_cte as (
	select * from inventory
    where film_id in (select film_id from film_cte)
), rental_cte as (
	select * from rental
	where inventory_id in (select inventory_id from inventory_cte)
)
select * from customer
where customer_id in (select customer_id from rental_cte);

#3. Вивести список фільмів, неповернених в прокат, replacement_cost яких
#більший 10 доларів.

with rental_cte as (
	select * from rental
	where return_date is null
), inventory_cte as (
	select * from inventory
    where inventory_id in (select inventory_id from rental_cte)
)
select * from film where film_id in (select film_id from inventory_cte) and replacement_cost > 10;

#4. Виведіть назву фільму та загальну кількість грошей отриманих від здачі
#цього фільму в прокат (таблиці payment, rental, inventory, film)

select f.title, sum(p.amount) 
from film f
    join inventory i on f.film_id = i.film_id
    join rental r on i.inventory_id = r. inventory_id
    join payment p on r.rental_id = p.payment_id
group by f.title;

#5. Виведіть кількість rental, які були повернуті і кількість тих, які не були
#повернуті в прокат.

select
	case 
		when return_date is null then "using"
        when return_date is not null then "returned"
	else "Unknown status"
	end as status, 
	count(*)
from rental r
group by status;

#6. Напишіть запит, що повертає поля “customer”, “total_amount”. За основу
#взяти таблицю sakila.payment. Total_amount - це сума грошей, які заплатив
#кожен користувач за фільми, що брав у прокат. Результат має відображати
#лише тих користувачів, що заплатили більше ніж 190 доларів. Customer - це
#конкатенація першої літери імені та прізвища користувача. Наприклад Alan
#Lipton має бути представлений як A. Lipton.

select 
	concat(substring(c.first_name, 1, 1), '. ', c.last_name) customer,
	sum(p.amount) total_amount
from payment p
	join customer c on c.customer_id = p.customer_id
group by customer
having sum(p.amount) > 190;

#7. Виведіть інформацію про фільми, тривалість яких найменша (в даному
#випадку потрібно використати підзапит з агрегаційною функцією). Вивести
#потрібно назву фільму, категорію до якої він відноситься, прізвища та імена
#акторів які знімалися в фільмі.

select f.title film, c.name category, group_concat(concat(a.first_name, ' ', a.last_name)) actors
from category c
	join film_category fc on c.category_id = fc.category_id
    join film f on fc.film_id = f.film_id
    join film_actor fa on f.film_id = fa.film_id
    join actor a on fa.actor_id = a.actor_id
where f.length = (select min(length) from film)
group by f.title, c.name;

#8. Категоризуйте фільми за ознакою rental_rate наступним чином: якщо
#rental_rate нижчий за 2 - це фільм категорії low_rental_rate, якщо rental_rate
#від 2 до 4 - це фільм категорії medium_rental_rate, якщо rental_rate більший
#за 4 - це фільм категорії high_rental_rate. Відобразіть кількість фільмів що
#належать до кожної з категорій.

select
	case 
		when rental_rate < 2 then "low_rental_rate"
        when rental_rate >= 2 and rental_rate <= 4 then "medium_rental_rate"
        when rental_rate > 4 then "high_rental_rate"
	else "Unknown status"
	end as rental_category, 
	count(*) films_number
from film f
group by rental_category;