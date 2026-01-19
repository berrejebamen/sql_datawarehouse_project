-- ===============================================================
-- BUSINESS ANALYSIS QUERY: Product Profitability Analysis
-- ===============================================================
-- Purpose:
-- This query identifies the most profitable products by analyzing
-- revenue, cost, profit, and profit margin at the product level.
--
-- Business Questions Answered:
-- - Which products generate the highest profit?
-- - How do profitability and margins vary across categories and subcategories?
-- - Which products should be prioritized for sales, marketing, or optimization?
--
-- Metrics Calculated:
-- - Total Revenue: Sum of sales amounts per product
-- - Units Sold: Total quantity sold per product
-- - Total Cost: Product cost multiplied by quantity sold
-- - Profit: Revenue minus total cost
-- - Profit Margin (%): Profit as a percentage of revenue
--
-- Data Sources:
-- - gold.fact_sales   : Transaction-level sales facts
-- - gold.dim_products : Product attributes and cost information
--
-- Output:
-- - Top 20 products ranked by total profit (descending)
-- ===============================================================
SELECT 
    p.product_name,
    p.category,
    p.subcategory,
    SUM(f.sales_amount) as revenue,
    SUM(f.quantity) as units_sold,
    SUM(p.product_cost * f.quantity) as total_cost,
    SUM(f.sales_amount) - SUM(p.product_cost * f.quantity) as profit,
    ROUND(
        ((SUM(f.sales_amount) - SUM(p.product_cost * f.quantity)) / SUM(f.sales_amount)) * 100, 
        2
    ) as profit_margin_pct
FROM gold.fact_sales f
JOIN gold.dim_products p ON f.product_key = p.product_key
GROUP BY p.product_name, p.category, p.subcategory
ORDER BY profit DESC
LIMIT 20;
