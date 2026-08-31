-- addressed github comment by sara: retain the nulls in the clean layer (row 6816)
CREATE OR REPLACE TABLE `ftw-week-06`.`02-clean`.products_clean AS
SELECT
    product_id, 
    product_name,
    aisle_id,
    department_id
FROM `ftw-week-06`.`01-raw`.products
