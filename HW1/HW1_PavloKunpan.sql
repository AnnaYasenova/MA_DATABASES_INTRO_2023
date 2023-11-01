select * from sakila.customer;

select first_name as 'First Name', 
	last_name as 'Last Name', 
	email as 'Email' 
	from sakila.customer;

select address as 'Address',
	district as 'District',
    postal_code as 'Postal Code'
    from sakila.address
    order by district , address desc;
    
select title, rental_rate from sakila.film
	where rental_rate > 3;    
    
select title, description, rating
	from sakila.film
    where rating in ('G', 'PG', 'R');
    
select * from sakila.film_text
	where description like '%database%';
    
select * from sakila.film
	where rental_duration = 3 
    and replacement_cost < 12;
    
select * from sakila.film
	where rating = 'G' 
	and  replacement_cost > 15;
    
select * from sakila.film
	where length between 60 and 90;
    
select * from sakila.film
	where length < 60 or length > 90;
    
select title from sakila.film
	where rental_duration between 6 and 7
    and rental_rate >= 4
    and special_features like '%Trailers%'
							 or '%Commentaries%';
                             
select * from sakila.film
	where rating = 'G' and length > 60
			or rating = 'R' and special_features like '%Commentaries%';