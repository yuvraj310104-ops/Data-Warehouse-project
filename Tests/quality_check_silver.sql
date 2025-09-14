-- check for nulls & duplicates in primary key

select 
prd_id,
count(*)
from silver.crm_prd_info
group by prd_id
having count(*) >1 or prd_id is null;

---check for unwanted spaces
select *
from silver.crm_sales_details
where sls_ord_num != trim(sls_ord_num);

---data standardization & consistency
select distinct cntry
from silver.erp_loc_a101


---check for negative numbers and nulls--

select prd_cost
from silver.crm_prd_info
where prd_cost <0 or prd_cost is null


-- check for invaliad dates
select 
nullif(sls_due_dt,0)
from silver.crm_sales_details
where sls_due_dt <=0 or len(sls_due_dt)!=8;


-- check for invalid date orders

select
*
from silver.crm_sales_details
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt;


--- check the consistency : between sales,quantity and price 
--->> sales = quantity * price
---->> values must not be null , zero or negative.

select distinct
sls_sales,
sls_quantity,
sls_price
from silver.crm_sales_details
where sls_sales != sls_quantity * sls_price 
or sls_sales is null or sls_quantity is null or sls_price is null 
or sls_sales <=0 or sls_quantity <=0 or sls_price <=0 
order by sls_sales , sls_quantity , sls_price



----identify out of range dates
select distinct 
bdate
from silver.erp_cust_az12
where bdate < '1924-01-01' or bdate > getdate()
