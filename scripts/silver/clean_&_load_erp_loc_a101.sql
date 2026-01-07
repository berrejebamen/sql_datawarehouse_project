select * from bronze.erp_loc_a101;

-- Check quality of the primary key column 'cid':
-- 1. Ensure there are no duplicated values.
-- 2. Ensure there are no null values.
-- 3. Ensure 'cid' matches 'cst_key' in silver.crm_cust_info (as documented in the documentation  folder).
select 
      cid,
      count(*)
from bronze.erp_loc_a101
group by cid
having cid is null or count(*)>1;
-- => No duplicates or nulls found, but some 'cid' values contain an extra '-' character.
--    We'll handle this in the insert query below.

-- Check quality of 'cntry' column:
-- 1. Ensure no leading or trailing spaces.
-- 2. Ensure there are no null values.
select 
      cntry 
from bronze.erp_loc_a101
where cntry!=trim(cntry) and cntry is null;
-- => All checks passed, data meets expectations.

-- Insert cleaned data into silver layer
insert into silver.erp_loc_a101(
       cid,
       cntry
)
select 
      replace(cid, '-','') as cid,  -- remove any '-' from 'cid'
      cntry
from bronze.erp_loc_a101;
