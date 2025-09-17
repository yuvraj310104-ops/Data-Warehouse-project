create view gold.report_customers as
with base_query as
-- Base quey : Retrives core columns from tables
(
select
f.order_number,
f.product_key,
f.order_date,
f.sales,
f.quantity,
c.customer_key,
c.customer_number,
concat(c.first_name , ' ' ,c.last_name) as customer_name,
datediff(year, birth_date , getdate()) as age
from gold.fact_sales f
left join gold.dim_customers c
on c.customer_key = f.customer_key
where order_date is not null
)
	,customer_agreegation as(
	---Customer Agreegations : summarizes key metrices at the customer level 
select 
customer_key,
customer_number,
customer_name,
age,
count(distinct order_number) as total_orders,
sum(sales) as total_sales,
sum(quantity) as total_quantity,
count(distinct product_key) as total_products,
max(order_date) as last_order,
datediff(month,min(order_date), max(order_date)) as lifespam
from base_query
group by 
	customer_key,
	customer_number,
	customer_name,
	age
)
select
	customer_key,
	customer_number,
	customer_name,
	age,
	case
		when age < 20 then 'Under 20'
		when age between 20 and 29 then '20-29'
		when age between 30 and 39 then '30-39'
		when age between 40 and 50 then '20-29'
		else '50 and Above'
	end as age_group,
	case 
			when lifespam > =12 and total_sales > 5000 then 'VIP'
			when lifespam > =12 and total_sales <= 5000 then 'Regular'
			else 'New'
	end as customer_segment,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	last_order,
	datediff(month,last_order, getdate()) recency,
	lifespam,
	--compute average order value (AVO)
	case 
		when total_sales = 0  then 0
		else total_sales / total_orders
	End  as avg_order_value,
	--compute average montly spend (AMS)
	case 
		when lifespam = 0  then total_sales
		else total_sales/lifespam
		end as avg_montly_spend
from customer_agreegation
