-- ===============================================================
-- Business Use Case: Top 10 Products by Revenue
-- ===============================================================
-- This query is used as a data source for an Apache Superset chart.
-- 
-- Business Question:
--   "Which products generate the highest total revenue?"
--
-- Purpose:
--   - Aggregate total sales per product
--   - Rank products by revenue in descending order
--   - Return the top 10 performing products
--
-- Visualization:
--   - Bar chart (Top N products)
--   - Used by business stakeholders to identify best-selling products
-- ===============================================================
SELECT 
    p.product_name,
    SUM(f.sales_amount) AS revenue
FROM gold.fact_sales f
JOIN gold.dim_products p 
    ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;
