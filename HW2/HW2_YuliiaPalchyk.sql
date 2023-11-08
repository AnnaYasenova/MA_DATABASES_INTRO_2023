#Вивести адресу і місто до якого відноситься ця адреса. (таблиці address,
#city).
SELECT address.address, city.city
FROM address
JOIN city ON address.city_id = city.city_id;

SELECT a.address, (
  SELECT c.city
  FROM city c
  WHERE c.city_id = a.city_id
) AS city
FROM address a;

#Вивести список міст Аргентини і Австрії. (таблиці city, country). Відсортувати
#за алфавітом.
SELECT city.city
FROM city
JOIN country ON city.country_id = country.country_id
WHERE country.country IN ('Argentina', 'Austria')
ORDER BY city.city;

SELECT city
FROM city
WHERE country_id IN (SELECT country_id FROM country WHERE country IN ('Argentina', 'Austria'))
ORDER BY city;

#Вивести список акторів, що знімалися в фільмах категорій Music, Sports.
#(використати таблиці actor, film_actor, film_category, category).

SELECT DISTINCT actor.actor_id, actor.first_name, actor.last_name
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film_category ON film_actor.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name IN ('Music', 'Sports');

SELECT DISTINCT actor.actor_id, actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id IN (
  SELECT film_actor.actor_id
  FROM film_actor
  WHERE film_actor.film_id IN (
    SELECT film_category.film_id
    FROM film_category
    WHERE film_category.category_id IN (
      SELECT category.category_id
      FROM category
      WHERE category.name IN ('Music', 'Sports')
    )
  )
);

#Вивести всі фільми, видані в прокат менеджером Mike Hillyer. Для
#визначення менеджера використати таблицю staff і поле staff_id; для
#визначення фільму скористатися таблицею inventory (поле inventory_id), і
#таблиці film (поле film_id).

SELECT film.title
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN staff ON rental.staff_id = staff.staff_id
WHERE staff.first_name = 'Mike' AND staff.last_name = 'Hillyer';

SELECT film.title
FROM film
WHERE film.film_id IN (
  SELECT inventory.film_id
  FROM inventory
  WHERE inventory.inventory_id IN (
    SELECT rental.inventory_id
    FROM rental
    WHERE rental.staff_id = (
      SELECT staff.staff_id
      FROM staff
      WHERE staff.first_name = 'Mike' AND staff.last_name = 'Hillyer'
    )
  )
);


#Вивести користувачів, що брали в оренду фільми SWEETHEARTS
#SUSPECTS, TEEN APOLLO, TIMBERLAND SKY, TORQUE BOUND.

SELECT customer.customer_id, customer.first_name, customer.last_name
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE film.title IN ('SWEETHEARTS SUSPECTS', 'TEEN APOLLO', 'TIMBERLAND SKY', 'TORQUE BOUND');

SELECT customer.customer_id, customer.first_name, customer.last_name
FROM customer
WHERE customer.customer_id IN (
  SELECT rental.customer_id
  FROM rental
  WHERE rental.inventory_id IN (
    SELECT inventory.inventory_id
    FROM inventory
    WHERE inventory.film_id IN (
      SELECT film.film_id
      FROM film
      WHERE film.title IN ('SWEETHEARTS SUSPECTS', 'TEEN APOLLO', 'TIMBERLAND SKY', 'TORQUE BOUND')
    )
  )
);

#Вивести назву фільму, тривалість фільму і мову фільму. Фільтр: мова
#Англійська або італійська. (таблиці film, language).

SELECT film.title, film.length, language.name
FROM film
JOIN language ON film.language_id = language.language_id
WHERE language.name IN ('English', 'Italian');

SELECT film.title, film.length, language.name
FROM film
JOIN language ON film.language_id = language.language_id
WHERE language.name IN (
  SELECT name
  FROM language
  WHERE name IN ('English', 'Italian')
);

#Вивести payment_date i amount всіх записів активних клієнтів (поле active
#таблиці customer).

SELECT payment.payment_date, payment.amount
FROM payment
JOIN customer ON payment.customer_id = customer.customer_id
WHERE customer.active = 1;

SELECT payment_date, amount
FROM payment
WHERE customer_id IN (
  SELECT customer_id
  FROM customer
  WHERE active = 1
);

#Вивести прізвище та ім’я клієнтів, payment_date i amount для активних
#клієнтів (поле active таблиці customer).

SELECT c.first_name, c.last_name, p.payment_date, p.amount
FROM customer c, payment p
WHERE c.customer_id = p.customer_id
AND c.active = 1;

SELECT customer.first_name, customer.last_name, payment.payment_date, payment.amount
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
WHERE customer.customer_id IN (
  SELECT customer_id
  FROM customer
  WHERE active = 1
);

#Вивести прізвище та ім'я користувачів (customer), які здійснювали оплату в
#розмірі більшому, ніж 10 доларів (таблиця payment, поле amount), також
#вивести amount, дату оплати. Відсортувати за датою оплати.

SELECT customer.first_name, customer.last_name, payment.amount, payment.payment_date
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
WHERE payment.amount > 10
ORDER BY payment.payment_date;

SELECT c.first_name, c.last_name, p.amount, p.payment_date
FROM customer c
WHERE c.customer_id IN (
  SELECT customer_id
  FROM payment
  WHERE amount > 10
)
ORDER BY (
  SELECT payment_date
  FROM payment p
  WHERE p.customer_id = c.customer_id
);

#Вивести прізвище та ім’я, а також дату останнього оновлення запису (поле
#last_update) для людей наявних в таблицях actor, customer. Також в
#результуючому запиті передбачити можливість розрізняти акторів і
#користувачів.

SELECT 'Actor' AS role, actor.first_name, actor.last_name, actor.last_update
FROM actor
UNION
SELECT 'Customer' AS role, customer.first_name, customer.last_name, customer.last_update
FROM customer
ORDER BY last_update;

 #Вивести всі унікальні прізвища таблиць actor, customer, staff.
 
SELECT last_name
FROM actor
UNION
SELECT last_name
FROM customer
UNION
SELECT last_name
FROM staff;