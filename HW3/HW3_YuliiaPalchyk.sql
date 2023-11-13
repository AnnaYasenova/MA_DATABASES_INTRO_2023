#Вивести прізвища та імена всіх клієнтів (customer), які не повернули фільми
#в прокат.

SELECT customer.first_name, customer.last_name
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
WHERE rental.return_date IS NULL

#Виведіть список всіх людей наявних в базі даних (таблиці actor, customer,
#staff). Для виконання використайте оператор union. Вивести потрібно
#конкатенацію полів прізвище та ім’я.

SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM actor
UNION
SELECT CONCAT(first_name, ' ', last_name) FROM customer
UNION
SELECT CONCAT(first_name, ' ', last_name) FROM staff;

#Виведіть кількість міст для кожної країни.
SELECT country.country, COUNT(city.city_id) AS city_count
FROM country
LEFT JOIN city ON country.country_id = city.country_id
GROUP BY country.country;

#Виведіть кількість фільмів знятих в кожній категорії.
SELECT category.name AS category_name, COUNT(film_category.category_id) AS category_count
FROM film_category
LEFT JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name;

#Виведіть кількість акторів що знімалися в кожному фільмі.
SELECT film.film_id, film.title, COUNT(film_actor.actor_id) AS actor_count
FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film.film_id, film.title;

#Виведіть кількість акторів що знімалися в кожній категорії фільмів.
SELECT fc.category_id, c.name AS category_name, COUNT(DISTINCT fa.actor_id) AS actor_count
FROM film_category fc
JOIN film_actor fa ON fc.film_id = fa.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY fc.category_id, c.name;

#Виведіть district та кількість адрес для кожного district, за умови, що district
#починається на “Central”.
SELECT district, COUNT(address_id) AS address_count
FROM address
WHERE district LIKE 'Central%'
GROUP BY district;

#За допомогою одного запиту вивести кількість фільмів в базі даних,
#мінімальну, середню та максимальну вартість здачі в прокат (rental_rate),
#середню replacement_cost, мінімальну, середню та максимальну тривалість
#фільмів.
SELECT
    COUNT(film_id) AS film_count,
    MIN(rental_rate) AS min_rental_rate,
    AVG(rental_rate) AS avg_rental_rate,
    MAX(rental_rate) AS max_rental_rate,
    AVG(replacement_cost) AS avg_replacement_cost,
    MIN(length) AS min_length,
    AVG(length) AS avg_length,
    MAX(length) AS max_length
FROM film;

#Виведіть кількість активних та неактивних клієнтів.(формат: active, кількість
#клієнтів).

SELECT
    CASE WHEN active = 1 THEN 'active' ELSE 'inactive' END AS client_status,
    COUNT(customer_id) AS client_count
FROM customer
GROUP BY active;

#Виведіть ім’я та прізвище клієнта, дату його першого та останнього платежу
#та загальну кількість грошей які він заплатив. (таблиці payment, customer)
SELECT
    customer.first_name,
    customer.last_name,
    MIN(payment.payment_date) AS first_payment_date,
    MAX(payment.payment_date) AS last_payment_date,
    SUM(payment.amount) AS total_amount_paid
FROM
    customer
JOIN
    payment ON customer.customer_id = payment.customer_id
GROUP BY
    customer.customer_id;