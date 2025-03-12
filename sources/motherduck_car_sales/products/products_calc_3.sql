select
    brand,
    model,
    segment,
    engine_size_l,
    fuel_type,
    unit_price_usd,
    unit_profit_usd,        
    sum(qty_sold) as total_units_sold,
    sum(total_price_usd) as total_sales,
    sum(total_profit_usd) as total_profit
from dim_facts_records.car_sales_records
group by 1,2,3,4,5,6,7