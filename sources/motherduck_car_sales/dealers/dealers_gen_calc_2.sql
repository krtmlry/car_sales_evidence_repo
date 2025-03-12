with dow_names as (
    select
        unnest([0,1,2,3,4,5,6]) as date_dow,
        unnest([
            'Sunday','Monday','Tuesday','Wednesday',
            'Thursday','Friday','Saturday'
        ]) as date_dow_name
),
dealers as (
    select
        distinct(dealer_name) as dealer_name
    from dim_facts_records.car_sales_records
),
 dealers_dow_combination as (
     select
        a.dealer_name,
        b.date_dow,
        b.date_dow_name
     from dealers as a 
     cross join dow_names as b
     order by a.dealer_name asc, b.date_dow asc
 ),
dealer_sales as (
    select
        dealer_name,
        date_dow,
        date_dow_name,
        sum(qty_sold) as total_units_sold,
        sum(total_price_usd) as total_sales,
        sum(total_profit_usd) as total_profit
    from dim_facts_records.car_sales_records
    group by 1,2,3
)

select
    a.dealer_name,
    a.date_dow,
    a.date_dow_name,
    coalesce(b.total_units_sold, 0)::int as total_units_sold,
    coalesce(b.total_sales, 0)::float as total_sales,
    coalesce(b.total_profit, 0)::float as total_profit
from dealers_dow_combination as a
left join dealer_sales as b on
    a.dealer_name = b.dealer_name
    and a.date_dow = b.date_dow
order by a.dealer_name asc, a.date_dow asc