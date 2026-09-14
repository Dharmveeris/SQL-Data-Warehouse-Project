/*
==============================================================================================
Create Database and schemas
==============================================================================================
Purpose:
		Creating database DataWarehouse. Checking if it already exists to drop it and recreating it.
		While also adding schemas bronze, silver, and gold.

WARNING: Running this script will lead to permanent deletion of the database if it already exists.
		 Make sure you have proper backup for the said database.

*/

USE master;
GO

-- Drop if the datbase already exists

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN 
	ALTER DATABASE DataWarehouse SET SINGLE_USER ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END
GO


-- Create DataWarehouse database

CREATE DATABASE DataWarehouse;
GO


-- USE DataWarehouse Database

USE DataWarehouse;


-- CREATE Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

