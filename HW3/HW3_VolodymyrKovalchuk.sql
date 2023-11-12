USE sakila;

#1 Вивести прізвища та імена всіх клієнтів (customer), які не повернули
#фільми в прокат.

SELECT DISTINCT c.last_name, c.first_name 
FROM customer c
JOIN rental r ON c.customer_id=r.customer_id and return_date is null;

#2. Виведіть список всіх людей наявних в базі даних (таблиці actor, customer,
#staff). Для виконання використайте оператор union. Вивести потрібно
#конкатенацію полів прізвище та ім’я.

SELECT concat(a.last_name, ' ', a. first_name) AS person
FROM actor a
UNION
SELECT concat(c.last_name, ' ', c. first_name) AS person
FROM customer c
UNION
SELECT concat(s.last_name, ' ', s. first_name) AS person
FROM staff s;

#3. Виведіть кількість міст для кожної країни.

SELECT co.country, count(ci.city_id) as cities_number
FROM country co
JOIN city ci ON co.country_id=ci.country_id
GROUP BY co.country;

#4. Виведіть кількість фільмів знятих в кожній категорії.

SELECT c.name AS category_name, count(f.film_id) as films_number
FROM category c
JOIN film_category fc ON c.category_id=fc.category_id
JOIN film f ON fc.film_id=f.film_id
GROUP BY c.name;

#5. Виведіть кількість акторів що знімалися в кожному фільмі.

SELECT f.title AS film_title, count(a.actor_id) as actors_number
FROM film f
JOIN film_actor fa ON fa.film_id=f.film_id
JOIN actor a ON fa.actor_id=a.actor_id
GROUP BY f.title;

#6. Виведіть кількість акторів що знімалися в кожній категорії фільмів.

SELECT c.name AS category_name, count(a.actor_id) as actors_number
FROM category c
JOIN film_category fc ON c.category_id=fc.category_id
JOIN film f ON fc.film_id=f.film_id
JOIN film_actor fa ON fa.film_id=f.film_id
JOIN actor a ON fa.actor_id=a.actor_id
GROUP BY c.name;

#7. Виведіть district та кількість адрес для кожного district, за умови, що district
#починається на “Central”.

SELECT district, count(address_id) as addresses_number
FROM address
WHERE district LIKE ('Central%')
GROUP BY district;

#8. За допомогою одного запиту вивести кількість фільмів в базі даних,
#мінімальну, середню та максимальну вартість здачі в прокат (rental_rate),
#середню replacement_cost, мінімальну, середню та максимальну тривалість
#фільмів.

SELECT 
	count(f.film_id) AS number_of_all_films,
	min(f.rental_rate) AS min_rental_rate,
	avg(f.rental_rate) AS avg_rental_rate,
	max(f.rental_rate) AS max_rental_rate,
	avg(replacement_cost) AS avg_replacement_cost,
	min(f.length) AS min_length,
	avg(f.length) AS avg_length,
	max(f.length) AS max_length
FROM film f;

#9. Виведіть кількість активних та неактивних клієнтів.(формат: active, кількість
#клієнтів).

SELECT 
    CASE
        WHEN c.active = 1 THEN 'active'
        WHEN c.active = 0 THEN 'inactive'
        ELSE 'unknown'
    END AS ativity,
    count(c.customer_id) AS customers_number
FROM customer c
GROUP BY c.active;

#10.Виведіть ім’я та прізвище клієнта, дату його першого та останнього платежу
#та загальну кількість грошей які він заплатив. (таблиці payment, customer)

SELECT
	c.first_name,
    c.last_name,
    min(p.payment_date) AS first_payment,
    max(p.payment_date) AS last_payment,
    sum(p.amount) AS total_amount_paid
FROM customer c
JOIN payment p ON c.customer_id=p.customer_id
GROUP BY c.customer_id;