with brands_models as (
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
    dealers as (
    select
        distinct dealer_name
    from dim_facts_records.car_sales_records       
),
    brands_models_dealers as (
    select
        a.dealer_name,
        b.brand,
        b.model,
        b.segment,
        b.engine_size_l,
        b.fuel_type,
        b.unit_price_usd,
        b.unit_profit_usd
    from dealers as a
    cross join brands_models as b
    order by a.dealer_name asc, b.brand asc
),
    sales as (
    select
        dealer_name,
        brand,
        model,
        segment,
        engine_size_l,
        fuel_type,
        unit_price_usd,
        unit_profit_usd,
        sum(qty_sold)::int as total_units_sold,
        sum(total_price_usd) as total_sales,
        sum(total_profit_usd) as total_profit
    from dim_facts_records.car_sales_records
    group by 1,2,3,4,5,6,7,8
    order by dealer_name asc, brand asc

)
    select
        a.dealer_name,
        a.brand,
        a.model,
        a.segment,
        a.engine_size_l,
        a.fuel_type,
        a.unit_price_usd,
        a.unit_profit_usd,
        coalesce(b.total_units_sold,0)::int as total_units_sold,
        coalesce(b.total_sales,0) as total_sales,
        coalesce(b.total_profit,0) as total_profit
    from brands_models_dealers as a
    left join sales as b
        on a.dealer_name = b.dealer_name
        and a.brand = b.brand
        and a.model = b.model
        and a.segment = b.segment
        and a.engine_size_l = b.engine_size_l
        and a.fuel_type = b.fuel_type
        and a.unit_price_usd = b.unit_price_usd
        and a.unit_profit_usd = b.unit_profit_usd
    order by a.dealer_name asc, a.brand asc