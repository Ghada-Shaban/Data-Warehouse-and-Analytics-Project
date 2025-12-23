/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.crm_cust_info'
-- ====================================================================

-- Check for nulls or duplicates in the PK
-- Expectation : No Result
SELECT
	cst_id,
	count(*)
FROM silver.crm_cust_info
Group by cst_id
HAVING COUNT(*)>1 OR cst_id IS NULL;
---------------------------------------

-- Check unwanted spaces
-- Expectation : No Result
SELECT 
	cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname!= TRIM(cst_firstname);

SELECT 
	cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname!= TRIM(cst_lastname);

SELECT 
	cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr!= TRIM(cst_gndr);
---------------------------------------

-- Check Data Standardization & Consistency

SELECT DISTINCT  
	cst_gndr
FROM silver.crm_cust_info;
---------------------------------------

SELECT DISTINCT  
	cst_marital_status
FROM silver.crm_cust_info;
---------------------------------------
-- ====================================================================
-- Checking 'silver.crm_prd_info'
-- ====================================================================

-- Check for nulls or duplicates in the PK
-- Expectation : No Result
SELECT
prd_id,
count(*)
FROM silver.crm_prd_info
Group by prd_id
HAVING COUNT(*)>1 OR prd_id IS NULL ;
---------------------------------------

-- Check unwanted spaces
-- Expectation : No Result
SELECT 
	prd_nm
FROM silver.crm_prd_info
WHERE prd_nm!= TRIM(prd_nm);
---------------------------------------

-- Check Nulls OR Negative Numbers
-- Expectation : No Result
SELECT 
	prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;
---------------------------------------


-- Check Data Standardization & Consistency
-- Expectation : No Result

SELECT DISTINCT  
	prd_line
FROM silver.crm_prd_info;
---------------------------------------

-- Check For Invalid Date Orders
-- Expectation : No Result

SELECT 
	* 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;
---------------------------------------
