/* Description

This stored procedure (silver.load_silver) transforms and loads data from the Bronze Layer into the Silver Layer of the data warehouse. Key steps:

Customer Data (CRM): Deduplicates records, standardizes marital status and gender, and keeps the latest entry.

Product Data (CRM): Extracts category IDs, standardizes product line values, sets missing costs to 0, and calculates product end dates.

Sales Data (CRM): Cleans invalid/malformed dates, fixes incorrect sales values, and ensures consistent price calculations.

Customer Data (ERP): Normalizes customer IDs, validates birthdates, and standardizes gender values.

Location Data (ERP): Cleans country codes, expands abbreviations, and handles missing values.

Product Categories (ERP): Moves as-is into Silver for further transformations.

This process cleans, standardizes, and structures data to make it analytics-ready for the Gold Layer.*/



exec silver.load_silver;

create or alter procedure silver.load_silver as
Begin

	print '>>> Truncating table: silver.crm_cust_info'
	Truncate table silver.crm_cust_info
	print '>>Inserting data into silver.crm_cust_info'
	insert into silver.crm_cust_info (
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_material_status,
		cst_gender,
		cst_create_date)


	select
	cst_id,
	cst_key,
	trim(cst_firstname) as cst_firstname,
	trim(cst_lastname) as cst_lastname ,
	case when upper(trim(cst_material_status)) = 'S' then 'Single'
		 when upper(trim(cst_material_status)) = 'M' then 'Married'
		 else 'n/a'
	end cst_material_status,

	 case when upper(trim(cst_gender)) = 'F' then 'Female'
		 when upper(trim(cst_gender)) = 'M' then 'Male'
		 else 'n/a'
	end cst_gender,
	cst_create_date
	from(
	select *,ROW_NUMBER() over(partition by cst_id order by cst_create_date desc) flag_last
	from 
	bronze.crm_cust_info
	where cst_id is not null)t where flag_last =1 
	;


	print '>>> Truncating table: silver.crm_prd_info'
	Truncate table silver.crm_prd_info
	print '>>Inserting data into silver.crm_prd_info'
	insert into silver.crm_prd_info(

		prd_id,
		cat_id ,
		prd_key ,
		prd_nm ,
		prd_cost,
		prd_line ,
		prd_start_dt ,
		prd_end_dt
	)

	SELECT  [prd_id]
		  ,
		  replace(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
		  substring(prd_key,7,len(prd_key)) as prd_key
		  ,[prd_nm]
		  ,isnull([prd_cost],0) as [prd_cost],
		  case upper(trim([prd_line]))
			   when  'M' then 'Mountain'
			   when  'R' then 'Road'
			   when   'S' then 'Other sales'
			   when   'T' then 'Touring'
			   Else 'n/a'
		End as prd_line
		  ,[prd_start_dt],
		 DATEADD(DAY, -1, 
		LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)
	) AS prd_end_dt

	  FROM [DataWarehouse].[bronze].[crm_prd_info]

	print '>>> Truncating table: silver.crm_sales_details'
	Truncate table silver.crm_sales_details
	print '>>Inserting data into silver.crm_sales_details'
	insert into silver.crm_sales_details (

		sls_ord_num,
		sls_prd_key ,
		sls_cust_id,
		sls_order_dt ,
		sls_ship_dt ,
		sls_due_dt  ,
		sls_sales,
		sls_quantity,
		sls_price
	)


	select  
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		case when sls_order_dt = 0 or len(sls_order_dt)!=8 then null
			else cast(cast(sls_order_dt as varchar) as date)
		end as sls_order_dt,
		case when sls_ship_dt = 0 or len(sls_ship_dt)!=8 then null
			else cast(cast(sls_ship_dt as varchar) as date)
		end as sls_ship_dt,
		case when sls_due_dt = 0 or len(sls_due_dt)!=8 then null
			else cast(cast(sls_due_dt as varchar) as date)
		end as sls_due_dt,
		case when sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity * abs(sls_price)
		then sls_quantity * abs(sls_price)
		else sls_sales
		end as sls_sales,
		sls_quantity,
		case when sls_price is null or sls_price <=0 
		then sls_sales / nullif(sls_quantity,0)
		else sls_price
		end as sls_price
	from bronze.crm_sales_details

	print '>>> Truncating table: silver.erp_cust_az12'
	Truncate table silver.erp_cust_az12
	print '>>Inserting data into silver.erp_cust_az12'
	insert into silver.erp_cust_az12 (
		cid,
		bdate,
		gen
	)

	select 
	case when cid like 'NAS%' then substring(cid, 4 , len(cid))
			else cid
			end as cid,
	case when  bdate > getdate() then null
			else bdate
			end as bdate,
	case when upper(trim(gen)) in ('F' ,'FEMALE') then 'Female'
		when upper(trim(gen)) in ('M' ,'MALE') then 'Male'
	else 'n/a'
	end as gen
	from bronze.erp_cust_az12;


	print '>>> Truncating table:silver.erp_loc_a101'
	Truncate table silver.erp_loc_a101
	print '>>Inserting data into silver.erp_loc_a101'
	insert into silver.erp_loc_a101 (
		cid,
		cntry

	)


	select replace(cid,'-','') as cid, 
	case when trim(cntry) = 'DE' then 'Germany'
		 when trim(cntry) IN ('US' , 'USA') then 'United States'
		 when trim(cntry) = '' or cntry is null then 'n/a'
		 else cntry
	end as cntry
	from bronze.erp_loc_a101


	print '>>> Truncating table:silver.erp_px_cat_giv2'
	Truncate table silver.erp_px_cat_giv2
	print '>>Inserting data into silver.erp_px_cat_giv2'
	insert into silver.erp_px_cat_giv2 (
		id,
		cat,
		subcat,
		maintenance

	)
	select * from bronze.erp_px_cat_giv2
END


 
