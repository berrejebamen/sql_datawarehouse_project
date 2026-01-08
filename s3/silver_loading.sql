-- ========================================================
-- Script: Export Silver Layer Tables to CSV
-- Purpose: Save silver-layer tables from the data warehouse 
--          to local CSV files. These files will be uploaded 
--          to the corresponding S3 bucket.
-- ========================================================

-- Export CRM Customer Information
COPY silver.crm_cust_info 
TO '/home/amenallah/Desktop/de_first_project/s3/crm_cust_info.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Export CRM Product Information
COPY silver.crm_prd_info 
TO '/home/amenallah/Desktop/de_first_project/s3/crm_prd_info.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Export CRM Sales Details
COPY silver.crm_sales_details 
TO '/home/amenallah/Desktop/de_first_project/s3/crm_sales_details.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Export ERP Customer AZ12 Table
COPY silver.erp_cust_az12 
TO '/home/amenallah/Desktop/de_first_project/s3/erp_cust_az12.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Export ERP Location A101 Table
COPY silver.erp_loc_a101 
TO '/home/amenallah/Desktop/de_first_project/s3/erp_loc_a101.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- Export ERP Price Category G1V2 Table
COPY silver.erp_px_cat_g1v2 
TO '/home/amenallah/Desktop/de_first_project/s3/erp_px_cat_g1v2.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');
