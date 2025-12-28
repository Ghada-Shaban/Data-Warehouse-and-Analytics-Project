/*
===============================================================================
Dates Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/
-- find the date of the first and the last order and how many years the sales are available
SELECT
	MIN(order_date) AS first_order,
	MAX(order_date) AS last_order,
	DATEDIFF(year,MIN(order_date),MAX(order_date)) AS order_range_years
FROM gold.fact_sales;

-- find the oldest and youngest customer

SELECT 
    MIN(birthdate) AS oldest_customer,
	DATEDIFF(year,MIN(birthdate),GETDATE()) AS youngest_age,
	MAX(birthdate) AS youngest_customer,
	DATEDIFF(year,MAX(birthdate),GETDATE()) AS oldest_age
FROM gold.dim_customers;
