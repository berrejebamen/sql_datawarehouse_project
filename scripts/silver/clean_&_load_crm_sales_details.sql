--- Primary Key (sls_ord_num) – Data Quality Validation
--- Purpose:
---   Ensure the order number is clean and reliable before loading into Silver.
--- Checks performed:
---   - No NULL values
---   - No leading or trailing spaces
--- Expected result:
---   - Zero rows returned
select 
     sls_ord_num
from bronze.crm_sales_details csd 
group by sls_ord_num
having  sls_ord_num is null or sls_ord_num!=trim(sls_ord_num);
---- => Expectations are met

--- Load cleaned and standardized sales data from Bronze into Silver
--- Business rules applied:
---   - Normalize product keys (replace '-' with '_')
---   - Safely cast date columns
---   - Recalculate invalid sales and price values
insert into silver.crm_sales_details(
           sls_ord_num,
           sls_prd_key,
           sls_cust_id,
           sls_order_dt,
           sls_ship_dt,
           sls_due_dt,
           sls_sales,
           sls_quantity,
           sls_price       
)
select 
     sls_ord_num,
     replace(sls_prd_key, '-', '_') as sls_prd_key,
     sls_cust_id,
     case 
	      when   length(sls_order_dt::text)!=8 then null
          else  to_date(sls_order_dt::text ,'YYYYMMDD')
     end as sls_order_dt,
     to_date(sls_ship_dt::text ,'YYYYMMDD') as sls_ship_dt,
     to_date(sls_due_dt::text ,'YYYYMMDD') as sls_due_dt,
     case  
     	when sls_sales is null 
             or sls_sales < 0 
             or abs(sls_sales) != round(abs(sls_price)/sls_quantity, 2)
        then round(abs(sls_price)/sls_quantity, 2)
     	else sls_sales
     end as sls_sales,
     sls_quantity,
     case  
     	when sls_price is null 
             or sls_price < 0 
             or abs(sls_price) != round(abs(sls_sales)*sls_quantity, 2)
        then round(abs(sls_sales)*sls_quantity, 2)
     	else sls_price
     end as sls_price
from bronze.crm_sales_details;

--- Foreign Key Consistency Checks
--- Purpose:
---   Ensure referential integrity with Silver dimension tables
--- Expectations:
---   - sls_prd_key exists in silver.crm_prd_info.prd_key
---   - sls_cust_id exists in silver.crm_cust_info.cst_id
select 
      sls_cust_id,
      sls_prd_key
from bronze.crm_sales_details
where  replace(sls_prd_key,'-','_') not in (select prd_key from silver.crm_prd_info)
       or sls_cust_id not in (select cst_id from silver.crm_cust_info);
--=> Expectations are met
--- Action taken:
---   Only standardization needed is replacing '-' with '_' in sls_prd_key
---   (already handled in the INSERT statement above)

--- Date Columns Quality Checks (Order, Ship, Due Dates)
--- Purpose:
---   Validate date formats before casting to DATE
--- Rule:
---   - Dates must be exactly 8 characters (YYYYMMDD)
select 
       sls_order_dt,
       sls_ship_dt,
       sls_due_dt
from bronze.crm_sales_details
where sls_order_dt is null 
      or length(cast(sls_order_dt as VARCHAR)) !=8 
      or sls_ship_dt is null 
      or length(cast(sls_ship_dt as VARCHAR)) !=8 
      or sls_due_dt is null 
      or length(cast(sls_due_dt as VARCHAR)) !=8;
-- => Expectations are not met
--- Resolution:
---   - Invalid sls_order_dt values are set to NULL
---   - sls_ship_dt and sls_due_dt are directly cast (no data issues found)

--- Quantity Validation
--- Rule:
---   - Quantity must be > 0 and NOT NULL
select 
       sls_price,
       sls_quantity,
       sls_sales  
from bronze.crm_sales_details
where sls_quantity is null or sls_quantity <= 0;
-- => No issues found; column is safe to load as-is

--- Price Validation
--- Rule:
---   - Price must be > 0 and consistent with sales * quantity
select 
       sls_price,
       sls_quantity,
       sls_sales  
from bronze.crm_sales_details
where sls_price is null or sls_price <= 0;
--=> Invalid prices are recalculated using the business formula in the INSERT

--- Sales Amount Validation
--- Rule:
---   - Sales must be > 0 and mathematically consistent
select 
       sls_sales  
from bronze.crm_sales_details
where sls_sales is null or sls_sales <= 0;
--=> Invalid sales values are recalculated using the business formula in the INSERT

--- Final Validation
--- Purpose:
---   Verify the Silver table after all transformations
select *
from silver.crm_sales_details;
-- => Everything looks correct
