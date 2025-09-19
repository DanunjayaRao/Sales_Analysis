CREATE DATABASE sales;
USE sales;
drop database sales;

SHOW DATABASES;
SHOW TABLES;

SELECT * FROM customers LIMIT 5;
select * from markets limit 5;
select * from products limit 10;
select * from transactions;
select * from date;

select count(*) from customers;
select count(*) from markets;
select count(*) from products;
select count(*) from transactions;
select count(*) from date;


-- checking null values
SELECT 
    SUM(CASE WHEN customer_code IS NULL THEN 1 ELSE 0 END) AS null_customer_code,
    SUM(CASE WHEN custmer_name IS NULL THEN 1 ELSE 0 END) AS null_customer_name
FROM customers;

SELECT 
    SUM(CASE WHEN markets_code IS NULL THEN 1 ELSE 0 END) AS null_market_code,
    SUM(CASE WHEN markets_name IS NULL THEN 1 ELSE 0 END) AS null_market_name,
    SUM(CASE WHEN zone IS NULL THEN 1 ELSE 0 END) AS null_zone
FROM markets;

SELECT 
    SUM(CASE WHEN product_code IS NULL THEN 1 ELSE 0 END) AS null_product_code,
    SUM(CASE WHEN product_type IS NULL THEN 1 ELSE 0 END) AS product_type
FROM products;

SELECT 
    SUM(CASE WHEN product_code IS NULL THEN 1 ELSE 0 END) AS null_product_code,
    SUM(CASE WHEN customer_code IS NULL THEN 1 ELSE 0 END) AS null_customer_code,
    SUM(CASE WHEN market_code IS NULL THEN 1 ELSE 0 END) AS null_market_code,
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS null_order_date,
    SUM(CASE WHEN sales_qty IS NULL THEN 1 ELSE 0 END) AS null_sales_qty,
    SUM(CASE WHEN sales_amount IS NULL THEN 1 ELSE 0 END) AS null_sales_amount
FROM transactions;

SELECT 
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS null_date,
    SUM(CASE WHEN cy_date IS NULL THEN 1 ELSE 0 END) AS null_cy_date,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS null_year,
    SUM(CASE WHEN month_name IS NULL THEN 1 ELSE 0 END) AS null_month_name
FROM date;

-- check for test data 

-- Negative or zero sales amount
SELECT * 
FROM transactions
WHERE sales_amount <= 0;

-- Missing product or customer codes
SELECT * 
FROM transactions
WHERE product_code IS NULL 
   OR customer_code IS NULL 
   OR market_code IS NULL;

-- Customer name contains 'test' or 'dummy'
SELECT * 
FROM customers
WHERE custmer_name LIKE '%test%' 
   OR custmer_name LIKE '%dummy%';

-- Market name with 'test' or 'unknown'
SELECT * 
FROM markets
WHERE markets_name LIKE '%test%' 
   OR markets_name LIKE '%unknown%';

-- Create Base Query (Join All Tables)
SELECT 
    t.sales_amount,
    t.sales_qty,
    c.custmer_name,
    m.markets_name,
    m.zone,
    d.year,
    d.month_name,
    d.cy_date
FROM transactions t
JOIN customers c ON t.customer_code = c.customer_code
JOIN markets m ON t.market_code = m.markets_code
JOIN products p ON t.product_code = p.product_code
JOIN date d ON t.order_date = d.date;


-- Total revenue by month
SELECT d.cy_date, SUM(t.sales_amount) AS monthly_revenue
FROM transactions t
JOIN date d ON t.order_date = d.date
GROUP BY d.cy_date
ORDER BY d.cy_date;

-- Total revenue by year
SELECT d.year, SUM(t.sales_amount) AS revenue
FROM transactions t
JOIN date d ON t.order_date = d.date
GROUP BY d.year
ORDER BY d.year;

-- top markets by revenue
SELECT m.markets_name, SUM(t.sales_amount) AS revenue
FROM transactions t
JOIN markets m ON t.market_code = m.markets_code
GROUP BY m.markets_name
ORDER BY revenue DESC;

-- top customers by revenue
SELECT c.custmer_name AS customer_name, SUM(t.sales_amount) AS revenue
FROM transactions t
JOIN customers c ON t.customer_code = c.customer_code
GROUP BY c.custmer_name
ORDER BY revenue DESC
LIMIT 10;

-- top products by revenue
SELECT p.product_code, SUM(t.sales_amount) AS revenue
FROM transactions t
JOIN products p ON t.product_code = p.product_code
GROUP BY p.product_code
ORDER BY revenue DESC
LIMIT 10;







