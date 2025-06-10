select * from order_details limit 10
select * from menu_items limit 10

-- 1. View the menu_items table and write a query to find the number of items on the menu
select count(distinct item_name) as 'num_of_items'
from menu_items

-- 2. What are the least and most expensive items on the menu?
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
select category, count(menu_item_id) as count_dishes, avg(price) as avg_price
from menu_items
group by category

-- 5.View the order_details table. What is the date range of the table?
select min(order_date) as from_date, max(order_date) as to_date
 from order_details

-- 6.How many orders were made within this date range? 
select count(distinct order_id) as num_of_orders
from order_details
where order_date between (select min(order_date) from order_details) and
                          (select max(order_date) from order_details)

--How many items were ordered within this date range?
select count(item_id) as num_of_items
from order_details
where order_date between (select min(order_date) from order_details) and
                          (select max(order_date) from order_details)

--7.Which orders had the most number of items?
select order_id, count(item_id) as num_of_items
from order_details
group by order_id
order by count(item_id) desc
limit 1

--8.How many orders had more than 12 items?
with tbl1 as (select order_id, count(item_id) as num_of_items
from order_details
group by order_id
having count(item_id) > 12)
select count(order_id) from tbl1
