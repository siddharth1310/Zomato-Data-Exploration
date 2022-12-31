----- ZOMATO DATA EXPLORATION USING SQL -----

drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer, gold_signup_date date);

INSERT INTO goldusers_signup(userid,gold_signup_date) VALUES (1,'09-22-2017'), (3,'04-21-2017');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

-------------------------------------------------------------------------------------------------

--Total Amount each customer spent on Zomato 
select userid, sum(price) as total_amount_spent
from sales s 
inner join 
product p on s.product_id = p.product_id 
group by userid;

-------------------------------------------------------------------------------------------------

-- How many days has each customer visited zomato ?
select userid, count(distinct created_date) as distinct_days 
from sales 
group by userid;

-------------------------------------------------------------------------------------------------

-- What was the first product purchased by each customer ?
select * from 
(select *, RANK() over(partition by userid order by created_date) rnk from sales) table1 
where table1.rnk = 1;

-------------------------------------------------------------------------------------------------

-- What is the most purchased item on the menu and how many times was it purchased by all customer ?
select product_id, COUNT(product_id) as Total_Count
from sales 
group by product_id 
order by COUNT(product_id) desc;

-------------------------------------------------------------------------------------------------

-- Which item was the most popular product for each customer ?
select * from (
select *, RANK() over(partition by userid order by Total_Count desc) rnk from (
select userid, product_id, count(*) as Total_Count 
from sales 
group by userid, product_id) Table1 ) Table1 where rnk = 1;


-------------------------------------------------------------------------------------------------

-- which item was purchased first by the customer after they become a member ?

select * from (
select *, RANK() over(partition by userid order by created_date) rnk 
from (select s.userid, s.product_id, s.created_date, g.gold_signup_date 
from sales s 
inner join 
goldusers_signup g 
on s.userid = g.userid 
where created_date >= gold_signup_date) table1) table2 where table2.rnk = 1;

-------------------------------------------------------------------------------------------------

-- which item was purchased just before the customer become a member ?
select * from (
select *, RANK() over(partition by userid order by created_date desc) rnk 
from (select s.userid, s.product_id, s.created_date, g.gold_signup_date 
from sales s 
inner join 
goldusers_signup g 
on s.userid = g.userid 
where created_date < gold_signup_date) table1) table2 where table2.rnk = 1;

-------------------------------------------------------------------------------------------------

-- which is the total orders and amount spent for each member begore they became a member ?
select userid, sum(price) as Total_Price, count(product_id) as Total_Product from (
select table1.*, product.price from 
(select s.userid, s.product_id, s.created_date, g.gold_signup_date 
from sales s 
inner join 
goldusers_signup g 
on s.userid = g.userid 
where created_date < gold_signup_date) table1 
inner join product 
on product.product_id = table1.product_id) table2 group by userid;

-------------------------------------------------------------------------------------------------

-- If buying each product generates points eg for Rs 5 = 2 zomato points and each product has different purchasing points
-- for eg p1 Rs 5 = 1 zomato point, for p2 Rs 10 = 5 zomato points and p3 Rs 5 = 1 zomato point
-- Calculate points collected by each customers.
select userid, sum(Zomato_points) as Net_zomato_points, sum(Zomato_points)*2.5 as Total_cashback_earned 
from (select table3.*, total_money_spent/points_per_product as Zomato_points from 
(select table2.*, 
case when product_id = 1 then 5 
	 when product_id = 2 then 2
	 when product_id = 3 then 1
	 else 0
end as points_per_product
from (select userid, product_id, sum(table1.price) as total_money_spent
from (select s.*, p.price from sales s inner join product p on s.product_id = p.product_id) table1 
group by userid, product_id) table2) table3) table4 group by userid;

-- Which product has got most points till now.
select * from (select table5.*,RANK() over(order by Net_zomato_points desc) rnk 
from (select product_id, sum(Zomato_points) as Net_zomato_points, sum(Zomato_points)*2.5 as Total_cashback_earned 
from (select table3.*, total_money_spent/points_per_product as Zomato_points from 
(select table2.*, 
case when product_id = 1 then 5 
	 when product_id = 2 then 2
	 when product_id = 3 then 1
	 else 0
end as points_per_product
from (select product_id, sum(table1.price) as total_money_spent
from (select s.*, p.price from sales s inner join product p on s.product_id = p.product_id) table1 
group by product_id) table2) table3) table4 group by product_id) table5) table6 where table6.rnk = 1;

-------------------------------------------------------------------------------------------------

-- In the first one year after a customer joins the gold program (including their join date) irrespective
-- of what the customer has purchased they earn 5 zomato points for every Rs 10 spent who earned more 1 or 3
-- and what was their points earnings in their first year ?

select table2.*, price*0.5 as total_points_earned_in_1year from (
select table1.*, price from (
select s.userid, s.product_id, s.created_date, g.gold_signup_date 
from sales s 
inner join 
goldusers_signup g 
on s.userid = g.userid 
where created_date >= gold_signup_date and created_date <= DATEADD(year, 1, gold_signup_date)) table1
inner join product
on product.product_id = table1.product_id) table2;

-------------------------------------------------------------------------------------------------

-- Rank all the transactions of the customers

select *, RANK() over(partition by userid order by created_date) rnk from sales;

-------------------------------------------------------------------------------------------------

-- Rank all the transactions of each member whenever they are a zomato gold member, for every non-gold members
-- mark transactions as 'NA'


select table1.*, 
case when gold_signup_date is null then 'NA'
else cast((RANK() over(partition by userid order by created_date desc)) as varchar)
end as rnk 
from (select s.userid, s.product_id, s.created_date, g.gold_signup_date 
from sales s 
left join 
goldusers_signup g 
on s.userid = g.userid and created_date >= gold_signup_date) table1;
