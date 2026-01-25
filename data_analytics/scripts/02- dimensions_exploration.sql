/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/
-- exlpore all countries
SELECT DISTINCT country FROM gold.dim_customers;

-- explore hierarchy of products
SELECT DISTINCT category, subcategory,product_name FROM gold.dim_products
ORDER BY 1,2,3;
