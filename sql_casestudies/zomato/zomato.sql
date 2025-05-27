show databases;

create database zomato;
use zomato;

-- count number of rows
select distinct count(*) from orders;

-- return n random records 
select * from orders order by rand() limit 5;

-- find null values

SET SQL_SAFE_UPDATES = 0;

UPDATE orders
SET restaurant_rating = NULL
WHERE restaurant_rating = '';

SET SQL_SAFE_UPDATES = 1;

ALTER TABLE orders
CHANGE COLUMN restaurant_rating restaurant_rating INT NULL DEFAULT NULL;


select * 
from orders 
where restaurant_rating IS NULL;

-- find orders placed by each customer 
select u.name, count(*) as total_orders
from users u 
join orders o
on u.user_id = o.user_id
group by u.user_id, u.name;

-- find restaurants with most number of menu items 
select r.r_id,r.r_name, count(m.f_id)
from restaurants r
left join menu m
on r.r_id = m.r_id
group by r.r_id,r.r_name;

-- find number of votes and average rating for all the restaurants 
select r.r_id,r.r_name,count(o.restaurant_rating) as num_votes,avg(o.restaurant_rating) as avg_votes
from restaurants r
join orders o 
on r.r_id = o.r_id
where o.restaurant_rating is not null
group by r.r_id,r.r_name;

-- find the food that is being sold at most number of restaurants 
select f.f_id,f.f_name,count(m.r_id) as no_resto
from food f 
join menu m 
on f.f_id = m.f_id
group by f_id,f.f_name
order by no_resto desc
limit 1;

-- find restaurant with max-revenue in a given month

select o.r_id,r_name,month(o.date), sum(amount)
from orders o
join restaurants r
on o.r_id = r.r_id
group by r_id,r_name,month(o.date)
order by r_id,month(o.date);

-- find restaurants with sales>1500

select r.r_id,r.r_name,sum(amount)
from restaurants r 
join orders o 
on r.r_id = o.r_id
group by r.r_id,r.r_name
having sum(amount)>1500
order by r.r_id;

-- find customers who have never ordered 

SELECT user_id,name FROM users
EXCEPT
SELECT o.user_id,u.name
FROM orders o
join users u
on o.user_id = u.user_id
group by o.user_id,u.name;

-- show order details of a particular customer in a given date range 

select o.user_id, o.order_id, o.date, d.f_id 
from orders o
join order_details d
on o.order_id = d.order_id
where o.date between '2022-05-01' and '2022-06-30' and o.user_id=3;

-- customer favourite food  (half solved)

select o.user_id,d.f_id, count(d.f_id)
from orders o 
join order_details d 
on o.order_id = d.order_id
group by o.user_id, d.f_id;

--  find most costly restaurants 

select r.r_id, r.r_name,sum(amount)/count(o.order_id) as cost
from restaurants r
join orders o 
on r.r_id = o.r_id
group by r_id, r_name
order by sum(amount)/count(o.order_id) desc;

-- find the delivery partner compansation using the formula (# deliveries*100 + 1000*avg_rating)

select d.partner_id, d.partner_name,(count(o.order_id)*100) + (avg(o.delivery_rating)*1000) as salary
from delivery_partner d
left join orders o 
on d.partner_id = o.partner_id
group by d.partner_id, d.partner_name;

-- find correlation between delivery time and total rating 

-- select corr(delivery_time, delivery_rating + restaurant_rating) as correlation
-- from orders;
-- corr() function doesnt work in mysql 

-- find Veg restaurant 

SELECT r_id
FROM (
    SELECT o.r_id, f.type
    FROM orders o
    JOIN order_details d ON o.order_id = d.order_id
    JOIN food f ON d.f_id = f.f_id
) AS sub
GROUP BY r_id
HAVING SUM(type = 'non-veg') = 0;

-- find min and max order value for all the customers 

SELECT * FROM zomato.orders;

select user_id,min(amount) as min, max(amount) as max
from orders
group by user_id;
 















































