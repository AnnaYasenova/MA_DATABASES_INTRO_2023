--Вивести прізвища та імена всіх клієнтів (customer), які не повернули фільми
в прокат.

select * from customer;
select * from rental;

select 
concat(first_name," ",last_name) as customer
from customer c
join rental r 
	on c.customer_id=r.customer_id 
where r.return_date is null;

--Виведіть список всіх людей наявних в базі даних (таблиці actor, customer,
staff). Для виконання використайте оператор union. Вивести потрібно
конкатенацію полів прізвище та ім’я.

select 
	concat(first_name," ",last_name) as people from actor
union all
select 
	concat(first_name," ",last_name) as people from customer
union all
select 
	concat(first_name," ",last_name) as people from staff;

--Виведіть кількість міст для кожної країни.

select 
	ct.country, 
	count(city) as city_num
from country as ct
join city as c 
	on ct.country_id=c.country_id
group by c.country_id    

--Виведіть кількість фільмів знятих в кожній категорії.

select 
    c.name as category_name,
    count(film_id) as films_amount
from film_category as fc
join category as c 
	on c.category_id=fc.category_id
group by fc.category_id;

--Виведіть кількість акторів що знімалися в кожному фільмі.

select f.title as film_name,
	  count(fa.actor_id) as actor_amount
from film_actor as fa
join film as f 
	on fa.film_id=f.film_id  
group by f.film_id;

--Виведіть кількість акторів що знімалися в кожній категорії фільмів.

select c.name as film_category,
	count(a.actor_id) as actor_amount 
from category as c 
join film_category as fc 
	on c.category_id=fc.category_id
join film_actor as fa
	on fc.film_id=fa.film_id 
join actor as a
	on fa.actor_id=a.actor_id    
group by c.name;    

--Виведіть district та кількість адрес для кожного district, за умови, що district
починається на “Central”.

select district,
	count(address) as addresses_num
from address
where district like 'Central%'
group by district;

--За допомогою одного запиту вивести кількість фільмів в базі даних,
мінімальну, середню та максимальну вартість здачі в прокат (rental_rate),
середню replacement_cost, мінімальну, середню та максимальну тривалість
фільмів.

select
count(*) as film_amount,
min(rental_rate) as min_rental_rate,
max(rental_rate) as max_rental_rate,
avg(rental_rate) as avarege_rental_rate,
avg(replacement_cost) as avarege_replacement_cost,
min(length) as min_length,
max(length) as max_length,
avg(length) as avarege_length
from film

--Виведіть кількість активних та неактивних клієнтів.(формат: active, кількість
клієнтів).

select 
if (active=1, "Active", "Inactive") as Type_of_Client,
count(customer_id) as Amount
from customer
group by active;

--Виведіть ім’я та прізвище клієнта, дату його першого та останнього платежу
та загальну кількість грошей які він заплатив. (таблиці payment, customer


select * from customer
select* from payment


select 
	concat(c.first_name, ' ', c.last_name) as Client,
    sum(p.amount) as Total_amount,
    min(p.payment_date) as First_payment_date,
    max(p.payment_date) as Last_payment_date
from customer c 
join payment p 
    on c.customer_id=p.customer_id
group by Client
ORDER BY  Total_amount DESC;