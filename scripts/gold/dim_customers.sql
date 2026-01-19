-- =========================================================
-- GOLD LAYER
-- Dimension Table: Customers
-- =========================================================
-- Purpose:
--   Build the customer dimension by consolidating customer
--   master data from CRM and ERP sources.
--   - Generate a surrogate customer key
--   - Standardize gender and country values
--   - Apply business ownership rules (CRM as master source)
-- =========================================================

create view gold.dim_customers as (
select
    -- Surrogate key generated using a randomized order
    ROW_NUMBER() OVER (ORDER BY random()) AS customer_key,

    -- Business identifiers
    csi.cst_id  as customer_id,
    csi.cst_key as customer_number,

    -- Customer attributes
    csi.cst_firstname       as first_name,
    csi.cst_lastname        as last_name,
    csi.cst_marital_status  as marital_status,

    -- Gender resolution rule:
    -- Prefer CRM gender when available; otherwise fallback to ERP
    case 
        when csi.cst_gndr != 'Unkown' then csi.cst_gndr
        else COALESCE(ela.cst_gndr, 'Unknown')  
    end as gender,

    -- Metadata
    csi.cst_create_date as create_date,

    -- Additional demographic attributes
    eca.bdate as birthdate,

    -- Country standardization:
    -- Normalize country codes and names, handle nulls and blanks
    case 
        when ela.cntry is null 
             or trim(ela.cntry) = '' then 'Unknown'
        when trim(ela.cntry) = 'US' then 'United States of America'
        when trim(ela.cntry) = 'United States' then 'United States of America'
        when trim(ela.cntry) = 'DE' then 'Germany'
        else trim(ela.cntry)
    end as country

from silver.crm_cust_info csi 

-- Join with ERP location data
left join silver.erp_loc_a101 ela 
    on csi.cst_key = ela.cid

-- Join with ERP customer demographics
left join silver.erp_cust_az12 eca 
    on csi.cst_key = eca.cid
);

-- Business Rule:
-- CRM is the system of record for customer gender.
-- If a conflict exists between CRM and ERP values,
-- the CRM value is always retained.

