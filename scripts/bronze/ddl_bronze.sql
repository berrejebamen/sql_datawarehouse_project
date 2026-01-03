/*
===========================================================
Bronze Layer DDL Script (PostgreSQL)
-----------------------------------------------------------
Purpose:
- Create raw (Bronze layer) tables
- Store source system data as-is
- No transformations or business logic applied
- Tables are created only if they do not already exist
-----------------------------------------------------------
Schemas used:
- bronze
-----------------------------------------------------------
Notes:
- This script is idempotent (safe to run multiple times)
- Data types reflect raw ingestion stage
===========================================================
*/

-- Customer master data from CRM system
CREATE TABLE IF NOT EXISTS bronze.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE
);

-- Product master data from CRM system
CREATE TABLE IF NOT EXISTS bronze.crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost VARCHAR(50),      -- kept as VARCHAR in Bronze (raw data)
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE
);

-- Sales transaction details from CRM system
CREATE TABLE IF NOT EXISTS bronze.crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_ship_dt INT,           -- raw date format
    sls_due_dt INT,            -- raw date format
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

-- Customer demographic data from ERP system (AZ12)
CREATE TABLE IF NOT EXISTS bronze.erp_cust_az12 (
    CID VARCHAR(50),
    BDATE DATE,
    GEN VARCHAR(50)
);

-- Customer location data from ERP system (A101)
CREATE TABLE IF NOT EXISTS bronze.erp_loc_a101 (
    CID VARCHAR(50),
    CNTRY VARCHAR(50)
);

-- Product category mapping from ERP system (G1V2)
CREATE TABLE IF NOT EXISTS bronze.erp_px_cat_g1v2 (
    ID VARCHAR(50),
    CAT VARCHAR(50),
    SUBCAT VARCHAR(50),
    MAINTENANCE VARCHAR(50)
);
