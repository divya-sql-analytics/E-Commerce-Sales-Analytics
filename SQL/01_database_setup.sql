USE ecommerce_sales_analytics;
CREATE TABLE sales_data (
    row_id INT,
    order_id VARCHAR(30),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(30),
    customer_id VARCHAR(30),
    customer_name VARCHAR(150),
    segment VARCHAR(30),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    market VARCHAR(50),
    region VARCHAR(50),
    product_id VARCHAR(30),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(12,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(12,2),
    shipping_cost DECIMAL(12,2),
    order_priority VARCHAR(30),
    shipping_days INT,
    order_year INT,
    order_month VARCHAR(20),
    order_month_number INT,
    profit_margin DECIMAL(8,4)
);

ALTER TABLE sales_data 
ADD PRIMARY KEY (row_id);

SHOW TABLES;
describe sales_data;

SELECT *
FROM sales_data;

SELECT COUNT(*) AS total_rows
FROM sales_data;

#------checking null values -----------
SELECT
    SUM(CASE WHEN row_id IS NULL THEN 1 ELSE 0 END) AS null_row_id,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS null_order_date,
    SUM(CASE WHEN ship_date IS NULL THEN 1 ELSE 0 END) AS null_ship_date,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,
    SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
    SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) AS null_profit
FROM sales_data;    

#---------------check blank text values-------------
SELECT
    SUM(CASE WHEN TRIM(order_id) = '' THEN 1 ELSE 0 END) AS blank_order_id,
    SUM(CASE WHEN TRIM(customer_id) = '' THEN 1 ELSE 0 END) AS blank_customer_id,
    SUM(CASE WHEN TRIM(product_id) = '' THEN 1 ELSE 0 END) AS blank_product_id,
    SUM(CASE WHEN TRIM(customer_name) = '' THEN 1 ELSE 0 END) AS blank_customer_name,
    SUM(CASE WHEN TRIM(product_name) = '' THEN 1 ELSE 0 END) AS blank_product_name
FROM sales_data;                                                     
        
#------ check Duplicate rows -------
SELECT
    row_id,
    COUNT(*) AS row_count
FROM sales_data
GROUP BY row_id
HAVING COUNT(*) > 1;

#------check duplicate order ids-----------
SELECT
    order_id,
    COUNT(*) AS order_line_count
FROM sales_data
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY order_line_count DESC;

#-------Check completely duplicated records-----
SELECT
    order_id,
    order_date,
    customer_id,
    product_id,
    sales,
    quantity,
    discount,
    profit,
    COUNT(*) AS duplicate_count
FROM sales_data
GROUP BY
    order_id,
    order_date,
    customer_id,
    product_id,
    sales,
    quantity,
    discount,
    profit
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

#--------------Check Invalid Quantities--------
SELECT
    COUNT(*) AS invalid_quantity_rows
FROM sales_data
WHERE quantity IS NULL
   OR quantity <= 0;
   
   SELECT
    row_id,
    order_id,
    product_id,
    quantity
FROM sales_data
WHERE quantity IS NULL
   OR quantity <= 0;

#----------Check Invalid Sales-----
select count(*) AS invalid_sales_rows
 from sales_data
 where sales IS NULL
 OR sales <=0;
 
 #---------Check Negative Profit--------
 SELECT
    COUNT(*) AS negative_profit_rows,
    MIN(profit) AS lowest_profit,
    MAX(profit) AS highest_profit
FROM sales_data
WHERE profit < 0;
SELECT
    order_id,
    customer_name,
    product_name,
    sales,
    discount,
    shipping_cost,
    profit
FROM sales_data
WHERE profit < 0
ORDER BY profit ASC
LIMIT 20;

#-----Check invalid discounts---------
SELECT
    COUNT(*) AS invalid_discount_rows
FROM sales_data
WHERE discount IS NULL
   OR discount < 0
   OR discount > 1;
   
   #-----Check incorrect dates----
   SELECT
    COUNT(*) AS invalid_date_rows
FROM sales_data
WHERE order_date IS NULL
   OR ship_date IS NULL
   OR ship_date < order_date;
   
  SELECT
    order_id,
    order_date,
    ship_date,
    shipping_days
FROM sales_data
WHERE ship_date < order_date;

#----------Check unusually long shipping times---------
SELECT
    COUNT(*) AS long_shipping_rows
FROM sales_data
WHERE shipping_days > 30;

#------Check category inconsistencies---
SELECT
    LOWER(TRIM(category)) AS standardized_category,
    COUNT(DISTINCT category) AS category_versions
FROM sales_data
GROUP BY LOWER(TRIM(category))
HAVING COUNT(DISTINCT category) > 1;

#-----View Categories----------
SELECT
    category,
    COUNT(*) AS row_count
FROM sales_data
GROUP BY category
ORDER BY category;

SELECT
    sub_category,
    COUNT(*) AS row_count
FROM sales_data
GROUP BY sub_category
ORDER BY sub_category;

#---------------Check Customer Name Inconsistencies----
SELECT
    customer_id,
    COUNT(DISTINCT customer_name) AS customer_name_count
FROM sales_data
GROUP BY customer_id
HAVING COUNT(DISTINCT customer_name) > 1;

/****---SELECTcustomer_id,
    customer_name
FROM sales_data
WHERE customer_id IN (
    SELECT customer_id
    FROM sales_data
    GROUP BY customer_id
    HAVING COUNT(DISTINCT customer_name) > 1
)
ORDER BY customer_id;***/

#---- Check product inconsistencies----

SELECT
    product_id,
    COUNT(DISTINCT product_name) AS product_name_count
FROM sales_data
GROUP BY product_id
HAVING COUNT(DISTINCT product_name) > 1;

#---Final summary ---
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_ids,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_ids,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_ids,
    SUM(CASE WHEN quantity IS NULL OR quantity <= 0 THEN 1 ELSE 0 END) AS invalid_quantities,
    SUM(CASE WHEN sales IS NULL OR sales <= 0 THEN 1 ELSE 0 END) AS invalid_sales,
    SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) AS null_profit,
    SUM(CASE WHEN discount IS NULL OR discount < 0 OR discount > 1 THEN 1 ELSE 0 END) AS invalid_discounts,
    SUM(CASE WHEN ship_date < order_date THEN 1 ELSE 0 END) AS invalid_dates,
    SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) AS negative_profit_rows
FROM sales_data;

SELECT *
FROM sales_data
WHERE sales IS NULL
   OR sales <= 0;

SELECT
    order_id,
    order_date,
    ship_date,
    shipping_days
FROM sales_data
WHERE ship_date < order_date
LIMIT 20;


SELECT
    MIN(profit) AS minimum_profit,
    MAX(profit) AS maximum_profit,
    COUNT(*) AS negative_profit_rows
FROM sales_data
WHERE profit < 0;



