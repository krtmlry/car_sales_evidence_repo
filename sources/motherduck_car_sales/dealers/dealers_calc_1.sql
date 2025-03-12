with brands as (
    select
        distinct brand
    from dim_facts_records.car_sales_records
),
    dealers as (
        select
            distinct dealer_name
        from dim_facts_records.car_sales_records
),
    dealers_brands as (
        select
            a.dealer_name,
            b.brand
        from dealers as a
        cross join brands as b        
        order by a.dealer_name asc, b.brand asc
),
    dealers_sales_brands as (
        select
            dealer_name,
            brand,
            sum(qty_sold)::int as total_units_sold,
            sum(total_price_usd) as total_sales,
            sum(total_profit_usd) as total_profit
        from dim_facts_records.car_sales_records
        group by 1,2
        order by dealer_name asc, brand asc        
)

select
    a.dealer_name,
    a.brand,
    coalesce(b.total_units_sold,0)::int as total_units_sold,
    coalesce(b.total_sales,0) as total_sales,
    coalesce(b.total_profit,0) as total_profit
from dealers_brands as a
left join dealers_sales_brands as b
on a.dealer_name = b.dealer_name
and a.brand = b.brand
order by a.dealer_name asc,  b.total_units_sold desc