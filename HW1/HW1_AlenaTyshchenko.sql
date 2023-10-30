select * from customer

select first_name, last_name, email from customer

select address, district, postal_code from address

select * from film

select title, rental_rate from film
where rental_rate > '3'

select title, description, rating from film
where rating in ('G', 'PG', 'R')

select * from film

select * from film_text
where description like '%database%'

select * from film
where length = 180
and replacement_cost < 12.00

select * from film
where rating ='G'
and replacement_cost > 15.00

select * from film
where length >= 60
and length <= 90

select * from film
where length <= 60
or length >= 90

select title, rental_rate, rental_duration, special_features from film
where (rental_duration = 6 or rental_duration = 7)
and rental_rate >= 4
and (special_features like '%Trailers%' or special_features like '%Commentaries%')

select * from film
where rating ='G'
and length > 60
or rating ='R'
and (special_features like '%Commentaries%')
