with months as (
    select
        unnest([1,2,3,4,5,6,7,8,9,10,11,12]) as date_month,
        unnest([
            'January','February','March','April',
            'May','June','July','August',
            'September','October','November','December'
        ]) as date_month_name
),
products as (
    select
        distinct brand,
        model,
        segment,
        engine_size_l,
        fuel_type,
        unit_price_usd,
        unit_profit_usd
    from dim_facts_records.car_sales_records
    order by brand asc
),
 products_months_combination as (
     select
        a.brand,
        a.model,
        a.segment,
        a.engine_size_l,
        a.fuel_type,
        a.unit_price_usd,
        a.unit_profit_usd,
        b.date_month,
        b.date_month_name
     from products as a 
     cross join months as b
     order by a.brand asc, b.date_month asc
 ),
product_sales as (
    select
        brand,
        model,
        segment,
        engine_size_l,
        fuel_type,
        unit_price_usd,
        unit_profit_usd,
        date_month,
        date_month_name,        
        sum(qty_sold) as total_units_sold,
        sum(total_price_usd) as total_sales,
        sum(total_profit_usd) as total_profit
    from dim_facts_records.car_sales_records
    group by 1,2,3,4,5,6,7,8,9
)

select
    a.brand,
    a.model,
    a.segment,
    a.engine_size_l,
    a.fuel_type,
    a.unit_price_usd,
    a.unit_profit_usd,
    a.date_month,
    a.date_month_name,
    coalesce(b.total_units_sold, 0)::int as total_units_sold,
    coalesce(b.total_sales, 0)::float as total_sales,
    coalesce(b.total_profit, 0)::float as total_profit
from products_months_combination as a
left join product_sales as b on
    a.brand = b.brand
    and a.model = b.model
    and a.segment = b.segment
    and a.engine_size_l = b.engine_size_l
    and a.fuel_type = b.fuel_type
    and a.unit_price_usd = b.unit_price_usd
    and a.unit_profit_usd = b.unit_profit_usd
    and a.date_month = b.date_month
order by a.brand asc, a.date_month asc