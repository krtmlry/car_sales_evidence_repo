with months as (
    select
        unnest([1,2,3,4,5,6,7,8,9,10,11,12]) as date_month,
        unnest([
            'January','February','March','April',
            'May','June','July','August',
            'September','October','November','December'
        ]) as date_month_name
),
dealers as (
    select
        distinct(dealer_name) as dealer_name
    from dim_facts_records.car_sales_records
),
 dealer_months_combination as (
     select
        a.dealer_name,
        b.date_month,
        b.date_month_name
     from dealers as a 
     cross join months as b
     order by a.dealer_name asc, b.date_month asc
 ),
dealer_sales as (
    select
        dealer_name,
        date_month,
        date_month_name,
        sum(qty_sold) as total_units_sold,
        sum(total_price_usd) as total_sales,
        sum(total_profit_usd) as total_profit
    from dim_facts_records.car_sales_records
    group by 1,2,3
)

select
    a.dealer_name,
    a.date_month,
    a.date_month_name,
    coalesce(b.total_units_sold, 0)::int as total_units_sold,
    coalesce(b.total_sales, 0)::float as total_sales,
    coalesce(b.total_profit, 0)::float as total_profit
from dealer_months_combination as a
left join dealer_sales as b on
    a.dealer_name = b.dealer_name
    and a.date_month = b.date_month
order by a.dealer_name asc, a.date_month asc