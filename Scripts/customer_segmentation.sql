/*Group customers into three segments based on their spending behaviour :
-VIP : at least 12 months of history and spending more than 5,000 er
-regular : at least 12 months of history but spending 5,000 or less er,
- new : lifespam less than 12 months
- and find the total number of customers in each group
*/
with customer_spending as (
select
c.customer_key,
sum(f.sales) as total_spending,
min(f.order_date) as first_order,
max(f.order_date) as last_order,
datediff(month,min(order_date), max(order_date)) as lifespam
from gold.fact_sales f
left join gold.dim_customers c
on f.customer_key = c.customer_key
group by c.customer_key
)
select
customer_segment,
count(customer_key) as total_customers
from(
	select 
		customer_key,
		total_spending,
		lifespam,
		case 
			when lifespam > =12 and total_spending > 5000 then 'VIP'
			when lifespam > =12 and total_spending <= 5000 then 'Regular'
			else 'New'
	end customer_segment
	from customer_spending
)t
group by customer_segment
order by total_customers desc
