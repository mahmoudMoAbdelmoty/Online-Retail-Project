--Step 1: Create Retail Warehouse
CREATE OR REPLACE DATABASE retail_wh;

-- Create Schemas Raw, stag, mart
CREATE OR REPLACE SCHEMA raw;
create or replace schema staging;
CREATE OR REPLACE SCHEMA mart;

-- Step 2: Create Retail Stage on Public Schema
CREATE OR REPLACE STAGE public.retail_stage;

-- Step 3: Upload files using(snowSql or UI)

-- STEP 4: Create target table
CREATE OR REPLACE TABLE raw.online_retail(
  InvoiceNo STRING,
  StockCode STRING,
  Description STRING,
  Quantity INT,
  InvoiceDate TIMESTAMP_NTZ,
  UnitPrice FLOAT,
  CustomerID INT,
  Country STRING
);

-- Step 5: Create File Format for CSV
CREATE OR REPLACE FILE FORMAT public.csv_format
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
  FIELD_DELIMITER = ','
  NULL_IF = ('', 'NULL')
  TIMESTAMP_FORMAT = 'MM/DD/YYYY HH24:MI'
  REPLACE_INVALID_CHARACTERS = TRUE;

-- list all file in retail stage
list @public.retail_stage;

-- step 6: Load Raw Data from retail_stage to Online_retail table in schema Raw
COPY INTO raw.online_retail
FROM @public.retail_stage/OnlineRetail.csv.gz
FILE_FORMAT = public.csv_format;

select * from raw.online_retail
limit 100;

-------------------------------------------------------------------
------ ******************************************** ---------------
------      CREATING VIEWS  ----------------------------------
-------------------------------------------------------------------
CREATE OR REPLACE VIEW MART.VW_DIM_PRODUCTS
AS
    SELECT * FROM MART.DIM_PRODUCTS;
--------------------------------------------

CREATE OR REPLACE VIEW MART.VW_DIM_CUSTOMERS
AS
    SELECT 
        COALESCE(TO_VARCHAR(CUSTOMER_ID), 'UNKNOWN') AS CUSTOMER_ID,
        COUNTRY
    FROM MART.DIM_CUSTOMERS;
---------------------------------------------

CREATE OR REPLACE VIEW MART.VW_FACT_CANCELLED_ORDERS
AS 
    SELECT * FROM MART.FACT_CANCELLED_ORDERS;
---------------------------------------------

CREATE OR REPLACE VIEW MART.VW_FACT_COMPLETED_ORDERS
AS
    SELECT
        invoice_no,
        stock_code,
        quantity,
        unit_price,
        total_sales,
        invoice_date,
        COALESCE(TO_VARCHAR(customer_id), 'UNKNOWN') AS customer_id
    FROM MART.FACT_COMPLETED_ORDERS;

DROP VIEW STAGING.VW_FACT_COMPLETED_ORDERS


