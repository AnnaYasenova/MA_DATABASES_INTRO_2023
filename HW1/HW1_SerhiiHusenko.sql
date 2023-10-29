use sakila;

/* 1. Виведіть вміст таблиці customer. */
select * from customer;

/* 2. З таблиці customer виведіть лише ім’я, прізвище та електронну пошту. 
В результуючій таблиці колонки мають називатися “First Name”, “Last Name”, “Email”. */
select 
	first_name as "First Name", 
    last_name as "Last Name", 
    email as "Email" 
from customer;

/* 3. З таблиці address виведіть колонки address, district, postal_code. 
Назви в результуючому запиті: “Address”, “District”, “Postal Code”. 
Відсортуйте результат за колонкою district (за зростанням) та address (за спаданням).
 */
select 
	address as "Address", 
    district as "District", 
    postal_code as "Postal Code"
from address 
order by district ASC, address DESC;

/* 4. З таблиці фільмів виведіть назву фільму і ціну прокату таких фільмів, ціна прокату яких більша ніж 3 долари. */
select
	 title as "Title", 
     rental_rate as "Rental Rate"
from film
where rental_rate > 3;

/* 5. З таблиці фільмів виведіть інформацію про фільми з рейтингом “G”, “PG”, “R”. 
Колонки які потрібно вивести: назва, опис і рейтинг. */
select 
	title as "Title",
    description as "Description",
    rating as "Rating"
from film
where rating in ("G", "PG", "R");

/* 6. Виведіть всі записи з таблиці film_text в описі яких є слово database. */
select *
from film_text
where description like "%database%";

/* 7. Виведіть всю інформацію про фільми, в яких тривалість прокату рівна 3, а replacement_cost менша ніж 12 доларів. */
select *
from film
where 
	rental_duration = 3 
    and replacement_cost < 12;

/* 8. Виведіть всю інформацію про фільми з рейтингом “G” і replacement_cost більшою ніж 15 доларів. */
select *
from film
where 
	rating = "G" 
    and replacement_cost > 15;

/* 9. Виведіть всю інформацію про фільми з тривалістю від 60 до 90 хвилин включно. */
select *
from film
where 
	length between 60 and 90;

/* 10.Виведіть всю інформацію про фільми з тривалістю меншою за 60 хвилин або більшою за 90 хвилин. */
select *
from film
where 
	length < 60 
    or length > 90;

/* 11. Виведіть назви всіх фільмів в яких rental duration рівна 6 або 7, rental rate не менша 4, 
а також в special features наявні Trailers або Commentaries. */
select 
	title as "Title"
from film
where 
	rental_duration in (6, 7)
    and rental_rate >= 4
    and (special_features like "%Trailers%" or special_features like "%Commentaries%");

/* 12.Виведіть всі фільми які або мають рейтинг G і тривалість більшу ніж 60 хвилин, 
або мають рейтинг R і містять Commentaries в special features. */
select *
from film
where
	(rating = "G" and length > 60)
    or (rating = "R" and special_features like "%Commentaries%");
