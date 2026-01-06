-- =====================================================
-- Silver Layer Tables
-- Derived from Bronze Layer with Metadata Columns
-- =====================================================

-- Customer master data from CRM system
CREATE TABLE IF NOT EXISTS silver.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE,
    created_at DATE DEFAULT CURRENT_DATE,
    source_file VARCHAR(50) DEFAULT 'crm/cust_info.csv'
);

-- Product master data from CRM system
CREATE TABLE IF NOT EXISTS silver.crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost VARCHAR(50),      -- kept as VARCHAR in silver (raw data)
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE,
    created_at DATE DEFAULT CURRENT_DATE,
    source_file VARCHAR(50) DEFAULT 'crm/prd_info.csv'
    
);

-- Sales transaction details from CRM system
CREATE TABLE IF NOT EXISTS silver.crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_ship_dt DATE,          
    sls_due_dt DATE,            
    sls_sales DATE,
    sls_quantity INT,
    sls_price INT,
    created_at DATE DEFAULT CURRENT_DATE,
    source_file VARCHAR(50) DEFAULT 'crm/sales_details.csv'
);

-- Customer demographic data from ERP system (AZ12)
CREATE TABLE IF NOT EXISTS silver.erp_cust_az12 (
    CID VARCHAR(50),
    BDATE DATE,
    GEN VARCHAR(50),
    created_at DATE DEFAULT CURRENT_DATE,
    source_file VARCHAR(50) DEFAULT 'erp/cust_az12.csv'
);

-- Customer location data from ERP system (A101)
CREATE TABLE IF NOT EXISTS silver.erp_loc_a101 (
    CID VARCHAR(50),
    CNTRY VARCHAR(50),
    created_at DATE DEFAULT CURRENT_DATE,
    source_file VARCHAR(50) DEFAULT 'erp/loc_a101.csv'
);

-- Product category mapping from ERP system (G1V2)
CREATE TABLE IF NOT EXISTS silver.erp_px_cat_g1v2 (
    ID VARCHAR(50),
    CAT VARCHAR(50),
    SUBCAT VARCHAR(50),
    MAINTENANCE VARCHAR(50),
    created_at DATE DEFAULT CURRENT_DATE,
    source_file VARCHAR(50) DEFAULT 'erp/px_cat_g1v2.csv'
);
