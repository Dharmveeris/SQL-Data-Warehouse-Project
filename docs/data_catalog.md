# Data Catalog for Gold Layer

## Overview
This Gold Layer represenets the business level data, structured for analysis and reporting purpose. It consists of **dimension tables** and **fact tables** for business metrics.

### 1. **gold.dim_customers**
- **Purpose :** It stores customer's details enriched with demographic and geographic data.
- **Columns:**

|Name|Data Type|Discription|
|----|----|-----------|
|customer_key| INT |Surrogate key uniquely assigned to each customer in the dimension table.|
|customer_id | INT |System generated id assgned to each customer in the database|
|customer_number | NVARCHAR(50) |Alphanumeric identifier assigned to each customer for refrencing and tracking.|
|first_name | NVARCHAR(50) |Customer's first name|
|last_name | NVARCHAR(50) |Customer's last or family name |
|country | NVARCHAR(50) |Customer's residence country|
|martial_status | NVARCHAR(50)  |Customer's maartial Status(Married or Single)|
|gender | NVARCHAR(50) |Customer's gender(Male, Female Or n/a)|
|birthdate | DATE |Date on which customer was born in format YYYY-MM-DD(e.g, 1976-01-18)|
|create_date | DATE |Date on which customer's data was recorded in system|


### 2.**gold.dim_products**
- **Purpose:** Provides information about products and it's atributes
- **Columns:**

|Name|Data Type|Discription|
|----|----|-----------|
|product_key | INT | Surrogate key uniquely assigned to each product in the dimension table. |
|product_id | INT | System generated id for each product in the database|
|product_number | INT | Alphanumeric key assigned to each product helps in categorisation and iventory|
|product_name | NVARCHAR(50) | 	Descriptive name of the product, including key details such as type, color, and size|
|category_id | INT | A unique identifier for the product's category, linking to its high-level classification|
|category | NVARCHER(50) | 	The broader classification of the product (e.g., Bikes, Components) to group related items.|
|subcategory | NVARCHER(50) | A more detailed classification of the product within the category, such as product type. |
|mainteinence_required | NVARCHER(50) | Indicates whether the product requires maintenance (e.g., 'Yes', 'No') |
|product_line | NVARCHER(50) | The specific product line or series to which the product belongs (e.g., Road, Mountain). |
|cost | INT | The cost or base price of the product, measured in monetary units.|
|start_date | DATE | The date when the product became available for sale or use, stored in the datbase|


### 3.gold.fact_sales
- **Purpose:** Stores all Transactional data for analytical purpose.
- **Columns:**

|Name|Data Type|Description|
|----|----|-----------|
|order_number| NVARCHAR(50) | Alphanumeric id assigned to each order by system.|
|product_key| INT | Surrogate key linking order to product table. |
|customer_key| INT | Surrogate key linking order to customer table. |
|order_date| DATE | Date when the order was placed. |
|ship_date| DATE | Date when the order was delivered. |
|due_date| DATE | Date till the payment was due. |
|sales| INT | Total sales amount for the line item for a order. |
|quantity| INT | Number of item for the line item  for a order. |
|price| INT | Price of the per unit product for the line item  .  |


























