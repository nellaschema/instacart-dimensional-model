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