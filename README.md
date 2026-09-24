# **Building the Data Warehouse (Data Engineering)**

### Objective
Develop a modern data warehouse using SQL to consolidate sales data, enabling analytical reporting and informed decision making.

#### Specifications
- **Data Source**: Import data from two source systems (CRM and ERP) Provided as CSV files.
- **Data Quality**: Clean and resolve data quality issues prior to analysis.
- **Integration**: Combine both source systems into one single , user-friendly  data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only, historization of data is not required.
- **Documentation**: Provide clear documentation for the data model to support the business stakeholders and analytical teams.

![data_architecture](docs/data_architecture.png)

### Repository structure
- **datasets/** — Source CSV files from the CRM and ERP systems, used as raw input for the pipeline.
- **docs/** — Architecture diagram, data flow diagram, and data catalog documenting the gold-layer tables.
- **scripts/** — All SQL used to build the warehouse, organized by Medallion layer (bronze → silver → gold).
- **tests/** — Scripts that check data quality after each load (e.g. null checks, duplicate checks).

### BI: Analytics and Reporting (Data Analysis)
#### Objective
Develop SQL based analytics to deliver insights into.
- **Customer Behavior**
- **Product Performance**
- **Sales Trends**
These insights empower stakeholders with key business metrics, enabling strategic decision-making.


## License
This project is licensed under [MIT License](LICENSE). You are free to use modify and share this project with proper attribution.

### About this project
- This project was built by following 'Data with Baraa' SQL course to learn Medallion architecture and SQL Server ETL practices hands-on.
- All code was written and debugged independently.

## About Me
Hi there! I'm **Dharmveer**. I am starting my journey in analytics with this project.

