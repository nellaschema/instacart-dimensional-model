-- BUSINESS QUESTION:

-- Which products and departments are purchased most frequently?

-- This allows us to identify:
-- 1. The most frequently purchased products within each department, not just department totals
-- 2. How concentrated each department's purchase volume is — dominated by one hero product, or spread across many
-- 3. Which departments have no single dominant product, useful for merchandising/inventory decisions

-- Metric: purchase_count = number of times a product appears in Fact_Order_Products (one row per order-product line)
-- Metric: department_purchase_count = total purchase occurrences across all products in that department
-- Metric: product_share_pct = purchase_count as a percentage of department_purchase_count, showing how much of the department's purchase volume comes from this product

-- Dimensions:
--   department = product's department, from Dim_Product (merged in from departments)
--   product_name = individual product, from Dim_Product

-- This creates a table so the dashboard can read from it directly, instead of re-running the query each time, as per Sara's advice.

CREATE OR REPLACE TABLE `ftw-week-06`.`04-analytics`.top_products_per_department AS

WITH product_purchases AS (
    SELECT
        dp.department,
        dp.product_name,
        COUNT(*) AS purchase_count   -- how many times this product was ordered, across all orders
    FROM `ftw-week-06`.`03-mart`.fact_order_products fop
    JOIN `ftw-week-06`.`03-mart`.dim_product dp
        ON fop.product_id = dp.product_id
    GROUP BY -- aggregate at product + department level first, before calculating department totals and ranking
        dp.department,
        dp.product_name
),

product_share AS (
    SELECT
        department,
        product_name,
        purchase_count,

        SUM(purchase_count) OVER (
            PARTITION BY department   -- total purchase occurrences for the whole department, repeated on every product row
        ) AS department_purchase_count,

        ROUND(
            purchase_count * 100.0 /
            SUM(purchase_count) OVER (
                PARTITION BY department
            ),
            2
        ) AS product_share_pct   -- this product's % share of its department's total purchase volume

    FROM product_purchases
),

ranked_products AS (
    SELECT
        department,
        product_name,
        purchase_count,
        department_purchase_count,
        product_share_pct,

        ROW_NUMBER() OVER (
            PARTITION BY department        -- restart the ranking for each department
            ORDER BY purchase_count DESC, product_name   -- rank most frequently purchased first, with product name as tiebreaker
        ) AS department_rank

    FROM product_share
)

SELECT
    department,
    product_name,
    purchase_count,
    department_purchase_count,
    product_share_pct,
    department_rank
FROM ranked_products
WHERE department NOT IN ('Unknown', 'missing') --removed WHERE department_rank <= 3 to show all products and just filtered in dashboard ui
ORDER BY -- sort by department, with the highest-frequency product first within each
    department,
    department_rank;