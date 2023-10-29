select * from customer;

select first_name as "First Name",
	   last_name as "Last Name",
       email as "Email"
       from customer;

select address as "Adress",
	   district as "District",
       postal_code as "Postal Code"
       from address
       order by district, address desc;
       
select title, rental_rate 
	from film
	where rental_rate > 3;

select title, description, rating
	from film
    where rating in ("G", "PG", "R");
  
select * from film_text 
	where description like "%database%";
    
select * from film
	where rental_duration = 3
    and replacement_cost < 12;
    
select * from film
	where rating = "G"
    and replacement_cost > 15;
    
select * from film
	where length >= 60 and length <= 90;
    
select * from film
	where length < 60 or length > 90;
    
select title from film 
	where (rental_duration = 6 or rental_duration = 7) 
			and rental_rate > 4
            and (special_features like "%Trailers%" 
					or special_features like "%Commentaries%");
                    
select * from film
	where (rating = "G" and length > 60)
    or (rating = "R" and special_features like "%Commentaries%");
    