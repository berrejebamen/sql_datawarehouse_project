-- ===============================================================
-- Business Use Case: Sales Performance by Country
-- ===============================================================
-- This query is used as a data source for an Apache Superset chart.
--
-- Business Question:
--   "How do sales perform across different countries?"
--
-- Purpose:
--   - Measure total revenue generated per country
--   - Count unique customer orders per country
--   - Aggregate total quantity sold per country
--   - Rank countries by revenue contribution
--
-- Visualization:
--   - Bar chart or table in Apache Superset
--   - Helps business users identify top-performing markets
--   - Supports strategic decisions around regional sales focus
-- ===============================================================
SELECT 
    c.country,
    COUNT(DISTINCT f.order_number) as total_orders,
    SUM(f.sales_amount) as revenue,
    SUM(f.quantity) as total_quantity
FROM gold.fact_sales f
JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY revenue DESC;
