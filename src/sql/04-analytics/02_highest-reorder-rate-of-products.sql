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