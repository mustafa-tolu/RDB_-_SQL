---- C-11 WEEKLY AGENDA-6 RD&SQL STUDENT

USE SampleRetail;

--1. List all the cities in the Texas 
--and the numbers of customers in each city.
SELECT	city, 
		COUNT(customer_id) as customers_count
FROM	sale.customer
WHERE	state='TX'
GROUP BY city

--2. List all the cities in the California 
--which has more than 5 customer, 
--by showing the cities which have more customers first.
SELECT	city, 
		COUNT(customer_id) as customers_count
FROM	sale.customer
WHERE	state='CA'
GROUP BY city
HAVING	COUNT(customer_id)>5
ORDER BY customers_count DESC

--3. List the top 10 most expensive products.
SELECT	TOP 10 product_name, list_price
FROM	product.product
ORDER BY list_price DESC

--4. List store_id, product name and list price and the quantity of the products 
--which are located in the store id 2 and the quantity is greater than 25.
SELECT	ps.store_id,
		pp.product_name, pp.list_price, ps.quantity
FROM	product.stock ps
JOIN	product.product pp
		ON ps.product_id=pp.product_id
WHERE	ps.store_id=2 AND ps.quantity>25

---- 5. Find the sales order of the customers who lives in Boulder order by order date----
SELECT	so.*, sc.city
FROM	sale.customer sc
JOIN	sale.orders so
		ON sc.customer_id=so.customer_id
WHERE	sc.city='Boulder'
ORDER BY so.order_date

---- 6. Get the sales by staffs and years using the AVG() aggregate function.
SELECT	so.staff_id, ss.first_name, ss.last_name, 
		YEAR(so.order_date), 
		AVG(soi.quantity*soi.list_price*(1-soi.discount)) as sales
FROM	sale.staff as ss
JOIN	sale.orders as so
		ON ss.staff_id=so.staff_id
JOIN	sale.order_item as soi
		ON so.order_id=soi.order_id
GROUP BY so.staff_id, ss.first_name, ss.last_name, YEAR(so.order_date)
ORDER BY so.staff_id, YEAR(so.order_date), sales

---- 7. What is the sales quantity of product according to the brands and sort them highest-lowest----
SELECT	pb.brand_name, 
		pp.product_name,
		SUM(soi.quantity) as sum_quantity
FROM	product.brand as pb
JOIN	product.product as pp
		ON pb.brand_id=pp.brand_id
JOIN	sale.order_item as soi
		ON pp.product_id=soi.product_id
GROUP BY pb.brand_name, pp.product_name
ORDER BY sum_quantity DESC

---- 8. What are the categories that each brand has?----
SELECT	pb.brand_name,
		pp.product_name,
		pc.category_name
FROM	product.brand as pb
JOIN	product.product as pp
		ON pb.brand_id=pp.brand_id
JOIN	product.category as pc
		ON pp.category_id=pc.category_id
ORDER BY pb.brand_name, pc.category_name

---- 9. Select the avg prices according to brands and categories----
SELECT	pb.brand_name,
		pc.category_name,
		CAST(AVG(pp.list_price) as NUMERIC(10,2)) as avg_prices
FROM	product.brand as pb
JOIN	product.product as pp
		ON pb.brand_id=pp.brand_id
JOIN	product.category as pc
		ON pp.category_id=pc.category_id
GROUP BY pb.brand_name, pc.category_name
ORDER BY pb.brand_name, pc.category_name

---- 10. Select the annual amount of product produced according to brands----
SELECT	pb.brand_name,
		pp.model_year,
		SUM(soi.quantity*soi.list_price*(1-soi.discount)) as annual_amount
FROM	product.brand as pb
JOIN	product.product as pp
		ON pb.brand_id=pp.brand_id
JOIN	sale.order_item as soi
		ON pp.product_id=soi.product_id
GROUP BY pb.brand_name, pp.model_year
ORDER BY pb.brand_name, annual_amount DESC

---- 11. Select the store which has the most sales quantity in 2018.----
SELECT	TOP 1 ss.store_name,
		SUM(soi.quantity) as sales_quantity
FROM	sale.store as ss
JOIN	sale.orders as so
		ON ss.store_id=so.store_id
JOIN	sale.order_item as soi
		ON so.order_id=soi.order_id
WHERE YEAR(so.order_date) = 2018
GROUP BY ss.store_name
ORDER BY sales_quantity DESC

---- 12 Select the store which has the most sales amount in 2018.----
SELECT	TOP 1 ss.store_name,
		CAST(SUM(soi.quantity*soi.list_price*(1-soi.discount)) as NUMERIC(10,2)) as sales_amount
FROM	sale.store as ss
JOIN	sale.orders as so
		ON ss.store_id=so.store_id
JOIN	sale.order_item as soi
		ON so.order_id=soi.order_id
WHERE YEAR(so.order_date) = 2018
GROUP BY ss.store_name
ORDER BY sales_amount DESC

---- 13. Select the personnel which has the most sales amount in 2019.----
SELECT	TOP 1 ss.first_name, ss.last_name, 
		CAST(SUM(soi.quantity*soi.list_price*(1-soi.discount)) as NUMERIC(10,2)) as sales_amount
FROM	sale.staff as ss
JOIN	sale.orders as so
		ON ss.store_id=so.store_id
JOIN	sale.order_item as soi
		ON so.order_id=soi.order_id
WHERE YEAR(so.order_date) = 2019
GROUP BY ss.first_name, ss.last_name
ORDER BY sales_amount DESC