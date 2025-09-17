---Performance Analysis
----Analyze the  yearly performance of products by comparing each product's 
--sales to both its average sales performance and the pervious year's sales.
with yearly_product_sales AS (
select 
year(fc.order_date) as Order_Year,
dp.product_name,
sum(fc.sales) Current_sales
from gold.fact_sales fc
left join gold.dim_product dp
on fc.product_key = dp.product_key
where order_date is not null
group by year(fc.order_date),dp.product_name
)
select 
Order_Year,
product_name,
Current_sales,
avg(Current_sales) over(partition by product_name) avg_sales,
Current_sales - avg(Current_sales) over(partition by product_name) as diff_avg,
case 
	when Current_sales - avg(Current_sales) over(partition by product_name) > 0  then 'Above Avg'
	when Current_sales - avg(Current_sales) over(partition by product_name) < 0 then 'Below Avg'
	else 'Avg'
End  Avg_change,
lag(current_sales) over(partition by product_name order by order_year)as prev_sales,
Current_sales - lag(current_sales) over(partition by product_name order by order_year) as diff_prev,
case 
	when Current_sales - lag(current_sales) over(partition by product_name order by order_year) > 0  then 'Incrase'
	when Current_sales - lag(current_sales) over(partition by product_name order by order_year) < 0 then 'Decrease'
	else 'No change'
End  py_change
from yearly_product_sales
order by product_name,Order_Year
