--- ===============================================================
--- GOLD LAYER
--- DIMENSION TABLE : dim_products
--- ===============================================================
--- Purpose:
--- This view builds the Product Dimension for the Gold layer.
--- It combines cleaned CRM product data with ERP category metadata
--- to provide a business-ready, analytics-friendly product table.
---
--- Why LEFT JOIN is used:
--- - The CRM product table (silver.crm_prd_info) is treated as the
---   master source for products.
--- - LEFT JOIN ensures that ALL products from CRM are kept,
---   even if category information is missing in the ERP table.
--- - This prevents accidental data loss that could occur with
---   INNER JOIN when no matching category exists.
---
--- ===============================================================

create view gold.dim_products as (
select
      row_number() over(order by cpi.prd_start_dt) as product_id,
      cpi.prd_key as product_key,
      cpi.prd_id as product_number,
      cpi.prd_nm as product_name,
      cpi.prd_cost as product_cost,
      cpi.prd_line as product_line,
      cpi.prd_start_dt as product_start_date,
      epcg.cat as category,
      epcg.subcat as subcategory,
      epcg.maintenance as maintenance
from silver.crm_prd_info as cpi
left join silver.erp_px_cat_g1v2 as epcg
on cpi.prd_key = epcg.id
);
