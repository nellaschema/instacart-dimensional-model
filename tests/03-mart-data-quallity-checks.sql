-- MART DATA QUALITY VALIDATION

SELECT
    'products' AS table_name,

    -- NULL
    COUNT_IF(
        product_id IS NULL
        OR product_name IS NULL
        OR aisle IS NULL
        OR department IS NULL
    ) AS null_count,

    -- DUPLICATE
    COUNT(*) - COUNT(DISTINCT product_id) AS duplicate_count,

    -- REFERENTIAL INTEGRITY
    0 AS referential_integrity,

    -- INVALID VALUES
    COUNT_IF(
        product_id <= 0
        OR TRIM(product_name) = ''
    ) AS invalid_values

FROM `ftw-week-06`.`03-mart`.dim_product

UNION ALL

SELECT
    'orders',

    -- NULL
    COUNT_IF(
        order_id IS NULL
        OR user_id IS NULL
        OR eval_set IS NULL
        OR order_number IS NULL
        OR order_dow IS NULL
        OR order_hour_of_day IS NULL
        OR (
            days_since_prior_order IS NULL
            AND order_number > 1
        )
    ),

    -- DUPLICATE
    COUNT(*) - COUNT(DISTINCT order_id),

    -- REFERENTIAL INTEGRITY
    0,

    -- INVALID VALUES
    COUNT_IF(
        order_number <= 0
        OR order_dow NOT BETWEEN 0 AND 6
        OR order_hour_of_day NOT BETWEEN 0 AND 23
        OR days_since_prior_order < 0
        OR days_since_prior_order > 30
    )

FROM `ftw-week-06`.`03-mart`.dim_order

UNION ALL

SELECT
    'order_products',

    -- NULL
    COUNT_IF(
        f.order_id IS NULL
        OR f.product_id IS NULL
        OR f.add_to_cart_order IS NULL
        OR f.reordered IS NULL
    ),

    -- DUPLICATE
    COUNT(*) - COUNT(DISTINCT STRUCT(f.order_id, f.product_id)),

    -- REFERENTIAL INTEGRITY
    COUNT_IF(
        o.order_id IS NULL
        OR p.product_id IS NULL
    ),

    -- INVALID VALUES
    COUNT_IF(
        f.add_to_cart_order <= 0
        OR f.reordered NOT IN (0, 1)
    )

FROM `ftw-week-06`.`03-mart`.fact_order_products f

LEFT JOIN `ftw-week-06`.`03-mart`.dim_order o
    ON f.order_id = o.order_id

LEFT JOIN `ftw-week-06`.`03-mart`.dim_product p
    ON f.product_id = p.product_id;