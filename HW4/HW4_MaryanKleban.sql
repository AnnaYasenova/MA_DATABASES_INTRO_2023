/*1. Вивести всі фільми, видані в прокат менеджером Mike Hillyer. Для
визначення менеджера використати таблицю staff і поле staff_id; для
визначення фільму скористатися таблицею inventory (поле inventory_id), і
таблиці film (поле film_id). (Це завдання ви виконували в другому ДЗ, цього
разу для виконання завдання потрібно використати common table
expression)*/
with s_cte as (
    select staff_id from staff
    where first_name = "Mike" and last_name = "Hillyer"
), s_rental_cte as (
    select inventory_id from rental
    where staff_id = (
        select staff_id from s_cte
    )
), s_inventory_cte as (
    select film_id from inventory
    where inventory_id in (
        select inventory_id from s_rental_cte
    )
)
select distinct title from film
where film_id in (
    select film_id from s_inventory_cte
);


/*2. Вивести користувачів, що брали в оренду фільми SWEETHEARTS
SUSPECTS, TEEN APOLLO, TIMBERLAND SKY, TORQUE BOUND. (Це
завдання ви виконували в другому ДЗ, цього разу для виконання завдання
потрібно використати common table expression)
*/
with f_cte as (
	select film_id from film
    where title in ("SWEETHEARTS", "SUSPECTS", "TEEN APOLLO", "TIMBERLAND SKY", "TORQUE BOUND")
),
	i_cte as (
    select inventory_id from inventory
    where film_id in (select film_id from f_cte)
),
	customer_cte as (
	select customer_id from rental
    where inventory_id in (select inventory_id from i_cte)
)
select first_name, last_name from customer
where customer_id in (select customer_id from customer_cte);


/*3. Вивести список фільмів, неповернених в прокат, replacement_cost яких
більший 10 доларів.*/
with not_returned_inventory_cte as (
    select inventory_id from rental
    where return_date is null
), not_returned_films_cte as (
    select distinct film_id from inventory
    where inventory_id in (
        select inventory_id from not_returned_inventory_cte
    )
)
select title from film
where film_id in (
    select film_id from not_returned_films_cte
) and replacement_cost > 10;


/*4. Виведіть назву фільму та загальну кількість грошей отриманих від здачі
цього фільму в прокат (таблиці payment, rental, inventory, film)*/
select f.title, sum(p.amount) as "Total"
from film as f
join inventory as inv
    on inv.film_id = f.film_id
join rental as r
    on r.inventory_id = inv.inventory_id
join payment as p
    on p.rental_id = r.rental_id
group by f.film_id;


/*5. Виведіть кількість rental, які були повернуті і кількість тих, які не були
повернуті в прокат*/
select
	count(case when return_date is not null then 1 end) as "Returned",
	count(case when return_date is not null then 1 end) as "Not Returned"
from rental;

/*V2*/
with r_rental_cte as (
    select count(*) as "Returned"
    from rental
    where return_date is not null 
), not_r_rental_cte as (
    select
        count(*) as "Not Returned"
    from rental
    where return_date is null
)
select * from r_rental_cte
join not_r_rental_cte;


/*6. Напишіть запит, що повертає поля “customer”, “total_amount”. За основу
взяти таблицю sakila.payment. Total_amount - це сума грошей, які заплатив
кожен користувач за фільми, що брав у прокат. Результат має відображати
лише тих користувачів, що заплатили більше ніж 190 доларів. Customer - це
конкатенація першої літери імені та прізвища користувача. Наприклад Alan
Lipton має бути представлений як A. Lipton*/
select
    concat(substr(c.first_name, 1, 1), '. ', c.last_name) as customer,
    sum(amount) as total_amount
from payment as p
join customer as c
    on c.customer_id = p.customer_id
group by c.customer_id
having total_amount >= 190;


/*7. Виведіть інформацію про фільми, тривалість яких найменша (в даному
випадку потрібно використати підзапит з агрегаційною функцією). Вивести
потрібно назву фільму, категорію до якої він відноситься, прізвища та імена
акторів які знімалися в фільмі.*/
select
    f.title as "Films",
    c.name as "Categories",
    group_concat(
        concat(a.first_name, ' ',  a.last_name) separator ', ') as "Actors"
from film as f
join film_category as fc
    on f.film_id = fc.film_id
join category as c
    on c.category_id = fc.category_id
join film_actor as fa
    on fa.film_id = f.film_id
join actor as a
    on a.actor_id = fa.actor_id
where f.length = (select min(length) from film)
group by f.film_id, c.name;


/*8. Категоризуйте фільми за ознакою rental_rate наступним чином: якщо
rental_rate нижчий за 2 - це фільм категорії low_rental_rate, якщо rental_rate
від 2 до 4 - це фільм категорії medium_rental_rate, якщо rental_rate більший
за 4 - це фільм категорії high_rental_rate. Відобразіть кількість фільмів що належать до кожної з категорій*/
select
    count(case when rental_rate < 2 then 1 end) as 'Low Rental',
    count(case when rental_rate >= 2 and rental_rate < 4 then 1 end) as 'Medium Rental',
    count(case when rental_rate > 4 then 1 end) as 'High Rental'
from film;