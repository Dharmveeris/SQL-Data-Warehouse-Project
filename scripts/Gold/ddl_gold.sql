/*
=============================================================================
DDL Script : Create Gold Views
=============================================================================
Script purpose: 
		This script creates views for the gold layer in Data Warehouse.
	    This layer contains the views for the final Dimension and Fact tables (Star Schema).

        Each view here contains data that is cleaned, transformed and enriched from silver layer
		to produce business ready data.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/


-- =======================================================
-- Create Dimension : gold.dim_customers
-- =======================================================

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
	DROP VIEW gold.dim_customers
GO


CREATE VIEW gold.dim_customers AS 
SELECT
	ROW_NUMBER() OVER(ORDER BY cc.cst_id ) AS customer_key, -- Surrogate key
	cc.cst_id                              AS customer_id,
	cc.cst_key                             AS customer_number ,
	cc.cst_firstname                       AS first_name,
	cc.cst_lastname                        AS last_time,
	el.cntry                               AS country,
	cc.cst_marital_status                  AS martial_status,
	CASE 
		WHEN cc.cst_gndr != 'n/a' THEN cc.cst_gndr -- CRM is primary source for gender
		ELSE COALESCE(ce.gen, 'n/a')			   -- Fallback to erp data 
	END                                    AS gender,
	ce.bdate                               AS birthdate,
	cc.cst_create_date                     AS create_date
FROM silver.crm_cust_info AS cc
LEFT JOIN silver.erp_cust_az12 AS ce
ON ce.cid = cc.cst_key
LEFT JOIN silver.erp_loc_a101 AS el
ON el.cid = cc.cst_key
GO


-- =======================================================
-- Create Dimension : gold.dim_products
-- =======================================================

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
	DROP VIEW gold.dim_products
GO

CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER(ORDER BY cp.prd_start_dt,cp.prd_id) AS product_key, --Surrogate_key
	cp.prd_id            AS product_id,
	cp.prd_key           As product_number,
	cp.prd_nm            AS product_name,
	cp.cat_id            AS category_id,
	ep.cat               AS category,
	ep.subcat            AS subcategory,
	ep.maintenance       AS maintenance,
	cp.prd_line          AS product_line,
	cp.prd_cost          AS product_cost,
	cp.prd_start_dt      AS start_date
FROM silver.crm_prd_info cp
LEFT JOIN silver.erp_px_cat_g1v2 ep
ON cp.cat_id = ep.id
WHERE cp.prd_end_dt IS NULL --Filter out all historical data
GO


-- =======================================================
-- Create fact table : fact_sales
-- =======================================================

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
	DROP VIEW gold.fact_sales
GO

CREATE VIEW gold.fact_sales AS 
SELECT 
	sls_ord_num       AS order_number,
	dp.product_key    AS product_key,
	dc.customer_key   AS customer_key,
	sls_order_dt      AS order_date,
	sls_ship_dt       AS ship_date,
	sls_due_dt        AS due_date,
	sls_sales         AS sales,
	sls_quantity      AS quantity,
	sls_price         AS price
FROM silver.crm_sales_details cs
LEFT JOIN gold.dim_customers dc
ON dc.customer_id = cs.sls_cust_id
LEFT JOIN gold.dim_products dp
ON dp.product_number = cs.sls_prd_key
GO
