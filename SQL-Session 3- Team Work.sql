-- SELECT

SELECT *
FROM product.brand
ORDER BY brand_name -- DESC

SELECT TOP 10 *
FROM product.brand
ORDER BY brand_id -- DESC

-- WHERE

SELECT brand_name
FROM product.brand
WHERE brand_name LIKE 'S%'

SELECT *
FROM product.product
WHERE model_year BETWEEN 2019 AND 2021

SELECT *
FROM product.product
WHERE category_id IN (3, 4, 5)

SELECT *
FROM product.product
WHERE category_id <> 3 AND category_id != 4 AND category_id <> 5

SELECT	store_id, product_id, quantity
FROM	product.stock
ORDER BY 2,1


-- DATE FUNCTION

CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)

SELECT * FROM t_date_time

SELECT GETDATE() as get_date

INSERT t_date_time
VALUES ( GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE() )

INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES ('12:00:00', '2021-07-17', '2021-07-17','2021-07-17', '2021-07-17', '2021-07-17' )

-- CONVERT DATE TO varchar

SELECT  GETDATE()

SELECT CONVERT(VARCHAR(10), GETDATE(), 1)
SELECT CONVERT(VARCHAR(10), GETDATE(), 2)
SELECT CONVERT(VARCHAR(10), GETDATE(), 3)
SELECT CONVERT(VARCHAR(10), GETDATE(), 4)
SELECT CONVERT(VARCHAR(10), GETDATE(), 5)
SELECT CONVERT(VARCHAR(10), GETDATE(), 6)
SELECT CONVERT(VARCHAR(10), GETDATE(), 7)
SELECT CONVERT(VARCHAR(10), GETDATE(), 8)
SELECT CONVERT(VARCHAR(11), GETDATE(), 9)

-- VARCHAR TO DATE

SELECT CONVERT(DATE, '04 Jun 22' , 6)

SELECT CONVERT(DATETIME, '04 Jun 22 23:05' , 6)

-- DATE FUNCTIONS

-- Functions for return date or time parts

SELECT A_DATE
		, DAY(A_DATE) DAY_
		, MONTH(A_DATE) [MONTH]
		, DATENAME(DAYOFYEAR, A_DATE) DOY
		, DATEPART(WEEKDAY, A_date) WKD
		, DATENAME(MONTH, A_DATE) MON
FROM t_date_time


SELECT DATEDIFF(DAY, '2022-05-10', GETDATE())

SELECT DATEDIFF(SECOND, '2022-05-10', GETDATE())

SELECT DATEDIFF(MONTH, '2022-05-10', GETDATE())

SELECT DATEDIFF(WEEK, '2022-05-10', GETDATE())


-- SHIPPING - DELIVERY DATE DIFFERENCE

SELECT	*, DATEDIFF(DAY, order_date, shipped_date) Diff_of_day
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2