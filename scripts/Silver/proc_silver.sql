/*
=============================================================================
Stored procedure : Load Silver Layer (Bronze to Silver)
=============================================================================
Script Purpose:
	This stored procedure performs ETL(Extract, Transfrom and Load) process to 
	insert data into 'silver' schema from 'bronze' schema.
	It performs following function:
		1. Truncates the table 
		2. Insert tranformed and cleaned data from Bronze to Silver tables

Parameter:
	None.
	This stored procedure does not accept any parameter or return any values.

TO USE : 
	EXEC silver.load_silver

*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN

	DECLARE @start_time DATETIME, @end_time DATETIME, 
			@session_start_time DATETIME, @session_end_time DATETIME

	BEGIN TRY

	SET @session_start_time = GETDATE()
	PRINT'============================================================'
	PRINT'Loading Silver layer'
	PRINT'============================================================'

	PRINT'------------------------------------------------------------'
	PRINT'Loading CRM table'
	PRINT'------------------------------------------------------------'

	-- Loading crm_cust_info
	SET @start_time = GETDATE()
	PRINT'>> TRUNCATE TABLE: silver.crm_cust_info'
	TRUNCATE TABLE silver.crm_cust_info
	PRINT'>> Inserting cleaned data into silver.crm_cust_info'
	INSERT INTO silver.crm_cust_info(
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
			)
	SELECT 
		cst_id,
		cst_key,
		TRIM(cst_firstname) AS cst_firstname , -- Removing extra spaces
		TRIM(cst_lastname) AS cst_lastname,
		CASE
			WHEN UPPER(cst_marital_status) = 'M' THEN 'Married'
			WHEN UPPER(cst_marital_status) = 'S' THEN 'Single'
			ELSE 'n/a'
		END AS cst_marital_status, -- Data Standardisation
		CASE
			WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
			WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
			ELSE 'n/a'
		END AS cst_gndr,  -- Data Standardisation
		cst_create_date
	FROM (
	SELECT 
	*,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) flag_list
	FROM bronze.crm_cust_info
	)T
	WHERE flag_list = 1 AND cst_id IS NOT NULL   -- Removing duplicates and nulls
	SET @end_time = GETDATE()
	PRINT'Loading time: ' + CAST(DATEDIFF(Second, @end_time, @start_time) as NVARCHAR) + 'seconds';
	PRINT'-------------------------'


	-- Loading crm_prd_info
	SET @start_time = GETDATE()
	PRINT'>> TRUNCATE TABLE: silver.crm_prd_info'
	TRUNCATE TABLE silver.crm_prd_info
	PRINT'>> Inserting cleaned data into silver.crm_prd_info'
	INSERT INTO silver.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt)
	SELECT 
		prd_id,
		REPLACE(SUBSTRING(prd_key,1,5), '-' , '_') AS cat_id, -- Extract category id
		SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,  -- Extract product id 
		prd_nm,
		ISNULL(prd_cost, 0) AS prd_cost, --  Removing nulls
		CASE UPPER(TRIM(prd_line))
			WHEN 'M' THEN 'Mountain'
			WHEN 'S' THEN 'Other sales'
			WHEN 'R' THEN 'Road'
			WHEN 'T' THEN 'Tourist'
			ELSE 'n/a'
		END AS prd_line, -- Data Standardisation
		prd_start_dt,
		DATEADD(DAY, -1, LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt))  
		AS prd_end_dt -- Calculating end date as one day before the next start date
	FROM bronze.crm_prd_info
	SET @end_time = GETDATE()
	PRINT'Loading time: ' + CAST(DATEDIFF(Second, @end_time, @start_time) as NVARCHAR) + 'seconds';
	PRINT'-------------------------'

	
	-- Loading crm_sales_details
	SET @start_time = GETDATE()
	PRINT'>> TRUNCATE TABLE: silver.crm_sales_details'
	TRUNCATE TABLE silver.crm_sales_details
	PRINT'>> Inserting cleaned data into silver.crm_sales_details'
	INSERT INTO silver.crm_sales_details(
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price)
	SELECT 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE 
			WHEN sls_order_dt = 0 OR LEN(sls_order_dt) !=8 THEN NULL
			ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
		END sls_order_dt,
		CASE 
			WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) !=8 THEN NULL
			ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
		END sls_ship_dt,
		CASE 
			WHEN sls_due_dt = 0 OR LEN(sls_due_dt) !=8 THEN NULL
			ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
		END sls_due_dt,
		CASE 
		WHEN sls_sales IS NULL OR sls_sales < 1  OR sls_sales != sls_quantity * ABS(sls_price)
			THEN (sls_quantity * ABS(sls_price))
		ELSE sls_sales
		END sls_sales,  -- Recalculate sales if original value is missing or incorrect
		sls_quantity,
		CASE
		WHEN sls_price IS NULL OR sls_price < 1 THEN (CAST(sls_sales AS float)/sls_quantity)
		ELSE sls_price
		END sls_price -- Derive price if original value is invalid
	FROM bronze.crm_sales_details
	SET @end_time = GETDATE()
	PRINT'Loading time: ' + CAST(DATEDIFF(Second, @end_time, @start_time) as NVARCHAR) + 'seconds';
	PRINT'-------------------------'

	
	-- Loading erp_cust_az12
	SET @start_time = GETDATE()
	PRINT'------------------------------------------------------------'
	PRINT'Loading ERP table'
	PRINT'------------------------------------------------------------'

	PRINT'>> TRUNCATE TABLE: silver.erp_cust_az12'
	TRUNCATE TABLE silver.erp_cust_az12
	PRINT'>> Inserting cleaned data into silver.erp_cust_az12'
	INSERT INTO silver.erp_cust_az12(
		cid,
		bdate,
		gen)

	SELECT
		CASE 
			WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
			ELSE cid 
		END cid, -- Remove 'NAS' prefix if present
		CASE
			WHEN bdate > GETDATE() THEN NULL
			ELSE bdate
		END AS bdate, -- Set future birthdates to NULL
		CASE
			WHEN TRIM(gen) IN ('M', 'Male') THEN 'Male'
			WHEN TRIM(gen) IN ('F', 'Female') THEN 'Female'
			ELSE 'n/a' 
		END gen  -- Normalize gender values and handle unknown cases
	FROM bronze.erp_cust_az12
	WHERE bdate < GETDATE()
	SET @end_time = GETDATE()
	PRINT'Loading time: ' + CAST(DATEDIFF(Second, @end_time, @start_time) as NVARCHAR) + 'seconds';
	PRINT'-------------------------'

	
	-- Loading erp_loc_a101
	SET @start_time = GETDATE()
	PRINT'>> TRUNCATE TABLE: silver.erp_loc_a101'
	TRUNCATE TABLE silver.erp_loc_a101
	PRINT'>> Inserting cleaned data into silver.erp_loc_a101'
	INSERT INTO silver.erp_loc_a101(
			cid,
			cntry)
	SELECT 
		REPLACE(cid, '-', '') cid,
		CASE 
			WHEN TRIM(cntry) = 'DE' THEN 'Germany'
			WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
			WHEN TRIM(cntry) IS NULL OR TRIM(cntry) = '' THEN 'n/a'
			ELSE TRIM(cntry)
		END cntry -- Normalize and Handle missing or blank country codes
	FROM bronze.erp_loc_a101
	SET @end_time = GETDATE()
	PRINT'Loading time: ' + CAST(DATEDIFF(Second, @end_time, @start_time) as NVARCHAR) + 'seconds';
	PRINT'-------------------------'

	
	-- Loading erp_px_cat_g1v2
	SET @start_time = GETDATE()
	PRINT'>> TRUNCATE TABLE: silver.erp_px_cat_g1v2'
	TRUNCATE TABLE silver.erp_px_cat_g1v2
	PRINT'>> Inserting cleaned data into silver.erp_px_cat_g1v2'
	INSERT INTO silver.erp_px_cat_g1v2(
		id,
		cat,
		subcat,
		maintenance
		)
	SELECT 
		id,
		cat,
		subcat,
		maintenance
	FROM bronze.erp_px_cat_g1v2
	SET @end_time = GETDATE()
	PRINT'Loading time: ' + CAST(DATEDIFF(Second, @end_time, @start_time) as NVARCHAR) + 'seconds';
	PRINT'-------------------------'
	
	
	SET @session_end_time = GETDATE()
	PRINT'============================================================'
	PRINT'Total Loading time: ' + CAST(DATEDIFF(Second, @session_end_time, @session_start_time) as NVARCHAR) + 'seconds';
	PRINT'============================================================'
	
	END TRY
	BEGIN CATCH
		PRINT'An ERROR has ocurred!'
		PRINT'Error message: ' + ERROR_MESSAGE()
		PRINT'Error number: ' + CAST(ERROR_Number() AS NVARCHAR)
		PRINT'Error state: ' + CAST(ERROR_STATE() AS NVARCHAR)
	END CATCH

END


