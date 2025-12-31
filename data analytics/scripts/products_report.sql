/*
===============================================================================
Products Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, line ,and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
IF OBJECT_ID('gold.products_report', 'V') IS NOT NULL
    DROP VIEW gold.products_report;
GO

CREATE VIEW gold.products_report AS
WITH main_query AS (
SELECT 
    f.order_number,
    f.order_date,
    f.customer_key,
	f.quantity,
    f.price,
	f.sales_amount,
    p.product_key,
    p.product_name,
    p.category,
    p.subcategory,
    p.product_line,
    p.cost
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL)

, product_aggregations AS (

SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    product_line,
    cost,
    COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT customer_key) AS total_customers,
    MAX(order_date) AS last_sale_date,
    DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
    ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
    FROM main_query
    GROUP BY 
        product_key,
        product_name,
        category,
        subcategory,
        product_line,
        cost
)

SELECT
        product_key,
        product_name,
        category,
        subcategory,
        product_line,
        cost,

        CASE
		    WHEN total_sales > 50000 THEN 'High-Performer'
		    WHEN total_sales >= 10000 THEN 'Mid-Range'
		    ELSE 'Low-Performer'
	    END AS product_segment,

        last_sale_date,
        lifespan,
        DATEDIFF(month, last_sale_date,GETDATE()) AS recency,
	    total_orders,
	    total_sales,
	    total_quantity,
	    total_customers,
	    avg_selling_price,

        CASE WHEN total_sales = 0 THEN 0
	         ELSE total_sales / total_orders
        END AS avg_order_revenue,

        CASE WHEN lifespan = 0 THEN total_sales
	             ELSE total_sales / lifespan
        END AS avg_monthly_revenue

FROM product_aggregations
