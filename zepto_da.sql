create database ecommerce_sql_da;
use ecommerce_sql_da;
create table ecom_sql(
sku_id serial primary key,
category varchar(120),
name varchar(150) not null,
mrp numeric (8,2),
discountPercent numeric(5,2),
availableQuantity int,
discountedSellingPrice numeric(8,2),
weightInGms int,
outOfstock boolean,
quantity int
);

-- data exploration

-- count of rows
select count(*) FROM ecom_sql;

-- sample data 
select * from ecom_sql
limit 10;

-- null values
select * from ecom_sql
where name is null
or 
category is null
or 
mrp is null
or 
discountPercent is null
or 
discountedSellingPrice is null
or 
weightInGms is null
or 
availableQuantity is null
or 
outOfstock is null
or 
quantity is null;

-- different product category
select distinct category
from ecom_sql
order by category;

-- products in stock vs out of stock
select outOfstock, count(sku_id)
from ecom_sql
group by outOfstock;

-- product names present multiple times
select name, count(sku_id) as "number of skus"
from ecom_sql
group by name 
having count(sku_id) > 1
order by count(sku_id) desc;

-- data cleaning 

-- products with price = 0
select * from ecom_sql
where mrp = 0 or discountedSellingPrice = 0;

SET SQL_SAFE_UPDATES = 0;

delete from ecom_sql
where mrp = 0;

-- convert paise to ruppees
update ecom_sql
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

select mrp, discountedSellingPrice from ecom_sql;

-- find the top 10 best- value products based on discount percentage 
select distinct name, mrp, discountPercent
from ecom_sql
order by discountPercent desc
limit 10;

-- what are the products with high mrp but out of stock
select distinct name, mrp
from ecom_sql
where outOfstock = 1 and mrp > 300
order by mrp desc;

-- calculate the estimate revenue for each category

select category, 
sum(discountedSellingPrice * availableQuantity) as total_revenue
from ecom_sql
group by category
order by total_revenue;

-- find all the products where mrp is greater that 500 and discount percent is less than 10

select distinct name, mrp, discountPercent
from ecom_sql
where mrp >500 and discountPercent < 10
order by mrp desc, discountPercent desc;

-- identify the top 5 category offering the highest avg dis per
select category,
round(avg(discountPercent), 2) as avg_discount
from ecom_sql
group by category
order by avg_discount desc
limit 5; 

-- find the price per gram for products above 100 gm and sort by best value.
select distinct name, weightInGms, discountedSellingPrice,
round(discountedSellingPrice/ weightInGms ,2) as price_per_gram
from ecom_sql
where weightInGms >=100
order by price_per_gram;

-- group the products into categories like low, med, high
select distinct name, weightInGms, 
case when weightInGms < 1000 then "low"
     when weightInGms < 5000 then "medium"
     else "bulk"
     end as weight_category
from ecom_sql;

-- what is the total inventory weight per category
select category, 
sum(weightInGms * availableQuantity) as total_weight
from ecom_sql
group by category
order by total_weight;











