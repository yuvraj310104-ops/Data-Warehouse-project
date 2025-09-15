/*Description

This SQL script creates sample bronze layer tables for a CRM and ERP system. 
It includes customer, product, sales, location, and category data structures. The script ensures old versions of the tables are dropped if they exist, 
then recreates them with appropriate schema definitions for use in a data warehouse or ETL pipeline.*/






if OBJECT_ID('bronze.crm_cust_info', 'U') is not null
	drop table bronze.crm_cust_info;
Create table bronze.crm_cust_info (
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname varchar(50),
	cst_material_status nvarchar(50),
	cst_gender nvarchar(50),
	cst_create_date Date
);
if OBJECT_ID('bronze.crm_prd_info', 'U') is not null
	drop table bronze.crm_prd_info;
create table bronze.crm_prd_info(

	prd_id int,
	prd_key varchar(25),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line varchar(5),
	prd_start_dt date,
	prd_end_dt date
);

if OBJECT_ID('bronze.crm_sales_details', 'U') is not null
	drop table bronze.crm_sales_details;
create table bronze.crm_sales_details (

	sls_ord_num varchar(15),
	sls_prd_key varchar(15),
	sls_cust_id int,
	sls_order_dt bigint,
	sls_ship_dt bigint,
	sls_due_dt bigint ,
	sls_sales bigint,
	sls_quantity int,
	sls_price bigint

);
if OBJECT_ID('bronze.erp_cust_az12', 'U') is not null
	drop table bronze.erp_cust_az12;
create table bronze.erp_cust_az12 (

	cid varchar(20),
	bdate date,
	gen varchar(10)
);

go
if OBJECT_ID('bronze.erp_loc_a101', 'U') is not null
	drop table bronze.erp_loc_a101;
create table bronze.erp_loc_a101 (

	cid nvarchar(20),
	cntry Varchar(20)

);

go
if OBJECT_ID('bronze.erp_px_cat_giv2', 'U') is not null
	drop table bronze.erp_px_cat_giv2;
create table bronze.erp_px_cat_giv2 (

	id varchar(10),
	cat varchar(20),
	subcat varchar(30),
	maintenance Varchar(10)
);

go



drop table bronze.crm_cust_info;
