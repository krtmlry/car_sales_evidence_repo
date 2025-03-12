-- Returns total units sold, total sales, total profit by month
-- unnest() is used to ensure that all months are included.
with months as (
    select
        unnest([1,2,3,4,5,6,7,8,9,10,11,12]) as date_month,
        unnest(['January','February','March','April',
                'May','June','July','August',
                'September','October','November','December']) as date_month_name
),
    monthly_sales as (
    select
        date_month,
        date_month_name,        
        sum(qty_sold)::int as total_units_sold,
        sum(total_price_usd) as total_sales,
        sum(total_profit_usd) as total_profit
    from dim_facts_records.car_sales_records
    group by 1,2
    order by date_month asc
)

select
    a.date_month,
    a.date_month_name,        
    coalesce(b.total_units_sold,0)::int as total_units_sold,
    coalesce(b.total_sales,0) as total_sales,
    coalesce(b.total_profit,0) as total_profit
from months as a
left join monthly_sales as b
on a.date_month = b.date_month
order by a.date_month asc