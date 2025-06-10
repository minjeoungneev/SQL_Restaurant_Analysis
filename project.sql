-- Table order_details contains the primary key order_detail_id and other columns of order details such as order date, time, and items of the order
-- Table menu_items contains the primary key menu_item_id and item info such as name, category, and price
select * from order_details limit 10
select * from menu_items limit 10

-- 1. View the menu_items table and write a query to find the number of items on the menu
-- there are 32 items on the menu.
select count(distinct item_name) as 'num_of_items'
from menu_items

-- 2. What are the least and most expensive items on the menu?
-- Edamame is $5, and Shrimp Scampi is $19.95
(select item_name, price, 'least_expensive' as type
from menu_items
order by price asc 
limit 1)

union

(select item_name, price, 'most_expensive' as type
from menu_items
order by price desc 
limit 1)

-- 3.How many Italian dishes are on the menu? 
-- What are the least and most expensive Italian dishes on the menu?
-- There are 9 italian items on the menu. Shrimp Scampi is $19.95, the most expensive, and both Spagetti and Fettuccine Alfredo are the cheapest at $14.50.
select count(menu_item_id) 
from menu_items
where category = 'Italian'

with tbl1 as (
select item_name,category, price,
    rank() over (partition by category order by price asc) as min_rank,
    rank() over (partition by category order by price desc) as max_rank
from menu_items)
select item_name, category, price
from tbl1
where (min_rank = 1 or max_rank = 1) and category = 'Italian'

-- 4.How many dishes are in each category? 
-- What is the average dish price within each category?
-- American dishes are the cheapest on average at $10.1, then Mexican, Asian, and Italian.
select category, count(menu_item_id) as count_dishes, avg(price) as avg_price
from menu_items
group by category
order by avg(price)

-- 5.View the order_details table. What is the date range of the table?
-- This table contains data for the first quarter of 2023.
select min(order_date) as from_date, max(order_date) as to_date
 from order_details

-- 6.How many orders were made within this date range? 
-- There are 5,370 orders made in Q1 2023.
select count(distinct order_id) as num_of_orders
from order_details


--How many items were ordered within this date range?
-- There are 12,097 items were ordered in this period.
select count(item_id) as num_of_items
from order_details


--7.Which orders had the most number of items?
-- The orders that have the most number of items have ordered 14 items.
select order_id, count(item_id) as num_of_items
from order_details
group by order_id
order by count(item_id) desc


--8.How many orders had more than 12 items?
-- There are 20 orders that ordered more than 12 items.
select count(*) from 
(select order_id, count(item_id) as num_of_items
from order_details
group by order_id
having num_of_items >12) as num_orders

--9.Combine the menu_items and order_details tables into a single table
select a.*, b.item_name, b.category, b.price
from order_details a left join menu_items b on a.item_id = b.menu_item_id


--10.What were the least and most ordered items? What categories were they in?
-- Hamburger was ordered the most 622 times and Chicken Tacos were ordered the least, 123 times
(select category, item_name, count(order_details_id) as num_ordered
from menu_items a left join order_details b on a.menu_item_id = b.item_id
group by category, item_name
order by num_ordered desc
limit 1)
union

(select category, item_name, count(order_details_id) as num_ordered
from menu_items a left join order_details b on a.menu_item_id = b.item_id
group by category, item_name
order by num_ordered
limit 1)

--11.What were the top 5 orders that spent the most money?
-- The top 5 orders spent around $190. Let's take a look at the details of these orders.
select order_id, sum(price) as total_spend
from order_details a left join menu_items b on a.item_id = b.menu_item_id
group by order_id
order by sum(price) desc
limit 5

--12.View the details of the highest spend order. Which specific items were purchased?
-- Order_id 440 ordered 14 items, mostly italian and Mexican food. 
select category, item_name, count(item_id) as num_of_items
from order_details a left join menu_items b on a.item_id = b.menu_item_id
where order_id = 440
group by category, item_name

--13.View the details of the top 5 highest spend orders
select order_id, category, count(item_id) as num_of_items
from order_details a left join menu_items b on a.item_id = b.menu_item_id
where order_id in (440, 2075, 1957, 330, 2675)
group by order_id, category


