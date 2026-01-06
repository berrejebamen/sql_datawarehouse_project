-- ============================================================================
-- PRODUCT INFORMATION (crm_prd_info) – DATA QUALITY & TRANSFORMATION LOGIC
-- ============================================================================

-- ---------------------------------------------------------------------------
-- Primary Key Quality Check: prd_id
-- ---------------------------------------------------------------------------
-- Purpose:
--   Validate the integrity of the primary key.
--
-- Expectations:
--   - No NULL values
--   - No duplicate records
--
select 
     prd_id,
     count(*)
from bronze.crm_prd_info
group by prd_id
having count(*) > 1 or prd_id is null;

-- Result:
--   Expectations are met ✔️


-- ---------------------------------------------------------------------------
-- Create Silver Layer Table: crm_prd_info
-- ---------------------------------------------------------------------------
-- Purpose:
--   Store cleaned, standardized, and business-ready product data.
--   Includes metadata columns for data lineage and auditability.
--
CREATE TABLE IF NOT EXISTS silver.crm_prd_info (
    prd_id INT,
    cat_id VARCHAR(50),
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost VARCHAR(50),
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE,
    metadata_created_at DATE DEFAULT CURRENT_DATE,
    metadat_source_file VARCHAR(50) DEFAULT 'crm/prd_info.csv'
);

-- ---------------------------------------------------------------------------
-- Load Data from Bronze to Silver (with Transformations)
-- ---------------------------------------------------------------------------
-- Transformations applied:
--   - Derive category ID and product key from prd_key
--   - Standardize product line values to business-friendly terms
--   - Convert product cost to integer and replace NULLs with 0
--   - Rebuild product end date using window functions
--
insert into silver.crm_prd_info (
                prd_id,
                cat_id,   -- Required to match the Silver table DDL exactly
                prd_key,
                prd_nm,
                prd_cost,
                prd_line,
                prd_start_dt,
                prd_end_dt
               )
select 
     prd_id,
     replace(SUBSTRING(prd_key,1,5), '-', '_') as cat_id,
     replace(SUBSTRING(prd_key,7, length(prd_key)), '-', '_') as prd_key,
     prd_nm,
     COALESCE(CAST(prd_cost AS INTEGER), 0) as prd_cost,
     case 
	     when upper(trim(prd_line)) = 'M' then 'Mountain'
         when upper(trim(prd_line)) = 'R' then 'Road'
         when upper(trim(prd_line)) = 'T' then 'Touring'
         when upper(trim(prd_line)) = 'S' then 'Other Sales'
         else 'Unkown'
     end as prd_line,
     cast(prd_start_dt as date) as prd_start_dt,
     cast(
         lead(prd_start_dt) over (partition by prd_key order by prd_start_dt)
         as date
     ) as prd_end_dt
from bronze.crm_prd_info;


-- ---------------------------------------------------------------------------
-- prd_key Quality Check
-- ---------------------------------------------------------------------------
-- Purpose:
--   Inspect product key formatting.
--
-- Expectations:
--   - No NULL values
--   - Keys follow snake_case naming convention
--
select 
      distinct prd_key
from bronze.crm_prd_info;

-- Action Taken:
--   - Split prd_key into:
--       • cat_id  → first 5 characters
--       • prd_key → remaining characters
--   - Replace '-' with '_' in both fields during Silver load


-- ---------------------------------------------------------------------------
-- prd_nm (Product Name) Quality Check
-- ---------------------------------------------------------------------------
-- Purpose:
--   Check for NULLs, malformed values, or unexpected product names.
--
select distinct prd_nm
from bronze.crm_prd_info;

-- Action Taken:
--   - Column retained as-is in the Silver layer


-- ---------------------------------------------------------------------------
-- prd_cost Quality Check
-- ---------------------------------------------------------------------------
-- Purpose:
--   Identify NULL or invalid cost values.
--
select distinct prd_cost
from bronze.crm_prd_info;

-- Action Taken:
--   - Replace NULL values with 0 during Silver load


-- ---------------------------------------------------------------------------
-- prd_line Quality Check
-- ---------------------------------------------------------------------------
-- Purpose:
--   Ensure product line values are meaningful and business-friendly.
--
select distinct prd_line
from bronze.crm_prd_info;

-- Result:
--   Expectations not met ❌
--
-- Action Taken:
--   - Map coded values (M, R, T, S) to descriptive labels
--   - Replace NULL or unknown values with 'Unknown'
--   - Business mappings validated with domain assumptions


-- ---------------------------------------------------------------------------
-- Date Consistency Check: prd_start_dt & prd_end_dt
-- ---------------------------------------------------------------------------
-- Expectations:
--   - No NULL values
--   - prd_end_dt must be later than prd_start_dt
--
select 
      prd_start_dt,
      prd_end_dt
from bronze.crm_prd_info
where prd_end_dt < prd_start_dt
   or prd_end_dt is null
   or prd_start_dt is null;

-- Result:
--   Expectations not met ❌
--
-- Action Taken:
--   - Rebuild prd_end_dt using the following rule:
--     For each product key, the end date of a record is the
--     start date of the next record (LEAD window function)


-- ---------------------------------------------------------------------------
-- Final Validation: Silver Layer Output
-- ---------------------------------------------------------------------------
-- Purpose:
--   Verify that all transformations and quality rules were applied correctly.
--
select * 
from silver.crm_prd_info;

-- Result:
--   All checks passed ✔️
