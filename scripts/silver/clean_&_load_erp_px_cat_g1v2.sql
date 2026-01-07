-- Quick verification of the source table
select *
from bronze.erp_px_cat_g1v2;
-- => Table has few columns and all data is clean: no nulls or issues detected

-- Insert data into silver layer
insert into silver.erp_px_cat_g1v2 (
       id, 
       cat,
       subcat,
       maintenance
)
select  
       id, 
       cat,
       subcat,
       maintenance
from bronze.erp_px_cat_g1v2;
-- => Simple insert, data quality already verified
