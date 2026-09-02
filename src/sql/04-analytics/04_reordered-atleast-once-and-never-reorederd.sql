-- What share of all purchased products are never reordered (one-time purchases) vs. reordered at least once?
-- Products that are reordered at least once and never reordered

WITH product_status AS (
    SELECT 
        product_id,
        MAX(reordered) AS is_reordered
    FROM `ftw-week-06`.`03-mart`.fact_order_products
    GROUP BY product_id
)
SELECT 
    ps.product_id,
    p.product_name,
    CASE 
        WHEN is_reordered = 0 THEN 'Never Reordered (One-time only)'
        ELSE 'Reordered At Least Once' 
    END AS product_category
FROM product_status ps
JOIN `ftw-week-06`.`03-mart`.dim_product p
    ON ps.product_id = p.product_id
ORDER BY ps.product_id;