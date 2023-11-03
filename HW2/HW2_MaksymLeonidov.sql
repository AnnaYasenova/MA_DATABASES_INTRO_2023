/*
    1. Вивести адресу і місто до якого відноситься ця адреса. (таблиці address, city).
*/
SELECT a.address, c.city
FROM address AS a
JOIN city AS c
    ON a.city_id = c.city_id;

SELECT
    a.address,
    (
        SELECT city
        FROM city AS c
        WHERE a.city_id = c.city_id
    ) AS city
FROM address AS a;

/*
    2. Вивести список міст Аргентини і Австрії. (таблиці city, country). Відсортувати за алфавітом.
*/

/*
    3. Вивести список акторів, що знімалися в фільмах категорій Music, Sports.
       (використати таблиці actor, film_actor, film_category, category).
*/

/*
    4. Вивести всі фільми, видані в прокат менеджером Mike Hillyer.
       Для визначення менеджера використати таблицю staff і поле staff_id;
       для визначення фільму скористатися таблицею inventory (поле inventory_id),
       і таблиці film (поле film_id).
*/

/*
    5. Вивести користувачів, що брали в оренду фільми
       SWEETHEARTS SUSPECTS, TEEN APOLLO, TIMBERLAND SKY, TORQUE BOUND.
*/

/*
    6. Вивести назву фільму, тривалість фільму і мову фільму.
       Фільтр: мова Англійська або італійська. (таблиці film, language).
*/

/*
    7. Вивести payment_date i amount всіх записів активних клієнтів (поле active таблиці customer).
*/

/*
    8. Вивести прізвище та ім’я клієнтів, payment_date i amount для активних клієнтів
       (поле active таблиці customer).
*/

/*
    9. Вивести прізвище та ім'я користувачів (customer),
       які здійснювали оплату в розмірі більшому, ніж 10 доларів (таблиця payment, поле amount),
       також вивести amount, дату оплати. Відсортувати за датою оплати.
*/

/*
    10. Вивести прізвище та ім’я, а також дату останнього оновлення запису (поле last_update)
        для людей наявних в таблицях actor, customer.
        Також в результуючому запиті передбачити можливість розрізняти акторів і користувачів.
*/

/*
    11. Вивести всі унікальні прізвища таблиць actor, customer, staff.
*/
