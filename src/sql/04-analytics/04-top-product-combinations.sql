-- BUSINESS QUESTION: Which pairs of products are purchased together most often?
-- This identifies product combinations that could be considered for cross-selling or bundle recommendations.

-- MAIN METRIC:
-- pair_order_count = number of unique orders containing both products.

CREATE OR REPLACE TABLE `ftw-week-06`.`04-analytics`.product_pairs AS

-- FILTER: Keep products purchased in >= 20 unique orders.
WITH frequent_products AS (
    SELECT
        product_id
    FROM `ftw-week-06`.`03-mart`.fact_order_products
    GROUP BY
        product_id
    HAVING COUNT(DISTINCT order_id) >= 20 )

SELECT
    f1.product_id AS product_id_1,       -- ID of the first product; used to uniquely identify the product.
    p1.product_name AS product_1,        -- Name of the first product for easier interpretation.
    f2.product_id AS product_id_2,       -- ID of the second product; used to uniquely identify the product.
    p2.product_name AS product_2,        -- Name of the second product for easier interpretation.
    CONCAT(p1.product_name, ' + ', p2.product_name) AS product_pair, -- Combined product names for the dashboard label.
    COUNT(DISTINCT f1.order_id) AS pair_order_count  -- Counts unique orders containing both products.

FROM `ftw-week-06`.`03-mart`.fact_order_products AS f1  -- First copy of the fact table containing products purchased in each order.
JOIN frequent_products AS fp1
    ON f1.product_id = fp1.product_id -- Keep only products purchased in at least 20 unique orders.

JOIN `ftw-week-06`.`03-mart`.fact_order_products AS f2  -- Second copy of the fact table used to compare products within the same order.
    ON f1.order_id = f2.order_id                        -- Only matches products that were purchased in the same order.
    AND f1.product_id < f2.product_id                   -- Keeps each product pair only once and excludes the same product.

JOIN frequent_products AS fp2
    ON f2.product_id = fp2.product_id -- Keep only products purchased in at least 20 unique orders.

JOIN `ftw-week-06`.`03-mart`.dim_product AS p1        -- Joins the first product to get its product name.
    ON f1.product_id = p1.product_id

JOIN `ftw-week-06`.`03-mart`.dim_product AS p2        -- Joins the second product to get its product name.
    ON f2.product_id = p2.product_id

GROUP BY                                             -- Groups the data by each unique product combination.
    f1.product_id,
    p1.product_name,
    f2.product_id,
    p2.product_name

HAVING COUNT(DISTINCT f1.order_id) >= 5 

ORDER BY                                             -- Sorts the product combinations from most to least frequently purchased.
    pair_order_count DESC,                            -- Highest number of orders appears first.
    f1.product_id ASC,                                -- Uses product ID as the first tie-breaker when pair counts are equal.
    f2.product_id ASC                                 -- Uses the second product ID as the second tie-breaker.

LIMIT 100;                                             -- Keeps only the top 100 most frequently purchased product combinations.