-- ORDER PRODUCTS CLEAN VALIDATION
-- Validates order-product relationships, cart position,
-- reorder indicator, duplicates, and foreign-key relationships.

SELECT
    'unexpected_nulls' AS check_name,

    -- All four fields are required for each order-product record.
    COUNT_IF(
        op.order_id IS NULL
        OR op.product_id IS NULL
        OR op.add_to_cart_order IS NULL
        OR op.reordered IS NULL
    ) AS actual_value,

    0 AS expected_value,

    CASE
        WHEN COUNT_IF(
            op.order_id IS NULL
            OR op.product_id IS NULL
            OR op.add_to_cart_order IS NULL
            OR op.reordered IS NULL
        ) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END AS status

FROM `ftw-week-06`.`02-clean`.order_products_clean op

UNION ALL

-- DUPLICATE CHECK
-- An order-product combination should appear only once.
SELECT
    'duplicate_order_product',
    COUNT(*) - COUNT(DISTINCT STRUCT(
        op.order_id,
        op.product_id
    )),
    0,
    CASE
        WHEN COUNT(*) - COUNT(DISTINCT STRUCT(
            op.order_id,
            op.product_id
        )) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.order_products_clean op

UNION ALL

-- REFERENTIAL INTEGRITY
-- Every order_id must exist in orders_clean,
-- and every product_id must exist in products_clean.
SELECT
    'orphan_order_or_product',
    COUNT_IF(
        o.order_id IS NULL
        OR p.product_id IS NULL
    ),
    0,
    CASE
        WHEN COUNT_IF(
            o.order_id IS NULL
            OR p.product_id IS NULL
        ) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.order_products_clean op

LEFT JOIN `ftw-week-06`.`02-clean`.orders_clean o
    ON op.order_id = o.order_id

LEFT JOIN `ftw-week-06`.`02-clean`.products_clean p
    ON op.product_id = p.product_id

UNION ALL

-- INVALID VALUE CHECK
-- add_to_cart_order starts at 1, while reordered can only be 0 or 1.
SELECT
    'invalid_values',
    COUNT_IF(
        op.add_to_cart_order <= 0
        OR op.reordered NOT IN (0, 1)
    ),
    0,
    CASE
        WHEN COUNT_IF(
            op.add_to_cart_order <= 0
            OR op.reordered NOT IN (0, 1)
        ) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.order_products_clean op;