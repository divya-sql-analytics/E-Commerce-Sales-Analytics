USE ecommerce_sales_analytics;
/**OVERALL BUSINESS PERFORMANCE**/

#---Total Sales, Total Profit, Total Orders, and Total Quantity-----
SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity
FROM sales_data;

#--------Average Order Value (AOV)---------
SELECT
    ROUND(SUM(sales) / COUNT(DISTINCT order_id),2) AS average_order_value
FROM sales_data;

#------What is the Overall Profit Margin-------
SELECT
    ROUND(
        (SUM(profit) / SUM(sales)) * 100,2) AS profit_margin_percentage
FROM sales_data;

#--------How do Sales and Profit change by Year---
SELECT
    YEAR(order_date) AS order_year,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data
GROUP BY YEAR(order_date)
ORDER BY order_year;

/**SALES AND PROFIT TREND ANALYSIS**/

#--------Sales and Profit change Month by Month------
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS month_number,
    MONTHNAME(order_date) AS month_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    MONTHNAME(order_date)
ORDER BY
    order_year,
    month_number;
    
/**YEAR-OVER-YEAR GROWTH**/

#--------YEAR-OVER-YEAR GROWTH-------------
WITH yearly_sales AS (
    SELECT
        YEAR(order_date) AS order_year,
        SUM(sales) AS total_sales
    FROM sales_data
    GROUP BY YEAR(order_date)
)
SELECT
    order_year,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(
        (
            (total_sales - LAG(total_sales) OVER (ORDER BY order_year))
            / LAG(total_sales) OVER (ORDER BY order_year)
        ) * 100,
        2
    ) AS yoy_sales_growth_percentage
FROM yearly_sales;

/**CATEGORY PERFORMANCE**/
#------------Categories Generate the Most Sales and Profit-------
SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data
GROUP BY category
ORDER BY total_sales DESC;

#--------Which Sub-Categories Perform Best--------
  SELECT
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data
GROUP BY sub_category
ORDER BY total_profit DESC;

#----Top 10 Products by Sales------
SELECT
    product_name,
    ROUND(SUM(sales), 2) AS total_sales
FROM sales_data
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

/**PRODUCT PERFORMANCE**/
#------------Top 10 Products by Profit------
SELECT
    product_name,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;

#--------Which Products Are Loss-Making---------
SELECT
    product_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;

/**DISCOUNT ANALYSIS**/
#-------Does Higher Discount Affect Profit-----
SELECT
    discount,
    COUNT(*) AS total_transactions,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data
GROUP BY discount
ORDER BY discount;

/**REGIONAL PERFORMANCE**/
#-----Which Regions Generate the Most Sales and Profit--------
SELECT
    region,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        (SUM(profit) / SUM(sales)) * 100,
        2
    ) AS profit_margin_percentage
FROM sales_data
GROUP BY region
ORDER BY total_sales DESC;

#------Which States Generate the Most Sales----------
SELECT
    state,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data
GROUP BY state
ORDER BY total_sales DESC
LIMIT 10;

/**CUSTOMER PERFORMANCE**/
#------Who Are the Top 10 Customers-----
SELECT
    customer_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM sales_data
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;
#----------Which Customer Segment Performs Best-------
SELECT
    segment,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM sales_data
GROUP BY segment
ORDER BY total_sales DESC;

/**SHIPPING ANALYSIS**/
#------Which Shipping Mode Is Used Most-----
SELECT
    ship_mode,
    COUNT(*) AS total_transactions,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data
GROUP BY ship_mode
ORDER BY total_transactions DESC;

