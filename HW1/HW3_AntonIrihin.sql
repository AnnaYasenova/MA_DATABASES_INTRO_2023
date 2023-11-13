завданя №3=1

Select first_name, last_name from customer
where customer_id in (select customer_id from rental
where return_date is Null)

Завдання 2;

Select concat(First_name, ' ', last_name), 'actor' as catrgory  from actor 
union
select concat(First_name, ' ', last_name), 'Customer' as catrgory from customer
Union
select concat(First_name, ' ', last_name), 'staff' as catrgory from staff;


завдання 3;



select country, count(city) from country as co
Join city as c
on c.country_id=co.country_id
group by country;


Завдання №4;


Select name, count(title) from category as cat
Join film_category  as fc
on fc.category_id=cat.category_id
join film as f
on f.film_id=fc.film_id
group by name


завдання №5;


Select title, count(concat(First_name, ' ', last_name)) as 'Actor' from Film as f
join film_actor as fa
on f.film_id=fa.film_id
join actor as a
on fa.actor_id=a.actor_id
group by title;
  
  
  завдання №6;
  
  
Select name, count(concat(First_name, ' ', last_name)) as 'Actor' from actor as a 
Join film_actor as fa
on a.actor_id=fa.actor_id
join film as f
on f.film_id=fa.film_id
join film_category as fc
on f.film_id=fc.film_id
join category as c
on fc.category_id=c.category_id
group by name;

  

завдання №7;


select district, count(address) as 'address' from address
 where district like 'Central%'
 group by district;
 
 
 завдання №8 
 
 

   Select min(rental_rate) as 'min rental rate',
   max(rental_rate) as 'max rental rate', 
   avg(rental_rate) as 'average rental rate',
   avg (replacement_cost) as 'average replacement coast',
   min(length) as 'min length' , max(length) as ' max length'
   from  film;
   
Завдання №9;


select
	active,
	COUNT(customer_id) as customers 
from customer
group by active;



завдання 10;


Select concat(First_name, ' ', last_name) as Customer, min(payment_date) as 'first payment date', max(payment_date) as 'last payment date',
sum(amount) as 'total amount' from payment as p
join customer as c
on p.customer_id=c.customer_id
group by customer;