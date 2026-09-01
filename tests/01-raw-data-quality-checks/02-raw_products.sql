-- inspect products updated (addressed virna's github comment)
SELECT
    COUNT(*) AS row_count,

    -- completeness
    COUNT_IF(product_id IS NULL) AS missing_product_id,
    COUNT_IF(product_name IS NULL) AS missing_product_name,
    COUNT_IF(TRIM(product_name) = '') AS empty_product_name,
    COUNT_IF(
        product_name IS NULL OR TRIM(product_name) = ''
    ) AS missing_or_empty_product_name,
    COUNT_IF(aisle_id IS NULL) AS missing_aisle_id,
    COUNT_IF(department_id IS NULL) AS missing_department_id,

    -- uniqueness
    COUNT(DISTINCT product_id) AS unique_product_id,
    COUNT(DISTINCT aisle_id) AS unique_aisle_id,
    COUNT(DISTINCT department_id) AS unique_department_id,

    -- duplicate product names
    COUNT_IF(product_name IN
                (SELECT product_name
                FROM `ftw-week-06`.`01-raw`.products
                GROUP BY product_name
                HAVING COUNT(*) > 1)
    ) AS duplicate_product_name_count,

    -- validity
    COUNT_IF(product_id <= 0) AS invalid_product_id,
    COUNT_IF(aisle_id <= 0) AS invalid_aisle_id,
    COUNT_IF(department_id <= 0) AS invalid_department_id

    
    -- referential integrity
    COUNT_IF(aisle_id IS NOT NULL AND NOT EXISTS 
            (SELECT 1
            FROM `ftw-week-06`.`01-raw`.aisles AS a
            WHERE a.aisle_id = products.aisle_id)
    ) AS orphan_aisle_count,

    COUNT_IF(department_id IS NOT NULL AND NOT EXISTS (
        SELECT 1
        FROM `ftw-week-06`.`01-raw`.departments AS d
        WHERE d.department_id = products.department_id
    )) AS orphan_department_count

FROM `ftw-week-06`.`01-raw`.products;