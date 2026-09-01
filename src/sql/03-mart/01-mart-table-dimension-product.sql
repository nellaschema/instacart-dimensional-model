-- create dim_product (flattened: aisle + department joined in)
CREATE OR REPLACE TABLE `ftw-week-06`.`03-mart`.dim_product AS
SELECT
    p.product_id,
    p.product_name,
    a.aisle,
    d.department
FROM `ftw-week-06`.`02-clean`.products_clean p
JOIN `ftw-week-06`.`02-clean`.aisles_clean a
    ON p.aisle_id = a.aisle_id
JOIN `ftw-week-06`.`02-clean`.departments_clean d
    ON p.department_id = d.department_id;