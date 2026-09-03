-- PRODUCTS CLEAN VALIDATION
-- Validates product identifiers, names, category references,
-- and expected NULL category IDs.

SELECT
    'unexpected_nulls' AS check_name,

    -- Product ID and name must always be present.
    -- NULL category IDs are expected and checked separately below.
    COUNT_IF(
        product_id IS NULL
        OR product_name IS NULL
    ) AS actual_value,

    0 AS expected_value,

    CASE
        WHEN COUNT_IF(
            product_id IS NULL
            OR product_name IS NULL
        ) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END AS status

FROM `ftw-week-06`.`02-clean`.products_clean

UNION ALL

-- DUPLICATE CHECK
-- product_id identifies each product and must be unique.
SELECT
    'duplicate_product_id',
    COUNT(*) - COUNT(DISTINCT product_id),
    0,
    CASE
        WHEN COUNT(*) - COUNT(DISTINCT product_id) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.products_clean

UNION ALL

-- DUPLICATE CHECK
-- Product names are also checked for duplicates based on the
-- team's validation requirement.
SELECT
    'duplicate_product_name',
    COUNT(*) - COUNT(DISTINCT product_name),
    0,
    CASE
        WHEN COUNT(*) - COUNT(DISTINCT product_name) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.products_clean

UNION ALL

-- REFERENTIAL INTEGRITY
-- Every non-NULL aisle_id and department_id must exist
-- in their respective reference tables.
SELECT
    'orphan_category',
    COUNT_IF(
        (aisle_id IS NOT NULL
            AND aisle_id NOT IN (
                SELECT aisle_id
                FROM `ftw-week-06`.`02-clean`.aisles_clean
            ))
        OR
        (department_id IS NOT NULL
            AND department_id NOT IN (
                SELECT department_id
                FROM `ftw-week-06`.`02-clean`.departments_clean
            ))
    ),
    0,
    CASE
        WHEN COUNT_IF(
            (aisle_id IS NOT NULL
                AND aisle_id NOT IN (
                    SELECT aisle_id
                    FROM `ftw-week-06`.`02-clean`.aisles_clean
                ))
            OR
            (department_id IS NOT NULL
                AND department_id NOT IN (
                    SELECT department_id
                    FROM `ftw-week-06`.`02-clean`.departments_clean
                ))
        ) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.products_clean

UNION ALL

-- INVALID VALUE CHECK
-- IDs must be positive and product names must not be blank.
SELECT
    'invalid_values',
    COUNT_IF(
        product_id <= 0
        OR TRIM(product_name) = ''
        OR (aisle_id IS NOT NULL AND aisle_id <= 0)
        OR (department_id IS NOT NULL AND department_id <= 0)
    ),
    0,
    CASE
        WHEN COUNT_IF(
            product_id <= 0
            OR TRIM(product_name) = ''
            OR (aisle_id IS NOT NULL AND aisle_id <= 0)
            OR (department_id IS NOT NULL AND department_id <= 0)
        ) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.products_clean

UNION ALL

-- EXPECTED VALUE
-- One product has no assigned aisle in the source data,
-- so its aisle_id is intentionally retained as NULL.
SELECT
    'expected_null_aisle_id',
    COUNT_IF(aisle_id IS NULL),
    1,
    CASE
        WHEN COUNT_IF(aisle_id IS NULL) = 1
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.products_clean

UNION ALL

-- EXPECTED VALUE
-- One product has no assigned department in the source data,
-- so its department_id is intentionally retained as NULL.
SELECT
    'expected_null_department_id',
    COUNT_IF(department_id IS NULL),
    1,
    CASE
        WHEN COUNT_IF(department_id IS NULL) = 1
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.products_clean;