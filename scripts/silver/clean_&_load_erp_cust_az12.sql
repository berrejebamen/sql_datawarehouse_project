-- Check quality of 'bdate' column
-- Expectations: valid dates and no null values
select * from bronze.erp_cust_az12
where bdate is null;
-- => No issues found in 'bdate' column

-- Check quality of 'gen' column
-- Expectations: friendly values, no empty or null values
select 
       distinct gen
from bronze.erp_cust_az12;
-- => Found values 'M', 'F', empty and null. 
--    Will convert: M -> Male, F -> Female, null/empty -> Unknown in the insert query below

-- Check quality of 'cid' column
-- Expectations: no nulls and must match 'cst_key' in silver.crm_prd_info 
-- (as documented in  'How Data is Related in Data Sources')
select 
       distinct cid
from bronze.erp_cust_az12;
-- => Some values have extra 'NAS' prefix. We'll remove it in the insert query below

-- Insert cleaned data into silver layer
insert into silver.erp_cust_az12(
            cid, 
            bdate,
            gen
)
select 
       case
       	  when cid ilike 'NAS%' then substring(cid, 4, length(cid))  -- remove 'NAS' prefix
       	  else cid
       end as cid,
       bdate,
       case 
       	 when trim(gen)='M' then 'Male'
       	 when trim(gen)='F' then 'Female'
       	 when trim(gen)='Male' then trim(gen)
       	 when trim(gen)='Female' then trim(gen)
       	 else 'Unknown'  -- replace null/empty with 'Unknown'
       end as gen
from bronze.erp_cust_az12;

-- Quick verification
select * 
from silver.erp_cust_az12;
-- => All looks good
