{{
    config(alias = 'dim_products')
}}
with rank as(
    select  
        stock_code,
        description,
        ROW_NUMBER() OVER (
            PARTITION BY stock_code
            ORDER BY description desc  -- or use logic to prefer "retrospot"
        ) AS rnk
    from {{source('staging', 'online_retail_cleaned')}}
)
select 
    stock_code,
    description
from rank
where rnk = 1