/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
     TOP
    - Window Ranking Function:ROW_NUMBER()
    - Aggregate Function: SUM()
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/
-- Which 5 products Generating the Highest Revenue?
  -- Ranking Without Using Window Functions
  SELECT TOP 5
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;


  -- Ranking Using Window Functions
 SELECT * FROM 
  (SELECT 
	p.product_name,
	SUM(f.sales_amount) AS total_revenue,
	ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount ) DESC) ranking
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name)t
WHERE ranking <= 5;


  -- What are the 5 worst-performing products in terms of sales?
  SELECT TOP 5
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue;

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
	c.customer_key,
	CONCAT(c.first_name,' ',c.last_name) AS customer_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.product_key = c.customer_key
GROUP BY 
     c.customer_key,
     CONCAT(c.first_name,' ',c.last_name)
ORDER BY total_revenue DESC;

-- another way
SELECT * FROM 
  (SELECT 
	c.customer_key,
	CONCAT(c.first_name,' ',c.last_name) AS customer_name,
	ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount ) DESC) ranking
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.product_key = c.customer_key
GROUP BY 
     c.customer_key,
     CONCAT(c.first_name,' ',c.last_name))t
WHERE ranking <= 10;


-- The 3 customers with the fewest orders placed
SELECT TOP 3
	c.customer_key,
	CONCAT(c.first_name,' ',c.last_name) AS customer_name,
	COUNT(DISTINCT order_number) AS number_of_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.product_key = c.customer_key
GROUP BY 
     c.customer_key,
     CONCAT(c.first_name,' ',c.last_name)
ORDER BY number_of_orders;
