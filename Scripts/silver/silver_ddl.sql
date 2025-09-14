if OBJECT_ID('silver.crm_cust_info', 'U') is not null
	drop table silver.crm_cust_info;
Create table silver.crm_cust_info (
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname varchar(50),
	cst_material_status nvarchar(50),
	cst_gender nvarchar(50),
	cst_create_date Date,
	dwh_create_date datetime2 default getdate()
);
if OBJECT_ID('silver.crm_prd_info', 'U') is not null
	drop table silver.crm_prd_info;
create table silver.crm_prd_info(

	prd_id int,
	cat_id nvarchar(50),
	prd_key varchar(25),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line varchar(15),
	prd_start_dt date,
	prd_end_dt date,
	dwh_create_date datetime2 default getdate()
);

if OBJECT_ID('silver.crm_sales_details', 'U') is not null
	drop table silver.crm_sales_details;
create table silver.crm_sales_details (

	sls_ord_num varchar(15),
	sls_prd_key varchar(15),
	sls_cust_id int,
	sls_order_dt Date,
	sls_ship_dt Date,
	sls_due_dt Date ,
	sls_sales bigint,
	sls_quantity int,
	sls_price bigint,
	dwh_create_date datetime2 default getdate()

);
if OBJECT_ID('silver.erp_cust_az12', 'U') is not null
	drop table silver.erp_cust_az12;
create table silver.erp_cust_az12 (

	cid varchar(20),
	bdate date,
	gen varchar(10),
	dwh_create_date datetime2 default getdate()
);

go
if OBJECT_ID('silver.erp_loc_a101', 'U') is not null
	drop table silver.erp_loc_a101;
create table silver.erp_loc_a101 (

	cid nvarchar(20),
	cntry Varchar(20),
	dwh_create_date datetime2 default getdate()

);

go
if OBJECT_ID('silver.erp_px_cat_giv2', 'U') is not null
	drop table silver.erp_px_cat_giv2;
create table silver.erp_px_cat_giv2 (

	id varchar(10),
	cat varchar(20),
	subcat varchar(30),
	maintenance Varchar(10),
    dwh_create_date datetime2 default getdate()
);

go



