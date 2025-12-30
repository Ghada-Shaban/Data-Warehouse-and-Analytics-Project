/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: YEAR(), DATETRUNC(), FORMAT(),DATEPART()
    - Aggregate Functions: SUM(), COUNT()
===============================================================================
*/
-- YEAR()
SELECT 
YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

-- FORMAT()
SELECT 
    FORMAT(order_date,'yyyy-MMMM') AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date,'yyyy-MMMM')
ORDER BY FORMAT(order_date,'yyyy-MMMM');

-- DATETRUNC()
SELECT 
    DATETRUNC(month,order_date) AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month,order_date)
ORDER BY DATETRUNC(month,order_date);

-- DATEPART()
SELECT
    DATEPART(year,order_date) AS order_year,
    DATEPART(month,order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY  DATEPART(year,order_date),
          DATEPART(month,order_date)
ORDER BY  DATEPART(year,order_date),
          DATEPART(month,order_date)
