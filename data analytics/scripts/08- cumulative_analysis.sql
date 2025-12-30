/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Date Functions: YEAR(),DATETRUNC()
    - Window Functions: SUM() OVER(), AVG() OVER()
    - Aggregate Functions: SUM(), AVG()
===============================================================================
*/

-- Calculate the total sales per month (Running Total)
 
SELECT 
    order_date,
    total_sales,
    SUM(total_sales) OVER(  ORDER BY order_date) AS running_total
FROM (
SELECT 
    DATETRUNC(month,order_date) AS order_date,
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month,order_date)
)t;

-- 3-Month Moving Average Price per Year (Rolling Average)

SELECT 
    order_date,
    total_sales,
    SUM(total_sales) OVER(  ORDER BY order_date) AS running_total,
    avg_price,
    AVG(avg_price) OVER( PARTITION BY YEAR(order_date) ORDER BY order_date ROWS  BETWEEN 2 PRECEDING AND CURRENT ROW ) AS moving_avg_price_3months
FROM (
SELECT 
    DATETRUNC(month,order_date) AS order_date,
    SUM(sales_amount) AS total_sales,
    AVG(price) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month,order_date)
)t


