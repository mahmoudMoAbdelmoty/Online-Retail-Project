{{
    config(alias = 'fact_cancelled_orders')
}}
select  
    invoice_no,
    stock_code,
    quantity,
    unit_price,
    abs(quantity*unit_price) as total_sales,
    invoice_date,
    customer_id
from    
    {{ref("staging_online_retail")}}
where left(invoice_no, 1) = 'C'
