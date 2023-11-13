Завдання 1;

select address.address, ( 
select city.city 
from city
where city.city_id=address.city_id)
as city
from address;


select address, city from address
join city 
on address.city_id=city.city_id;


завданя 2;


Select city.city from city
where city.country_id in (
Select country_id from country
where country.country in ('Argentina', 'Austria'))
order by city.city;
 
 
 select city from city
 join country
 on city.country_id=country.country_id
 where country.country in ('Argentina', 'Austria')
 order by city.city;
 
 
 
  Завдання 3;
  
  
  
  Select DISTINCT first_name, last_name from actor
  where actor_id in (  select actor_id from film_actor
  where film_id in (
  Select film_id from film_category
  Where  category_id in (Select category_id from category
  where name in ('Music', 'Sports'))));
  
  
    select DISTINCT first_name, last_name from actor
    join film_actor
    on actor.actor_id=film_actor.actor_id
    join film_category
    on film_actor.film_id=film_category.film_id
    join category
    on film_category.category_id=category.category_id
    where name in ('Music', 'Sports');
    
    
    
    Завдання 4;
    
    select* from staff;
    select * from rental;
    Select * from inventory;
      select * from film;
  



select DISTINCT title from film
where film_id in (select film_id from inventory
where inventory_id in (select inventory_id from rental
where staff_id in ( select staff_id from staff
where staff.first_name = 'Mike' and staff.last_name = 'Hillyer')));


select DISTINCT title from film as f
join inventory as inv
on f.film_id=inv.film_id
join rental as ren
on inv.inventory_id=ren.inventory_id
join staff as st
on ren.staff_id=st.staff_id
where first_name = 'Mike' and last_name = 'Hillyer';

завдання 5;


select * from customer;
select * from rental;
    Select * from inventory;
      select * from film;




Select DISTINCT first_name, last_name from customer
where customer_id in (select customer_id from rental
where inventory_id in (Select inventory_id from inventory
where film_id in (Select film_id from film
where title in ('SWEETHEARTS suspects', 'TEEN APOLLO', 'TiMBeRLAND SKY', 'TORQUE BOUND'))));


Select DISTINCT first_name, last_name from customer as cu
join rental as ren
on cu.customer_id=ren.customer_id
join inventory as inv
on ren.inventory_id=inv.inventory_id
join film as f
on inv.film_id=f.film_id
where title in ('SWEETHEARTS suspects', 'TEEN APOLLO', 'TiMBeRLAND SKY', 'TORQUE BOUND')



Завдання 6;



select title, length, 
(select name from language as l  where l.language_id=Film.Language_id) 
as name from film;

Select title, length, name from film as f
join Language as L
on l.language_id=F.Language_id;



Завдання 7;




select amount, payment_date from payment
where customer_id in (select customer_id from customer
where active = '1');


select amount, payment_date from payment as p
join customer as c
on p.customer_id = c.customer_id
where active = '1'



завдання 8;




select (select First_name from customer as c where c.customer_id=p.customer_id) 
as first_name, 
(select last_name from customer as c where c.customer_id=p.customer_id)
as last_name, p.payment_date, p.amount from payment as p
where customer_id in ( select customer_id from customer where active = '1'); 


select First_name, Last_name, Payment_date, amount from payment as p
join customer as c 
on p.customer_id=c.customer_id
where active = '1';



Завдання 9;




select (select first_name from customer as c where c.customer_id=payment.customer_id) as first_name,
(select Last_name from customer as c where c.customer_id=payment.customer_id)
as last_name, payment_date, amount from payment where  payment.amount >= 10
order by payment_date;



Select first_name, Last_name, payment_date, amount from customer as c
join payment as p
on p.customer_id=c.customer_id
where p.amount >= 10
order by payment_date;




завдання 10; 



select first_name, last_name, last_update, 'actor' as category from actor
union
select first_name, last_name, last_update, 'customer' as category from customer;



завдання 11;



select DISTINCT last_name, 'actor' as category from actor
union
select DISTINCT last_name, 'customer' as category from customer
union
select DISTINCT last_name, 'staff' as category from staff;