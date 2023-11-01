select * from customer;

select first_name, last_name, email from customer;

select 
	first_name as "First Name", 
    last_name as "Last Name",
    email as "Email"
from customer;

select 
	address as "Address",
	district as "District",
	postal_code as "Postel Code"
from address
order by district, address desc;

select 
	title, rental_rate
from film
where rental_rate >= 3.00;

select 
	title, description, rating
from film
where rating in ("R", "G", "PG");

select * from film_text
where description like "%database%";

select * from film
where rental_duration = 3 and replacement_cost <=12.00;

select * from film
where 
	rating = 'G'
    and replacement_cost >=15.00;
    
select * from film
where 
	length between 60 and 90;
    
select * from film
where 
	length <= 60 or length >= 90;
    
select * from film
where (rental_duration = 6 or rental_duration = 7)
	and rental_rate >= 4.00
    and (special_features like "%Trailers%" or special_features like "%Commentaries%");
    
select * from film    
where
	(rating = 'G' and length >= 60)
    or
    (rating = 'R' and special_features like "%Commentaries%");