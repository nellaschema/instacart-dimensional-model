-- Business Question: Which products have the highest reorder count?
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