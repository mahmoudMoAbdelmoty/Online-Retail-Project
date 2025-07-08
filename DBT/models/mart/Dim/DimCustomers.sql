{{
    config(alias = 'dim_customers')
}}
with rank as(
    select  
        customer_id,
        country,
        ROW_NUMBER() OVER(
            PARTITION BY customer_id
            ORDER BY invoice_date
        ) as rnk
    from 
        {{source('staging', 'online_retail_cleaned')}}
)
select 
    customer_id,
    country
from
    rank
where rnk = 1
