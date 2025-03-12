select
    dealer_country as country,
    dealer_city as city,
    sum(qty_sold)::int as total_units_sold,
    sum(total_price_usd) as total_sales,
    sum(total_profit_usd) as total_profit
from dim_facts_records.car_sales_records
group by 1,2
order by country asc, city asc