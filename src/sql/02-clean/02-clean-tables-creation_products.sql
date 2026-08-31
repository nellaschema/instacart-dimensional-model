-- Create products_clean
CREATE OR REPLACE TABLE `ftw-week-06`.`02-clean`.products_clean AS
SELECT
    product_id, 
    product_name,
    CASE WHEN aisle_id IS NULL THEN -1 ELSE aisle_id END AS aisle_id,
    CASE WHEN department_id IS NULL THEN -1 ELSE department_id END AS department_id
FROM `ftw-week-06`.`01-raw`.products
