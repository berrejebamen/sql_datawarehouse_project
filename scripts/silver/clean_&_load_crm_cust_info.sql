-- =============================================================================
-- CRM CUSTOMER INFO — DATA QUALITY CHECKS & TRANSFORMATION LOGIC
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. PRIMARY KEY QUALITY CHECK (cst_id)
-- -----------------------------------------------------------------------------
-- Business Rule:
--   - cst_id is expected to uniquely identify each customer
--   - No duplicate values
--   - No NULL values
--
-- Purpose:
--   Identify duplicate or NULL primary keys before loading into Silver layer
-- -----------------------------------------------------------------------------
select
      cst_id,
      count(*)
from bronze.crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null;

-- Result:
--   ❌ Issue detected:
--      - Duplicate primary keys found
--      - One or more NULL cst_id values
--
-- Action:
--   Deduplicate records by keeping only the most recent record
--   (handled in the main transformation query below)


-- -----------------------------------------------------------------------------
-- 2. COMPOSITE KEY QUALITY CHECK (cst_key, cst_id)
-- -----------------------------------------------------------------------------
-- Business Rule:
--   - The combination (cst_key, cst_id) must be unique
--   - No NULL values allowed in either column
--
-- Purpose:
--   Validate business key consistency
-- -----------------------------------------------------------------------------
select
      cst_key,
      cst_id,
      count(*)
from bronze.crm_cust_info
group by cst_key, cst_id
having (count(*) > 1 or cst_key is null)
   and (cst_id is null);

-- Result:
--   ✅ Expectations are met
--   No duplicates or invalid combinations detected


-- -----------------------------------------------------------------------------
-- 3. LOAD CLEANED DATA INTO SILVER LAYER
-- -----------------------------------------------------------------------------
-- Transformation Rules Applied:
--   - Deduplicate customers using ROW_NUMBER()
--   - Keep the latest record based on cst_create_date
--   - Trim leading/trailing spaces from text columns
--   - Convert coded values (M/F/S) into human-readable values
--   - Replace NULL or invalid values with 'Unknown'
-- -----------------------------------------------------------------------------
insert into silver.crm_cust_info (
      cst_id,
      cst_key,
      cst_firstname,
      cst_lastname,
      cst_marital_status,
      cst_gndr,
      cst_create_date     
) 
select 
      cst_id,
      cst_key,
      trim(cst_firstname) as cst_firstname,
      trim(cst_lastname) as cst_lastname,
      case 
      	 when cst_marital_status = 'S' then 'Signle'
      	 when cst_marital_status = 'M' then 'Married'
      	 else 'Unkown'
      end as cst_marital_status,
      case 
	      when cst_gndr = 'M' then 'Male'
 	      when cst_gndr = 'F' then 'Female'
 	      else 'Unkown'
      end as cst_gndr,
      cst_create_date
from (
        select 
               *,
               row_number() over (
                   partition by cst_id 
                   order by cst_create_date desc
               ) as flag_date
        from bronze.crm_cust_info
        where cst_id is not null 
     ) as t
where flag_date = 1;


-- -----------------------------------------------------------------------------
-- 4. TEXT COLUMN QUALITY CHECKS
-- -----------------------------------------------------------------------------
-- Columns Checked:
--   - cst_firstname
--   - cst_lastname
--   - cst_gndr
--   - cst_marital_status
--
-- Purpose:
--   Detect unwanted leading/trailing spaces
--
-- Expectation:
--   Query should return zero rows
-- -----------------------------------------------------------------------------
select *
from bronze.crm_cust_info
where  cst_firstname != trim(cst_firstname)
    or cst_lastname  != trim(cst_lastname)
    or cst_gndr      != trim(cst_gndr)
    or cst_marital_status != trim(cst_marital_status);

-- Result:
--   ❌ Issue detected:
--      Extra spaces found in first and last name columns
--
-- Action:
--   Spaces removed in the main INSERT query above


-- -----------------------------------------------------------------------------
-- 5. GENDER COLUMN DOMAIN CHECK (cst_gndr)
-- -----------------------------------------------------------------------------
-- Purpose:
--   Inspect distinct values and detect invalid or NULL entries
-- -----------------------------------------------------------------------------
select 
      distinct cst_gndr
from bronze.crm_cust_info;

-- Rule Applied:
--   - Replace coded values ('M', 'F') with friendly values ('Male', 'Female')
--   - Use 'Unknown' for NULL or invalid values
--   (Handled in the main transformation query)


-- -----------------------------------------------------------------------------
-- 6. MARITAL STATUS DOMAIN CHECK (cst_marital_status)
-- -----------------------------------------------------------------------------
-- Purpose:
--   Inspect distinct values and detect invalid or NULL entries
-- -----------------------------------------------------------------------------
select 
      distinct cst_marital_status
from bronze.crm_cust_info;

-- Rule Applied:
--   - Replace coded values ('S', 'M') with friendly values
--   - Use 'Unknown' for NULL or invalid values
--   (Handled in the main transformation query)


-- -----------------------------------------------------------------------------
-- 7. DATE COLUMN VALIDATION (cst_create_date)
-- -----------------------------------------------------------------------------
-- Check:
--   Ensure column is of DATE data type
--
-- Result:
--   ✅ Expectations are met
-- -----------------------------------------------------------------------------

