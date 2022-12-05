CREATE VIEW AA
AS
SELECT DISTINCT D.customer_id, D.first_name, D.last_name
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id=B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
​
CREATE VIEW BB
AS
SELECT DISTINCT D.customer_id, D.first_name, D.last_name, A.product_name
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id=B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'Polk Audio - 50 W Woofer - Black'
​
CREATE VIEW CC
AS
SELECT DISTINCT D.customer_id, D.first_name, D.last_name, A.product_name
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id=B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)'
​
CREATE VIEW DD
AS
SELECT DISTINCT D.customer_id, D.first_name, D.last_name, A.product_name
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id=B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)'
​
SELECT AA.customer_id, AA.first_name, AA.last_name,
CASE WHEN BB.product_name is null THEN 'No' ELSE 'Yes' END AS First_product,
CASE WHEN CC.product_name is null THEN 'No' ELSE 'Yes' END AS Second_product,
CASE WHEN DD.product_name is null THEN 'No' ELSE 'Yes' END AS Third_product
FROM AA
LEFT JOIN BB ON AA.customer_id=BB.customer_id
LEFT JOIN CC ON AA.customer_id=CC.customer_id
LEFT JOIN DD ON AA.customer_id=DD.customer_id
