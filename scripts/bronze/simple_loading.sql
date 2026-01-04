-- =====================================================
-- Simple Bronze Layer Load Script
-- Purpose: Truncate bronze tables and load CSV data
-- =====================================================

-- ======================
-- CRM TABLES
-- ======================

-- Load CRM Customer Info
TRUNCATE TABLE bronze.crm_cust_info;

COPY bronze.crm_cust_info
FROM '/home/amenallah/Desktop/de_first_project/datasets/source_crm/cust_info.csv'
CSV HEADER;

-- Load CRM Product Info
TRUNCATE TABLE bronze.crm_prd_info;

COPY bronze.crm_prd_info
FROM '/home/amenallah/Desktop/de_first_project/datasets/source_crm/prd_info.csv'
CSV HEADER;

-- Load CRM Sales Details
TRUNCATE TABLE bronze.crm_sales_details;

COPY bronze.crm_sales_details
FROM '/home/amenallah/Desktop/de_first_project/datasets/source_crm/sales_details.csv'
CSV HEADER;

-- ======================
-- ERP TABLES
-- ======================

-- Load ERP Location
TRUNCATE TABLE bronze.erp_loc_a101;

COPY bronze.erp_loc_a101
FROM '/home/amenallah/Desktop/de_first_project/datasets/source_erp/LOC_A101.csv'
CSV HEADER;

-- Load ERP Customer
TRUNCATE TABLE bronze.erp_cust_az12;

COPY bronze.erp_cust_az12
FROM '/home/amenallah/Desktop/de_first_project/datasets/source_erp/CUST_AZ12.csv'
CSV HEADER;

-- Load ERP Product Category
TRUNCATE TABLE bronze.erp_px_cat_g1v2;

COPY bronze.erp_px_cat_g1v2
FROM '/home/amenallah/Desktop/de_first_project/datasets/source_erp/PX_CAT_G1V2.csv'
CSV HEADER;
