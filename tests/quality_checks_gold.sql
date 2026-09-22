/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ==================================================================
-- Checking 'gold.dim_customers'
-- ==================================================================
-- Checking for NULLs or Duplicates
-- Expectation: No Result 
SELECT 
	customer_key,
	COUNT(*) no_of_times
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1


-- ==================================================================
-- Checking 'gold.dim_products'
-- ==================================================================
-- Checking for NULLs or Duplicates
-- Expectation: No Result 
SELECT 
	product_key,
	COUNT(*) no_of_times
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) >1


-- ==================================================================
-- Checking 'gold.dim_customers'
-- ==================================================================
--Check the data model connectivity between the fact and dimension table
SELECT *
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON dc.customer_key = fs.customer_key
LEFT JOIN gold.dim_products dp
ON dp.product_key = fs.product_key
WHERE dp.product_key IS NULL OR dc.customer_key IS NULL 

