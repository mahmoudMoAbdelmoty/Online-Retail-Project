{{
    config(alias = 'online_retail_cleaned')
}}
select 
    invoiceno as invoice_no,
    upper(stockcode) as stock_code,
    lower(description) as description,
    quantity,
    invoicedate as invoice_date,
    unitprice as unit_price,
    customerid as customer_id,
    country
from {{source('raw', 'ONLINE_RETAIL')}}
where invoiceno is not NULL and 
(stockcode is not null and REGEXP_LIKE(StockCode, '^[0-9]{5}[A-Za-z]?$')) and
-- quantity
((quantity <=0 and left(invoiceno, 1) = 'C') or (quantity > 0 and left(invoiceno, 1) != 'C'))
-- unit price
and (unitprice > 0) and
-- customer
not (customerid is null and left(invoiceno, 1) = 'C') and
--description
NOT REGEXP_LIKE(lower(description), '.*(\\?|null|n/a|missing|broken|damage|damaged|adjustment|dotcom adjust|found|wrong barcode|thrown away|unsaleable, destroyed|wrongly coded|check|incorrect).*')
and country != 'Unspecified'