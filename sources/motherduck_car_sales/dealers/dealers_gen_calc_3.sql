select
    date,
    sum(qty_sold) as total_units_sold,
    sum(total_price_usd) as total_sales,
    sum(total_profit_usd) as total_profit
from dim_facts_records.car_sales_records
group by 1
order by date asc