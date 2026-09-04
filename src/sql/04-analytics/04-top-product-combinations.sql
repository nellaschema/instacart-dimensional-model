-- BUSINESS QUESTION: Which pairs of products are purchased together most often?
-- This identifies product combinations that could be considered for cross-selling or bundle recommendations.

-- MAIN METRIC:
-- pair_order_count = number of unique orders containing both products.

-- LOGIC:
-- 1. Join fact_order_products to itself using order_id to find products purchased in the same order.
-- 2. Create pairs of different products from each order.
-- 3. Use f1.product_id < f2.product_id to avoid duplicate pairs.
-- 4. Join dim_product twice to get both product names.
-- 5. Count unique orders containing each product pair.
-- 6. Rank pairs from most to least frequently purchased.

CREATE OR REPLACE TABLE `ftw-week-06`.`04-analytics`.product_pairs AS

SELECT
    p1.product_name AS product_1,   -- Product from the first side of the self-join
    p2.product_name AS product_2,   -- Product from the second side of the self-join
    COUNT(DISTINCT f1.order_id) AS pair_order_count -- Count how many unique orders contain both products.

FROM `ftw-week-06`.`03-mart`.fact_order_products AS f1  -- Join the fact table to itself. This allows us to find different products that were purchased within the same order.

JOIN `ftw-week-06`.`03-mart`.fact_order_products AS f2  -- Products must belong to the same order
    ON f1.order_id = f2.order_id                        -- Only keep pairs of different products. Using < also prevents duplicate/reversed pairs.
    AND f1.product_id < f2.product_id                   -- Example: Product A + Product B = included  // Product B + Product A = excluded

JOIN `ftw-week-06`.`03-mart`.dim_product AS p1 -- Join to dim_product to get the name of the first product.
    ON f1.product_id = p1.product_id
JOIN `ftw-week-06`.`03-mart`.dim_product AS p2 -- Join to dim_product again to get the name  of the second product.
    ON f2.product_id = p2.product_id

GROUP BY -- Group the results by product pair. 
    p1.product_name,
    p2.product_name

ORDER BY -- Rank product pairs from the most frequently purchased together to the least frequently purchased.
    pair_order_count DESC;