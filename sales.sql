create database sales;
use sales;

alter table orders_dimen add column Orders_date date after Order_date;
update orders_dimen set Orders_date = str_to_date(order_date ,'%d-%m-%Y') ;
alter table orders_dimen drop column order_date;

alter table shipping_dimen add column Ships_Date date after Ship_Date;
update shipping_dimen  set Ships_Date = str_to_date(Ship_Date ,'%d-%m-%Y') ;
alter table shipping_dimen drop column Ship_Date;

alter table orders_dimen add column DaysTakenForDelivery int ;

create table Master_table as select * from market_fact join orders_dimen using(Ord_id) ;
alter table master_table rename column ship_id to shipping_id;

create table combined_table as select * from master_table a join shipping_dimen b using(order_id) where a.shipping_id=b.Ship_id;

-- 1. Find the top 3 customers who have the maximum number of orders
     
     select * from (select dense_rank() over( order by count(cust_id) desc ) Rnk, cust_id, count(cust_id)
     from market_fact group by cust_id order by count(cust_id) desc)t where rnk <=3 ;
     
-- 2.Create a new column DaysTakenForDelivery that contains the date difference between Order_Date and Ship_Date.

update combined_table set DaysTakenForDelivery = datediff(ships_date , orders_date);

-- 3.Find the customer whose order took the maximum time to get delivered.

select cust_id from combined_table where DaysTakenForDelivery = (select max(DaysTakenForDelivery) from combined_table );
-- 4.Retrieve  total sales made by each product from the data (use Windows function)

select distinct prod_id , sum(sales)over(partition by prod_id) Total_sales from market_fact  ;

-- 5. Retrieve the total profit made from each product from the data (use windows function)
select distinct prod_id , sum(profit)over(partition by prod_id) Total_profit from market_fact;
 
 -- 6. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011.
 
 select distinct cust_id from market_fact where ord_id in  (select ord_id from orders_dimen where  month (orders_date)=1) ;
 
 
 select * from (select * , row_number() over(partition by cust_id order by Month_in_number ) NO_OF_time from 
 (select  distinct cust_id , month(orders_Date) Month_in_number  from combined_table where year (orders_date)=2011 ) t
 ) g where NO_OF_time = 12 ;
 
 