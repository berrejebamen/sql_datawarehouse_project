--- ===============================================================
--- GOLD LAYER
--- FACT TABLE : fact_sales
--- ===============================================================
--- Purpose:
--- This view represents the core sales fact table in the Gold layer.
--- It combines transactional sales data with customer and product
--- dimensions to support analytical queries and reporting.
---
--- Grain:
--- One row per sales order line.
---
--- Source Tables:
--- - silver.crm_sales_details   : transactional sales data
--- - gold.dim_customers         : customer dimension (surrogate keys)
--- - gold.dim_products          : product dimension (surrogate keys)
---
--- Key Transformations:
--- - Maps natural keys from the Silver layer to surrogate keys
---   using dimension tables.
--- - Exposes business-friendly column names for analytics.
--- ===============================================================
create view gold.fact_sales as (
select 
    csd.sls_ord_num as order_number,
    dp.product_key as product_key,
    dc.customer_key as customer_key,
    csd.sls_order_dt as order_date,
    csd.sls_ship_dt as shipping_date,
    csd.sls_due_dt as due_date,
    csd.sls_sales as sales_amount,
    csd.sls_quantity as quantity,
    csd.sls_price as price
from silver.crm_sales_details as csd
left join gold.dim_customers as dc 
    on csd.sls_cust_id = dc.customer_key
left join gold.dim_products as dp 
    on csd.sls_prd_key = dp.product_key
);
