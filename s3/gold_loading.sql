-- ===============================================================
-- GOLD LAYER
-- Export Views to CSV Files
-- ===============================================================

-- ---------------------------------------------------------------
-- Export FACT TABLE
-- ---------------------------------------------------------------
COPY (
    SELECT *
    FROM gold.fact_sales
)
TO '/home/amenallah/Desktop/de_first_project/exports/gold/fact_sales.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- ---------------------------------------------------------------
-- Export DIMENSION: PRODUCTS
-- ---------------------------------------------------------------
COPY (
    SELECT *
    FROM gold.dim_products
)
TO '/home/amenallah/Desktop/de_first_project/exports/gold/dim_products.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- ---------------------------------------------------------------
-- Export DIMENSION: CUSTOMERS
-- ---------------------------------------------------------------
COPY (
    SELECT *
    FROM gold.dim_customers
)
TO '/home/amenallah/Desktop/de_first_project/exports/gold/dim_customers.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');
