USE ecommerce_sales_analytics;

#---Total Sales, Total Profit, Total Orders, and Total Quantity-----
SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity
FROM sales_data;

#-------Average Order Value (AOV)-------
SELECT
    COUNT(*) AS total_rows,
    COUNT(profit) AS non_null_profit_count,
    SUM(profit) AS total_profit,
    AVG(profit) AS avg_profit,
    MIN(profit) AS min_profit,
    MAX(profit) AS max_profit,
    CAST(SUM(profit) AS DECIMAL(12,2)) AS profit_sum_decimal
FROM sales_data;


SELECT
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sales_data' 
  AND COLUMN_NAME = 'profit';
  
  SELECT
    row_id,
    profit,
    CAST(profit AS DECIMAL(12,2)) AS profit_as_number
FROM sales_data
LIMIT 20;

SELECT profit
FROM sales_data
LIMIT 10;

UPDATE sales_data
SET profit = REPLACE(profit, '₹', '');
UPDATE sales_data
SET profit = REPLACE(profit, ',', '');
UPDATE sales_data
SET profit = TRIM(profit);

SELECT profit
FROM sales_data
LIMIT 20;

ALTER TABLE sales_data
MODIFY COLUMN profit DECIMAL(12,2);
DESCRIBE sales_data;

SELECT
    SUM(profit) AS total_profit,
    MIN(profit) AS lowest_profit,
    MAX(profit) AS highest_profit
FROM sales_data;




SELECT
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'sales_data'
  AND COLUMN_NAME = 'profit';