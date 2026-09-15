USE ecommerce_sales_analytics;
select SUM(sales) AS total_sales from sales_data;
select SUM(profit) AS total_profit from sales_data;
select count(DISTINCT order_id) AS total_orders from sales_data;
select count(distinct Customer_ID) as toatl_customers from sales_data;
select sum(Quantity) as total_quantity from sales_data;
select SUM(sales)/COUNT(DISTINCT order_id) AS Average_order_value from sales_data;
select ( sum(profit)/sum(sales)) *100 AS profit_margin_percentage from sales_data;

SELECT
    SUM(sales) AS Total_Sales,
    SUM(profit) AS Total_Profit,
    COUNT(DISTINCT order_id) AS Total_Orders,
    COUNT(DISTINCT customer_id) AS Total_Customers,
    SUM(quantity) AS Total_Quantity,
    SUM(sales) / COUNT(DISTINCT order_id) AS Average_Order_Value,
    (SUM(profit) / SUM(sales)) * 100 AS Profit_Margin_Percentage
FROM sales_data;