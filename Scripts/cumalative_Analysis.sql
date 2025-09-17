---cumalative Analysis

--calculate the total sales per month
--and the running total of sales over time

select
Month_Sales,
Total_Sales,
sum(Total_Sales) over( order by Month_Sales) as running_total_sales
from
(
select 
datetrunc(Year,order_date) as Month_Sales,
sum(sales) as Total_Sales
from gold.fact_sales
where order_date is not null
group by datetrunc(Year,order_date)
) t;
