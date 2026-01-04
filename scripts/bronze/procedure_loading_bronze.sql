/*
===============================================================================
Procedure: load_bronze
===============================================================================
Purpose:
    Loads data from CSV files into Bronze schema tables.
    - Truncates tables before loading
    - Uses COPY for bulk loading
    - Logs duration per table and total load time
===============================================================================
*/
CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    batch_start_time TIMESTAMP;
    batch_end_time TIMESTAMP;
BEGIN
    batch_start_time := clock_timestamp();

    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '================================================';

    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Loading CRM Tables';
    RAISE NOTICE '------------------------------------------------';

    -- CRM CUSTOMER INFO
    start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.crm_cust_info';
    TRUNCATE TABLE bronze.crm_cust_info;

    RAISE NOTICE '>> Inserting Data Into: bronze.crm_cust_info';
    COPY bronze.crm_cust_info
    FROM '/home/amenallah/Desktop/de_first_project/datasets/source_crm/cust_info.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: % ms',
        ROUND(
           CAST(EXTRACT(EPOCH FROM (end_time - start_time)) * 1000 AS numeric),
           2
          );
    RAISE NOTICE '>> -------------';

    -- CRM PRODUCT INFO
    start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.crm_prd_info';
    TRUNCATE TABLE bronze.crm_prd_info;

    RAISE NOTICE '>> Inserting Data Into: bronze.crm_prd_info';
    COPY bronze.crm_prd_info
    FROM '/home/amenallah/Desktop/de_first_project/datasets/source_crm/prd_info.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: % ms',
         ROUND(
           CAST(EXTRACT(EPOCH FROM (end_time - start_time)) * 1000 AS numeric),
           2
          );
    RAISE NOTICE '>> -------------';

    -- CRM SALES DETAILS
    start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.crm_sales_details';
    TRUNCATE TABLE bronze.crm_sales_details;

    RAISE NOTICE '>> Inserting Data Into: bronze.crm_sales_details';
    COPY bronze.crm_sales_details
    FROM '/home/amenallah/Desktop/de_first_project/datasets/source_crm/sales_details.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: % ms',
        ROUND(
           CAST(EXTRACT(EPOCH FROM (end_time - start_time)) * 1000 AS numeric),
           2
          );
    RAISE NOTICE '>> -------------';

    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Loading ERP Tables';
    RAISE NOTICE '------------------------------------------------';

    -- ERP LOCATION
    start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.erp_loc_a101';
    TRUNCATE TABLE bronze.erp_loc_a101;

    RAISE NOTICE '>> Inserting Data Into: bronze.erp_loc_a101';
    COPY bronze.erp_loc_a101
    FROM '/home/amenallah/Desktop/de_first_project/datasets/source_erp/LOC_A101.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: % ms',
         ROUND(
           CAST(EXTRACT(EPOCH FROM (end_time - start_time)) * 1000 AS numeric),
           2
          );
    RAISE NOTICE '>> -------------';

    -- ERP CUSTOMER
    start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.erp_cust_az12';
    TRUNCATE TABLE bronze.erp_cust_az12;

    RAISE NOTICE '>> Inserting Data Into: bronze.erp_cust_az12';
    COPY bronze.erp_cust_az12
    FROM '/home/amenallah/Desktop/de_first_project/datasets/source_erp/CUST_AZ12.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: % ms',
        ROUND(
           CAST(EXTRACT(EPOCH FROM (end_time - start_time)) * 1000 AS numeric),
           2
          );
    RAISE NOTICE '>> -------------';

    -- ERP PRODUCT CATEGORY
    start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating Table: bronze.erp_px_cat_g1v2';
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;

    RAISE NOTICE '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
    COPY bronze.erp_px_cat_g1v2
    FROM '/home/amenallah/Desktop/de_first_project/datasets/source_erp/PX_CAT_G1V2.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: % ms',
         ROUND(
           CAST(EXTRACT(EPOCH FROM (end_time - start_time)) * 1000 AS numeric),
           2
          );
    RAISE NOTICE '>> -------------';

    batch_end_time := clock_timestamp();

    RAISE NOTICE '==========================================';
    RAISE NOTICE 'Loading Bronze Layer is Completed';
    RAISE NOTICE '   - Total Load Duration: % ms',
         ROUND(
             CAST(EXTRACT(EPOCH FROM (batch_end_time - batch_start_time)) * 1000 AS numeric),
              2
    );
    RAISE NOTICE '==========================================';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '==========================================';
        RAISE NOTICE 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        RAISE NOTICE 'Error Message: %', SQLERRM;
        RAISE NOTICE 'SQLSTCALL  bronze.load_bronze();ATE: %', SQLSTATE;
        RAISE NOTICE '==========================================';
END;
$$;
