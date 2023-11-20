/*1. Вивести прізвища та імена всіх клієнтів (customer), які не повернули фільми
в прокат.*/
select first_name, last_name 
	from customer c
join rental r
	on c.customer_id = r.customer_id 
    and return_date is null;


/*2. Виведіть список всіх людей наявних в базі даних (таблиці actor, customer, 
staff). Для виконання використайте оператор union. Вивести потрібно
конкатенацію полів прізвище та ім’я.*/
select concat (first_name, ' ', last_name) as humans from actor
union 
select concat (first_name, ' ', last_name) as humans from customer
union
select concat (first_name, ' ', last_name) as humans from staff;


/*3. Виведіть кількість міст для кожної країни.*/
select country, count(c.city_id) as cities_number
	from country co
join city c
	on co.country_id=c.country_id
group by co.country;


/*4. Виведіть кількість фільмів знятих в кожній категорії.*/
select c.name as category_name, 
	count(f.film_id) as film_number
	from category c
join film_category fc
	on c.category_id=fc.category_id
join film f 
	on fc.film_id=f.film_id
group by c.name;


/*5. Виведіть кількість акторів що знімалися в кожному фільмі*/
select f.title as film_title,
    count(a.actor_id) as actors_number
from film f
join film_actor fa 
	on fa.film_id = f.film_id
join actor a
	on fa.actor_id = a.actor_id
group by f.title;


/*6. Виведіть кількість акторів що знімалися в кожній категорії фільмів.*/
select c.name as category_name, 
	count(a.actor_id) as actors_number
from category c
join film_category fc 
	on c.category_id = fc.category_id
join film f 
	on fc.film_id = f.film_id
join film_actor fa
	on fa.film_id = f.film_id
join actor a 
	on fa.actor_id = a.actor_id
group by c.name;


/*7. Виведіть district та кількість адрес для кожного district, за умови, що district
починається на “Central”*/
select district,
	count(address_id) as address_count
from address
where district like 'Central%'
group by district;


/*8. За допомогою одного запиту вивести кількість фільмів в базі даних,
мінімальну, середню та максимальну вартість здачі в прокат (rental_rate),
середню replacement_cost, мінімальну, середню та максимальну тривалість
фільмів.*/
select 
	count(f.film_id) as all_films,
	min(f.rental_rate) as min_rental_rate,
	avg(f.rental_rate) as avg_rental_rate,
	max(f.rental_rate) as max_rental_rate,
	avg(replacement_cost) as avg_replacement_cost,
	min(f.length) as min_length,
	avg(f.length) as avg_length,
	max(f.length) as max_length
from film f;


/*9. Виведіть кількість активних та неактивних клієнтів.(формат: active, кількість
клієнтів)*/
select
    case
		when active = 1 then 'active' 
        else 'inactive' 
        end as statuses,
    count(customer_id) as client_count
from customer
group by active;


/*10.Виведіть ім’я та прізвище клієнта, дату його першого та останнього платежу
та загальну кількість грошей які він заплатив. (таблиці payment, customer)*/
select customer.first_name, customer.last_name,
    min(payment.payment_date) as first_payment,
    max(payment.payment_date) as last_payment,
    sum(payment.amount) as total_paid
from customer
join payment
	on customer.customer_id = payment.customer_id
group by customer.customer_id;