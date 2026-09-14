/*
=================================================================================
Stored Procedure: Load Bronze Data (Source -> Bronze)
=================================================================================
Script Purpose:
	This script loads data from source into 'bronze' schema that exists in CSV files.
	It performs two functions:
	1. Truncate the tables before inserting the data.
	2. Bulk Insert the data from csv files into tables

Parameter:
	None.
	This stored procedure doesn't use any parameter to return any values.

To Invoke :
EXEC bronze.load_bronze;

*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	Declare @start_time DATETIME, @end_time DATETIME, 
			@Session_start_time DATETIME, @Session_end_time DATETIME
	BEGIN TRY
		SET @Session_start_time = GETDATE()
		PRINT'===================================================='
		PRINT'Loading Bronze Layer'
		PRINT'===================================================='

		PRINT'----------------------------------------------------'
		PRINT'Loading CRM Table'
		PRINT'----------------------------------------------------'

		SET @start_time = GETDATE() 
		PRINT'>> Truncating table: bronze.crm_cust_info.'
		TRUNCATE TABLE bronze.crm_cust_info
		PRINT'>> Bulk Data insert into table: bronze.crm_cust_info.'
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\budy\Desktop\veer\Datawithbaara\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);
		SET @end_time = GETDATE()
		PRINT'Loading time: ' + CAST(DATEDIFF(second, @start_time, @End_time) AS NVARCHAR) + 'seconds'
		PRINT'----------------------------------------------------'


		SET @start_time = GETDATE() 
		PRINT'>> Truncating table: bronze.crm_prd_info.'
		TRUNCATE TABLE bronze.crm_prd_info
		PRINT'>> Bulk Data insert into table: bronze.crm_prd_info.'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\budy\Desktop\veer\Datawithbaara\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);
		SET @end_time = GETDATE()
		PRINT'Loading time: ' + CAST(DATEDIFF(second, @start_time, @End_time) AS NVARCHAR) + 'seconds'
		PRINT'----------------------------------------------------'

		SET @start_time = GETDATE() 
		PRINT'>> Truncating table: bronze.crm_sales_details.'
		TRUNCATE TABLE bronze.crm_sales_details
		PRINT'>> Bulk Data insert into table: bronze.crm_sales_details.'
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\budy\Desktop\veer\Datawithbaara\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);
		SET @end_time = GETDATE()
		PRINT'Loading time: ' + CAST(DATEDIFF(second, @start_time, @End_time) AS NVARCHAR) + 'seconds'
		PRINT''



		PRINT'----------------------------------------------------'
		PRINT'Loading ERP Table'
		PRINT'----------------------------------------------------'

		SET @start_time = GETDATE() 
		PRINT'>> Truncating table: bronze.erp_cust_az12.'
		TRUNCATE TABLE bronze.erp_cust_az12
		PRINT'>> Bulk Data insert into table: bronze.erp_cust_az12.'
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\budy\Desktop\veer\Datawithbaara\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);
		SET @end_time = GETDATE()
		PRINT'Loading time: ' + CAST(DATEDIFF(second, @start_time, @End_time) AS NVARCHAR) + 'seconds'
		PRINT'----------------------------------------------------'

		SET @start_time = GETDATE() 
		PRINT'>> Truncating table: bronze.erp_loc_a101.'
		TRUNCATE TABLE bronze.erp_loc_a101
		PRINT'>> Bulk Data insert into table: bronze.erp_loc_a101.'
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\budy\Desktop\veer\Datawithbaara\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);
		SET @end_time = GETDATE()
		PRINT'Loading time: ' + CAST(DATEDIFF(second, @start_time, @End_time) AS NVARCHAR) + 'seconds'
		PRINT'----------------------------------------------------'
	
		SET @start_time = GETDATE() 
		PRINT'>> Truncating table: bronze.erp_px_cat_g1v2.'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2
		PRINT'>> Bulk Data insert into table: bronze.erp_px_cat_g1v2.'
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\budy\Desktop\veer\Datawithbaara\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);
		SET @end_time = GETDATE()
		PRINT'Loading time: ' + CAST(DATEDIFF(second, @start_time, @End_time) AS NVARCHAR) + 'seconds'
		PRINT'----------------------------------------------------'
		SET @Session_end_time = GETDATE()
		PRINT'Total time: ' + CAST(DATEDIFF(second, @session_start_time, @session_End_time) AS NVARCHAR) + 'seconds'
		PRINT'----------------------------------------------------'
	END TRY
	BEGIN CATCH
		PRINT' An ERROR has ocurred!'
		PRINT'Error message: ' + ERROR_MESSAGE()
		PRINT'Error number: ' + CAST(ERROR_Number() AS NVARCHAR)
		PRINT'Error state: ' + CAST(ERROR_STATE() AS NVARCHAR)
	END CATCH
END

