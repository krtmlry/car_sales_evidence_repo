-- Returns total units sold, total sales, total profit by dow
-- unnest() is used because there are days without units sold or sales and it will cause that dow to be missing/skipped once placed in a visual

with dow_names as (
    select 
        unnest([0,1,2,3,4,5,6]) AS date_dow,
        unnest(['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']) as date_dow_name
),
    dow_sales as (
        select
            date_dow,
            date_dow_name,
            sum(qty_sold)::INT AS total_units_sold,
            sum(total_price_usd) AS total_sales,
            sum(total_profit_usd) AS total_profit
        from dim_facts_records.car_sales_records
        group by 1,2
)
    select
        a.date_dow,
        a.date_dow_name,
        coalesce(b.total_units_sold,0) as total_units_sold,
        coalesce(b.total_sales,0) as total_sales,
        coalesce(b.total_profit,0) as total_profit
    from dow_names as a
    left join dow_sales as b
        on a.date_dow = b.date_dow
    order by a.date_dow asc