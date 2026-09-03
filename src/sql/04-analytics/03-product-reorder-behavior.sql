-- BUSINESS QUESTION:
-- Which products have the highest reorder behavior?
-- This allows us to identify:
-- 1. Which products are reordered most often?
-- 2. Which products have the highest reordered rate?
-- 3. Which departments have no single dominant product, useful for merchandising/inventory decisions
-- 4. What share of all purchased products are never reordered (one-time purchases) vs. reordered at least once?
-- Metric: reorder_rate = AVG(reordered) 
-- Metric: reorder_count = SUM(reordered)
-- Metric: Total_purchase_count = count(*)
-- Metric: one_time_purchase_flag
-- Dimensions:
--    product_id / product_name
--   product_name = individual product, from Dim_Product
-- This creates a table so the dashboard can read from it directly, instead of re-running the query each time.

CREATE OR REPLACE TABLE `ftw-week-06`.`04-analytics`.product_reorder_behavior AS
SELECT
    p.product_id,
    p.product_name,
    p.department,
    p.aisle,
    COUNT(*) AS total_orders,
    SUM(f.reordered) AS total_reorders,
    ROUND(AVG(f.reordered), 4) AS reorder_rate,
    CASE WHEN COUNT(*) >= 50 THEN TRUE ELSE FALSE END AS meets_min_sample_threshold,
    RANK() OVER (ORDER BY AVG(f.reordered) DESC) AS reorder_rate_rank
FROM `ftw-week-06`.`03-mart`.fact_order_products f
JOIN `ftw-week-06`.`03-mart`.dim_product p
    ON f.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.department,
    p.aisle
ORDER BY
    reorder_rate_rank;

--  Which products have the highest reorder count?
SELECT 
    p.product_name,
    SUM(f.reordered) AS total_reorders
FROM `ftw-week-06`.`03-mart`.fact_order_products f
JOIN `ftw-week-06`.`03-mart`.dim_product p
    ON f.product_id = p.product_id
GROUP BY 
    p.product_id, 
    p.product_name
ORDER BY 
    total_reorders DESC
LIMIT 10;

-- Highest reorder rate of products 
SELECT 
    p.product_id,
    p.product_name,
    COUNT(*) AS total_orders,
    SUM(f.reordered) AS total_reorders,
    ROUND(AVG(f.reordered), 4) AS reorder_rate
FROM `ftw-week-06`.`03-mart`.fact_order_products f
JOIN `ftw-week-06`.`03-mart`.dim_product p
    ON f.product_id = p.product_id
GROUP BY 
    p.product_id, 
    p.product_name
HAVING 
    COUNT(*) >= 50
ORDER BY 
    reorder_rate DESC
LIMIT 10;

-- Which departments/aisles have the highest overall reorder rate?
SELECT 
    p.department,
    p.aisle,
    COUNT(f.product_id) AS total_items_ordered,
    SUM(f.reordered) AS total_reorders,
    ROUND(AVG(f.reordered), 4) AS reorder_rate
FROM `ftw-week-06`.`03-mart`.fact_order_products f
JOIN `ftw-week-06`.`03-mart`.dim_product p
    ON f.product_id = p.product_id
GROUP BY 
    p.department, 
    p.aisle
HAVING 
    COUNT(f.product_id) >= 100
ORDER BY 
    reorder_rate DESC
LIMIT 10;

-- What share of all purchased products are never reordered vs. reordered at least once?
WITH product_status AS (
    SELECT 
        product_id,
        MAX(reordered) AS is_reordered
    FROM `ftw-week-06`.`03-mart`.fact_order_products
    GROUP BY product_id
)
SELECT
    CASE 
        WHEN is_reordered = 0 THEN 'Never Reordered (One-time only)'
        ELSE 'Reordered At Least Once' 
    END AS product_category,
    COUNT(*) AS product_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_total_products
FROM product_status
GROUP BY 
    CASE 
        WHEN is_reordered = 0 THEN 'Never Reordered (One-time only)'
        ELSE 'Reordered At Least Once' 
    END;
