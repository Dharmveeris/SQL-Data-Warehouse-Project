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


-- ==================================================================
-- Checking 'silver.crm_cust_info'
-- ==================================================================
-- Check for NULLs and Duplicates
-- Expectation: no result
SELECT 
	cst_id,
	COUNT(*) no_of_times
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 or cst_id IS NULL

-- Checking for Unwanted Spaces
-- Check for all string columns
-- Expectation:  No result
SELECT 
	cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname) 


-- Data standardisation & normalisation
-- Removing same names and changing them to full name
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info

SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info



-- ==================================================================
-- Checking 'silver.crm_cust_info'
-- ==================================================================
-- Checking for NULLs and duplicates
-- Expectation: No Result
SELECT 
	prd_id,
	COUNT(*) no_of_times
FROM silver.crm_prd_info 
GROUP BY prd_id
HAVING COUNT(*) >1 OR prd_id IS NULL

-- checking for unwanted spaces 
-- Expectation: No Result
SELECT 
	prd_line
FROM silver.crm_prd_info
WHERE prd_line != TRIM(prd_line)


-- Check for NULLs or Negative values in cost
-- Expectation: No Result
SELECT 
	prd_cost
FROM silver.crm_prd_info 
WHERE prd_cost < 0 OR prd_cost IS NULL


-- Data Normalisation & Standardisation
SELECT DISTINCT prd_line
FROM silver.crm_prd_info


-- Check for invalid product history date (Start_date > End_date)
-- Expectation: No Result
SELECT 
	prd_start_dt,
	prd_end_dt
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt



-- ==================================================================
-- Checking 'silver.crm_cust_info'
-- ==================================================================

-- Check for invalid dates
-- Expectation : No invalid dates 
SELECT 
	NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE 
	sls_order_dt < 0 
	OR LEN(sls_order_dt) != 8 
	OR sls_order_dt > 20500101 
	OR sls_order_dt < 19500101

	
-- Check for Invalid Date Orders (Order Date > Shipping/Due Dates)
-- Expectation: No Results
SELECT 
	*
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt


-- Check Data Consistency: Sales = Quantity * Price
-- Expectation: No Results
SELECT 
	sls_sales ,
	sls_quantity ,
	sls_price
FROM silver.crm_sales_details
WHERE 
	sls_sales != sls_quantity * sls_price 
	OR sls_sales < 0
	OR sls_quantity < 0
	OR sls_price < 0 
	OR sls_sales IS NULL
	OR sls_quantity IS NULL
	OR sls_price IS NULL


-- ==================================================================
-- Checking 'silver.crm_cust_info'
-- ==================================================================

-- Checking for NULLs and duplicates
-- Expectation: No Result
SELECT 
	cid,
	COUNT(*) no_of_times
FROM silver.erp_cust_az12
GROUP BY cid
HAVING COUNT(*) >1

-- Checking for invalid customer
-- Expectation: No Result
SELECT 
	bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE() OR bdate < DATEADD(YEAR, -100  ,GETDATE()) -- over 100yrs old
-- we only fixed future born customers only & not too old here, so we will see customer over 100yrs in data

-- Data standardisation & consistency
SELECT DISTINCT gen
FROM silver.erp_cust_az12


-- ==================================================================
-- Checking 'silver.crm_cust_info'
-- ==================================================================


-- Checking for NULLs and duplicates
-- Expectation: No Result
SELECT 
	cid,
	COUNT(*) no_of_times
FROM silver.erp_loc_a101
GROUP BY cid 
HAVING COUNT(*) > 1


-- Data standardisation & consistency
SELECT DISTINCT cntry
FROM silver.erp_loc_a101


-- ==================================================================
-- Checking 'silver.crm_cust_info'
-- ==================================================================

-- Checking for NULLs and duplicates
-- Expectation: No Result
SELECT 
	id,
	COUNT(*) no_of_times
FROM silver.erp_px_cat_g1v2
GROUP BY id
HAVING COUNT(*) > 1


-- Check for Unwanted Spaces 
SELECT 
	cat,
	subcat,
	maintenance
FROM silver.erp_px_cat_g1v2
WHERE 
	cat != TRIM(cat) OR 
	subcat != TRIM(subcat) OR
	maintenance != TRIM(maintenance)


-- Data standardisation & consistency
SELECT DISTINCT maintenance
FROM silver.erp_px_cat_g1v2

