# 📌 Project Documentation

## 🛠 Project Tools
- **Snowflake Cloud Warehouse** – Data storage & warehouse
- **dbt (Data Build Tool)** – Data transformations & modeling
- **Power BI** – Data visualization & dashboarding

---

## 🔄 Project Pipeline Overview

### 1️⃣ Dataset
- **Name:** Online Retail Dataset  
- **Description:** Transactions from a UK-based online retail store between 01/12/2010 and 09/12/2011, mainly selling unique giftware to wholesalers.

**Attributes:**

| Attribute    | Type     | Description                                                                                       |
|--------------|---------|----------------------------------------------------------------------------------------------------|
| InvoiceNo    | Nominal | Unique 6-digit transaction number (starts with 'C' if cancelled)                                    |
| StockCode    | Nominal | Unique 5-digit product code                                                                         |
| Description  | Nominal | Product name                                                                                        |
| Quantity     | Numeric | Number of products per transaction                                                                  |
| InvoiceDate  | Numeric | Date & time of the transaction                                                                      |
| UnitPrice    | Numeric | Price per product unit (£)                                                                          |
| CustomerID   | Nominal | Unique 5-digit customer ID                                                                          |
| Country      | Nominal | Customer’s country                                                                                  |

---

### 2️⃣ Data Warehouse Creation (Snowflake)

1. **Create Stage** – Upload raw dataset for access  
2. **Schemas:**
   - `Raw` – Store raw data
   - `Staging` – Cleaned & transformed data
   - `Mart` – Final star schema (facts & dimensions)
3. **Process:**
   - Clone data from stage to `Raw` schema
   - Connect dbt to Snowflake for transformations

---

### 3️⃣ Data Transformation (dbt)

**Modeling Layers:**

| Layer    | Purpose                                           |
|---------|---------------------------------------------------|
| Raw     | Ingest data as-is                                 |
| Staging | Data cleaning, standardization & enrichment       |
| Mart    | Final models for analytics (fact & dimension)     |

**Transformations in Staging:**
- Remove:
  - Null `CustomerID` rows & cancelled invoices
  - Transactions with `Quantity=0` (non-cancelled)
  - Transactions with `UnitPrice=0` (non-cancelled)
- Clean:
  - Lowercase & clean product descriptions (remove ???, damaged, etc.)
  - Keep only valid `StockCode` (5-digit or 5-digit + 1 char)
- Enrich:
  - Prepare clean dataset for modeling

---

### 4️⃣ Star Schema (Mart Layer)

| Table                    | Type       | Purpose                                     |
|-------------------------|-----------|---------------------------------------------|
| Dim_Customers           | Dimension | Customer details                           |
| Dim_Products            | Dimension | Product details                            |
| Fact_Completed_Sales    | Fact      | Successfully completed orders              |
| Fact_Cancelled_Sales    | Fact      | Cancelled & returned orders                |

✅ Run dbt models → Validate structure in Snowflake.

---

## 📊 Dashboards (Power BI)

Connected Power BI directly to Mart schema.

---

### ✅ Completed Orders Dashboard
- **KPIs:**
  - Number of Customers
  - Number of Completed Orders
  - Total Sales
  - Number of Sold Products
- **Visuals:**
  - MTD Completed Orders (line chart)
  - MTD Sold Quantity (line chart)
  - Top 10 sold products & % of total price (table)
  - Map with:
    - Total sales by country
    - Top 5 products per country (tooltip)
    - Unique products sold, total quantity per country

---

### 🚫 Cancelled Orders Dashboard
- **KPIs:**
  - Number of Units Returned
  - Number of Cancelled Orders
  - Total Cancelled Price
  - Number of Unique Returned Products
- **Visuals:**
  - MTD Cancelled Orders (line chart)
  - MTD Returned Quantity (line chart)
  - Top 10 returned products & % of total price (table)
  - Map with:
    - Total returned sales by country
    - Top 5 returned products per country (tooltip)
    - Unique returned products, total units returned

---

### 📦 RFM Analysis Dashboard
- **KPIs:**
  - Number of Customers
  - Number of Champion Customers
  - Number of At Risk Customers
  - At Risk Revenue
- **Visuals:**
  - Waterfall chart (Monetary by segment)
  - Bar chart (Number of customers by segment)
  - Histogram (Customer distribution by Recency)
  - Histogram (Distribution by RFM Score)

---

### 🧭 Customer Distribution Dashboard
- **Visuals:**
  - Histogram (Customer distribution by Frequency)
  - Box plot (Frequency distribution & outliers)
  - Histogram (Customer distribution by Monetary)
  - Box plot (Monetary distribution & outliers)

---

## ✅ Final Architecture

| Layer  | Content                              |
|--------|--------------------------------------|
| Raw    | Original dataset                     |
| Staging| Cleaned & transformed data           |
| Mart   | Fact & dimension tables for analysis |

---
