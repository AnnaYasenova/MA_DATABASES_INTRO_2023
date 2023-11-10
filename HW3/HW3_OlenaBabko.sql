#1 Вивести прізвища та імена всіх клієнтів (customer), які не повернули
#фільми в прокат.

#1 subquery
#1 join
 SELECT first_name, last_name
FROM customer
WHERE customer_id in (
	SELECT customer_id FROM rental
    WHERE return_date is null
);

#1 join
SELECT DISTINCT first_name, last_name
FROM customer c
JOIN rental AS r
	ON r.customer_id = c.customer_id
    WHERE return_date is null;



#2. Виведіть список всіх людей наявних в базі даних (таблиці actor, customer,
#staff). Для виконання використайте оператор union. Вивести потрібно
#конкатенацію полів прізвище та ім’я.

#2 union, concat
SELECT CONCAT(first_name, ' ', last_name) AS names FROM actor
UNION
SELECT CONCAT(first_name, ' ', last_name) AS names FROM customer
UNION
SELECT CONCAT(first_name, ' ', last_name) AS names FROM staff;



#3. Виведіть кількість міст для кожної країни.
SELECT
	c.country AS country,
    COUNT(city_id) AS cities_in_this_country
FROM country AS c
JOIN city
	ON city.country_id = c.country_id
GROUP BY c.country_id;



#4. Виведіть кількість фільмів знятих в кожній категорії.
SELECT
	c.name AS category,
    COUNT(film_id) AS films_in_category
FROM category AS c
JOIN film_category AS fc
	ON c.category_id = fc.category_id
GROUP BY fc.category_id;



#5. Виведіть кількість акторів що знімалися в кожному фільмі.
SELECT
	title,
    COUNT(actor_id) AS actors_in_film
FROM film AS f
JOIN film_actor AS fa
	ON f.film_id = fa.film_id
GROUP BY f.film_id;



#6. Виведіть кількість акторів що знімалися в кожній категорії фільмів.
SELECT
	c.name AS category_name,
    COUNT(actor_id) AS actors_in_category
FROM category AS c
JOIN film_category AS fc
	ON c.category_id = fc.category_id
JOIN film_actor AS fa
	ON fc.film_id = fa.film_id
GROUP BY c.category_id;



#7. Виведіть district та кількість адрес для кожного district, за умови, що district
#починається на “Central”.
SELECT
	district,
    COUNT(address_id) AS address_amount
FROM address
WHERE district LIKE "Central%"
GROUP BY district;



#8. За допомогою одного запиту вивести кількість фільмів в базі даних,
#мінімальну, середню та максимальну вартість здачі в прокат (rental_rate),
#середню replacement_cost, мінімальну, середню та максимальну тривалість
#фільмів.

SELECT
	COUNT(film_id) AS amount_of_films,
    MIN(rental_rate) AS min_rental_rate,
    MAX(rental_rate) AS max_rental_rate,
    AVG(rental_rate) AS average_rental_rate,
    AVG(replacement_cost) AS average_replacement_cost,
    MIN(length) AS min_length,
    MAX(length) AS max_length,
    AVG(length) AS average_length
FROM film;



#9. Виведіть кількість активних та неактивних клієнтів.(формат: active, кількість
#клієнтів).
SELECT
	active,
	COUNT(customer_id) as amount_of_customers
FROM customer
GROUP BY active;
 


#10.Виведіть ім’я та прізвище клієнта, дату його першого та останнього платежу
#та загальну кількість грошей які він заплатив. (таблиці payment, customer)

SELECT DISTINCT
	CONCAT(c.first_name, ' ', c.last_name) as client,
	MIN(p.payment_date) AS first_payment_date,
    MAX(p.payment_date) AS last_payment_date,
	SUM(p.amount) AS total_payment
FROM customer AS c
JOIN payment AS p
	ON c.customer_id = p.customer_id
GROUP BY c.customer_id;