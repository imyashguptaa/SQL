create database res;
use res;
-- 1.We need to find out the total visits to all restaurants under all alcohol categories available.
select name ,alcohol, count(userid) Total_vists from geoplaces2  join rating_final using(placeid)  group by name , alcohol ;

-- 2.Let's find out the average rating according to alcohol and price so that we can understand the rating in respective price categories as well.

select  alcohol,price,avg(rating)  from geoplaces2 join rating_final using(placeid) group by alcohol,price order by alcohol;

-- 3.Let’s write a query to quantify that what are the parking availability as well in different alcohol categories along with the total number of restaurants.

select parking_lot,alcohol, count(placeid)total_number_of_restaurants from chefmozparking join geoplaces2 using(placeid) group by parking_lot,alcohol order by parking_lot;

-- 4.Also take out the percentage of different cuisine in each alcohol type.
 
 select distinct alcohol , Rcuisine, round((count(Rcuisine)over(partition by alcohol,Rcuisine) /count(Rcuisine)over(partition by alcohol))*100 ,2) percentage
 from  chefmozcuisine join geoplaces2 using(placeid) order by alcohol,Rcuisine;

-- 5.let’s take out the average rating of each state.


select state ,avg(rating) from geoplaces2  join rating_final using(placeid) group by state order by avg(rating) ;


-- 6. ' Tamaulipas' Is the lowest average rated state. Quantify the reason why it is the lowest rated by providing the summary on the basis of State, alcohol, and Cuisine.

select rating , alcohol, Rcuisine , name from  chefmozcuisine join geoplaces2 using(placeid) join rating_final using(placeid) where state like '%Tamaulipas%';

-- It looks like Tamaulipas is a dry state and predominantly following Mexican cuisine . Being Dry state and lack of diversity in cuisine leads this cause.

-- 7.Find the average weight, food rating, and service rating of the customers who have visited KFC and tried Mexican or Italian types of cuisine, and also their budget level is low.
-- We encourage you to give it a try by not using joins.

 select userid , avg(food_rating) OVER(), AVG(service_rating) OVER(), avg(weight)over () from rating_final a join 
 (select userId , weight  from userprofile where userid in
  (select userid from usercuisine where ( Rcuisine like  '%Mexican%' or  Rcuisine like '%Italian%')) and budget like '%low%') b using(userId)
   where placeid in (select placeid  from geoplaces2 where name like '%KFC%' ) ; 
   
   select* from rating_final;
   select * from rating_final a join geoplaces2 using(placeId) join userprofile using(userid) join usercuisine using(userid)
   where ( Rcuisine like  '%Mexican%' or  Rcuisine like '%Italian%') and budget like '%low%' AND name like '%KFC%';
   
