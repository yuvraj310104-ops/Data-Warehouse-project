<h1 align="center" id="title">SQL Data Warehouse Project</h1>

<p id="description">This project demonstrates the design of a Data Warehouse pipeline using the Bronze → Silver → Gold layered architecture. The workflow ingests raw data (CSV files) cleans and transforms it and finally structures it into a star schema for reporting and analytics. 

🗂️ Data Layers 

🔹 Bronze Layer (Raw Data) Stores raw CRM &amp; ERP data as ingested from CSV files. Implemented with staging tables (bronze.*). Loaded using BULK INSERT via stored procedure bronze.load_bronze. Data Sources: CRM: Customers Products Sales Details ERP: Customer Info Locations Product Categories 

🔸 Silver Layer (Cleansed &amp; Standardized) Applies data cleaning deduplication and standardization. Ensures data quality for further transformations. Loaded using stored procedure silver.load_silver. Key Transformations: Customers: Deduplicate by keeping latest records standardize gender &amp; marital status. Products: Extract category IDs map product lines calculate product end dates. Sales: Fix invalid dates validate sales = quantity × price correct missing prices. ERP Data: Normalize IDs clean country codes validate birthdates standardize gender. 

🟡 Gold Layer (Analytics-Ready) Implements a Star Schema for BI &amp; reporting. Built using SQL views (gold.*). Schema Components: dim_customers → Combines CRM &amp; ERP data into a customer dimension. dim_product → Enriched product dimension with category &amp; attributes. fact_sales → Central fact table linking products &amp; customers with sales measures. 🛠️ Tools &amp; Technologies SQL Server (T-SQL) → ETL &amp; Data Modeling draw.io → Data Flow Diagrams DW Architecture Integration Model Notion → Project Management task tracking documentation Data Warehouse Architecture → Bronze Silver Gold layers 

📊 Outcome Built an end-to-end ETL pipeline: raw files → clean tables → star schema. Delivered analytics-ready data for BI tools (Power BI Tableau). Improved data quality consistency and usability. Demonstrates expertise in SQL ETL design Data Modeling and DW architecture.</p>
