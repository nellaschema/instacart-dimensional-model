-- inspect products
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

    -- validity
    COUNT_IF(product_id <= 0) AS invalid_product_id,
    COUNT_IF(aisle_id <= 0) AS invalid_aisle_id,
    COUNT_IF(department_id <= 0) AS invalid_department_id

FROM `ftw-week-06`.`01-raw`.products;