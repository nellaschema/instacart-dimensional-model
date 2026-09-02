-- CLEANED LAYER VALIDATION
-- Purpose: Verify that cleaned tables preserve valid records,
-- maintain unique keys, and have valid relationships.

-- ORDERS
-- 1. Row count should match Raw
SELECT
    'orders_clean' AS table_name,
    'row_count' AS check_name,
    COUNT(*) AS actual_value,
    (SELECT COUNT(*)
     FROM `ftw-week-06`.`01-raw`.orders) AS expected_value,
    CASE
        WHEN COUNT(*) = (
            SELECT COUNT(*)
            FROM `ftw-week-06`.`01-raw`.orders
        )
        THEN 'PASS'
        ELSE 'FAIL'
    END AS status
FROM `ftw-week-06`.`02-clean`.orders_clean

UNION ALL

-- 2. order_id should not be NULL
SELECT
    'orders_clean',
    'null_order_id',
    COUNT_IF(order_id IS NULL),
    0,
    CASE
        WHEN COUNT_IF(order_id IS NULL) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.orders_clean

UNION ALL

-- 3. order_id should be unique
SELECT
    'orders_clean',
    'duplicate_order_id',
    COUNT(*) - COUNT(DISTINCT order_id),
    0,
    CASE
        WHEN COUNT(*) = COUNT(DISTINCT order_id)
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.orders_clean

UNION ALL

-- 4. NULL days_since_prior_order is expected only for first orders
SELECT
    'orders_clean',
    'unexpected_null_days_since_prior_order',
    COUNT_IF(
        days_since_prior_order IS NULL
        AND order_number > 1
    ),
    0,
    CASE
        WHEN COUNT_IF(
            days_since_prior_order IS NULL
            AND order_number > 1
        ) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.orders_clean

UNION ALL

-- PRODUCTS
-- 5. Row count should match Raw
SELECT
    'products_clean',
    'row_count',
    COUNT(*),
    (SELECT COUNT(*)
     FROM `ftw-week-06`.`01-raw`.products),
    CASE
        WHEN COUNT(*) = (
            SELECT COUNT(*)
            FROM `ftw-week-06`.`01-raw`.products
        )
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.products_clean

UNION ALL

-- 6. product_id should not be NULL
SELECT
    'products_clean',
    'null_product_id',
    COUNT_IF(product_id IS NULL),
    0,
    CASE
        WHEN COUNT_IF(product_id IS NULL) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.products_clean

UNION ALL

-- 7. product_id should be unique
SELECT
    'products_clean',
    'duplicate_product_id',
    COUNT(*) - COUNT(DISTINCT product_id),
    0,
    CASE
        WHEN COUNT(*) = COUNT(DISTINCT product_id)
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.products_clean

UNION ALL

-- 8. One product has missing aisle and department classification.
-- This record is intentionally retained as NULL in Cleaned
-- and will be represented as 'Unknown' in the Mart layer.
SELECT
    'products_clean',
    'expected_missing_classification',
    COUNT_IF(
        aisle_id IS NULL
        AND department_id IS NULL
    ),
    1,
    CASE
        WHEN COUNT_IF(
            aisle_id IS NULL
            AND department_id IS NULL
        ) = 1
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.products_clean

UNION ALL

-- 9. Non-NULL aisle and department IDs should have valid mappings
SELECT
    'products_clean',
    'orphan_classification',
    COUNT_IF(
        p.aisle_id IS NOT NULL
        AND a.aisle_id IS NULL
    )
    +
    COUNT_IF(
        p.department_id IS NOT NULL
        AND d.department_id IS NULL
    ),
    0,
    CASE
        WHEN
            COUNT_IF(
                p.aisle_id IS NOT NULL
                AND a.aisle_id IS NULL
            )
            +
            COUNT_IF(
                p.department_id IS NOT NULL
                AND d.department_id IS NULL
            ) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.products_clean p
LEFT JOIN `ftw-week-06`.`02-clean`.aisles_clean a
    ON p.aisle_id = a.aisle_id
LEFT JOIN `ftw-week-06`.`02-clean`.departments_clean d
    ON p.department_id = d.department_id

UNION ALL

-- AISLES
-- 10. Aisle records and IDs should be preserved
SELECT
    'aisles_clean',
    'row_count_unique_non_null_id',
    COUNT(*),
    (SELECT COUNT(*)
     FROM `ftw-week-06`.`01-raw`.aisles),
    CASE
        WHEN COUNT(*) = (
            SELECT COUNT(*)
            FROM `ftw-week-06`.`01-raw`.aisles
        )
        AND COUNT(*) = COUNT(DISTINCT aisle_id)
        AND COUNT_IF(aisle_id IS NULL) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.aisles_clean

UNION ALL

-- DEPARTMENTS
-- 11. Department records and IDs should be preserved
SELECT
    'departments_clean',
    'row_count_unique_non_null_id',
    COUNT(*),
    (SELECT COUNT(*)
     FROM `ftw-week-06`.`01-raw`.departments),
    CASE
        WHEN COUNT(*) = (
            SELECT COUNT(*)
            FROM `ftw-week-06`.`01-raw`.departments
        )
        AND COUNT(*) = COUNT(DISTINCT department_id)
        AND COUNT_IF(department_id IS NULL) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.departments_clean

UNION ALL

-- ORDER PRODUCTS
-- 12. Combined prior + train records should be preserved
SELECT
    'order_products_clean',
    'row_count',
    COUNT(*),
    (SELECT COUNT(*)
     FROM `ftw-week-06`.`01-raw`.order_products_prior)
    +
    (SELECT COUNT(*)
     FROM `ftw-week-06`.`01-raw`.order_products_train),
    CASE
        WHEN COUNT(*) = (
            SELECT COUNT(*)
            FROM `ftw-week-06`.`01-raw`.order_products_prior
        )
        +
        (
            SELECT COUNT(*)
            FROM `ftw-week-06`.`01-raw`.order_products_train
        )
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.order_products_clean

UNION ALL

-- 13. Foreign keys should not be NULL
SELECT
    'order_products_clean',
    'null_foreign_keys',
    COUNT_IF(
        order_id IS NULL
        OR product_id IS NULL
    ),
    0,
    CASE
        WHEN COUNT_IF(
            order_id IS NULL
            OR product_id IS NULL
        ) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.order_products_clean

UNION ALL

-- 14. All order and product IDs should have valid mappings
SELECT
    'order_products_clean',
    'orphan_order_or_product',
    COUNT_IF(o.order_id IS NULL)
    +
    COUNT_IF(p.product_id IS NULL),
    0,
    CASE
        WHEN COUNT_IF(o.order_id IS NULL)
             + COUNT_IF(p.product_id IS NULL) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.order_products_clean op
LEFT JOIN `ftw-week-06`.`02-clean`.orders_clean o
    ON op.order_id = o.order_id
LEFT JOIN `ftw-week-06`.`02-clean`.products_clean p
    ON op.product_id = p.product_id;