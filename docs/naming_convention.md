# **Naming Conventions**
This document outlines the naming convention for Schemas,
tables, views, columns and other objects in this project.


## Table of contents
1. [General Principles](#general-principles)
2. [Table Naming Convention](#table-naming-convention)
   - [Bronze Rules](#bronze-rules) 
   - [Silver Rules](#silver-rules)
   - [Gold Rules](#gold-rules)
3. [Column Naming Convention](#column-naimng-convention)
4. [Stored procedure](#stored-procedure)
---


## **General Principles**
- **Naming convention** - Use snake_case, with lowercase letters and "_"(Underscore) to sepearte words.
- **Language** - English.
- **Avoid Reserved Words** - Avoid using SQL reserved words for objects name  .


## **Table Naming Convention**

### **Bronze Rules** 
- All names must start with source system name, and tables names must there original names witout renaming.
- **`<sourcesystem>_<entity>`**
  - `<source_system_name>`: Name of the source sys (e.g., `crm`, `erp`).
  - `<entity>`: Exact table name from the data source.
  - Example: `crm_Customer_info` customer info from crm data source  

### Silver Rules
- Same as Bronze rules
- All names must start with source system name, and tables names must there original names witout renaming.
- **`<sourcesystem>_<entity>`**
  - `<source_system_name>`: Name of the source sys (e.g., `crm`, `erp`).
  - `<entity>`: Exact table name from the data source.
  - Example: `crm_Customer_info` customer info from crm data source  

### Gold rules
- All names must be meaningfull and business aligned names for table, starting with the category prefix. 
- **`<category>_<entity>`:**
   - `<category>` - Describes the role of the table as dim(dimension) and fact(fact Table).
   - `<entity>` - Name of the column aligned with business domain (`customer`, `sales`, etc).
   - Example: fact_sales, dim_customers.

#### **Glossory of Category Patterns**

| Pattern      | Meaning                   |                     Example(s)   |
|--------------|--------------------------|------------------|
|`dim_`| Dimension Table|`dim_customer`, `dim_products`|
|`fact_`|Fact Table|`fact_sales`,| 
|`report_`|Report Table|`report_customer`,`report_montly_sales`|


## Column Naming Convention

### Surrogate Keys:

- All Primary Keys in Dimension table must use `_key` suffix at the end.
- `<tablename_key>`:
  - `<tablename>` - Refers to the name of the table the key belong to.
  - `<key>` - suffix indicating it's a surrogate column.
  - Example : `customer_key` surrogate ley in the `<dim_category>` table.

### Techinical Column:

- All techinical column must start with `dwh_` followed by descriptive name indicating it's purpose.
- `dwh_<columnname>`:
  - `dwh`- Prefix to indicate this column is generated during Data Warehouse processing.
  - `<columnname>` - Descriptive name indicating column purpose.
  - Example : `dwh_load_date` -> System generated column which stores the date when the data was recorded.

## **Stored Procedure**

- All stored procedure used to load data must follow the pattern.
 - `load_<layer>`:
   - `<layer>` - Represents the layer being loaded such as `bronze`, `silver`, or `gold`.
   - Example: 
     - `load_bronze`- Stored procedure to load Bronze Layer.
     - `load_gold`- Stored procedure to load Gold Layer.































