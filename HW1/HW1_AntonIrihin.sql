use  sakila;

select * from sakila. customer;

Select first_name, Last_name, Email from sakila. customer;

select address, district, Postal_code from sakila. address;

select address as "Address", district as "District", postal_code as "Postal Code" from sakila. address order by district, address desc;


Select title, rental_rate from film  where rental_rate >=3;

Select * from film_text where description like "%database%";

Select * from film where rental_duration = 3 and replacement_cost < 12;

select * from film where rating = "G" and replacement_cost >15;

Select * from film where length between 60 and 90;

select * from film where length <60 or length >90;

select * from film where rental_duration =6 or rental_duration =7 and rental_rate >=4 and special_features like "%Trailers%" and special_features like "%Commentaries%";

select * from film where rating = "G" and length >= 60 or rating = "R" and special_features like "%Commentaries%";