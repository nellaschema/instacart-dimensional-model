-- ORDERS CLEAN VALIDATION
-- Validates order identifiers, customer information,
-- order timing fields, evaluation set, and expected NULL values.

SELECT
    'unexpected_nulls' AS check_name,

    -- All order attributes must be present except
    -- days_since_prior_order for first orders.
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
    ) AS actual_value,

    0 AS expected_value,

    CASE
        WHEN COUNT_IF(
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
        ) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END AS status

FROM `ftw-week-06`.`02-clean`.orders_clean

UNION ALL

-- DUPLICATE CHECK
-- order_id uniquely identifies each order.
SELECT
    'duplicate_order_id',
    COUNT(*) - COUNT(DISTINCT order_id),
    0,
    CASE
        WHEN COUNT(*) - COUNT(DISTINCT order_id) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.orders_clean

UNION ALL

-- INVALID VALUE CHECK
-- Validates IDs, order sequence, day/hour ranges,
-- days since prior order, and allowed evaluation sets.
SELECT
    'invalid_values',
    COUNT_IF(
        order_id <= 0
        OR user_id <= 0
        OR order_number <= 0
        OR order_dow NOT BETWEEN 0 AND 6
        OR order_hour_of_day NOT BETWEEN 0 AND 23
        OR days_since_prior_order < 0
        OR days_since_prior_order > 30
        OR eval_set NOT IN ('prior', 'train', 'test')
    ),
    0,
    CASE
        WHEN COUNT_IF(
            order_id <= 0
            OR user_id <= 0
            OR order_number <= 0
            OR order_dow NOT BETWEEN 0 AND 6
            OR order_hour_of_day NOT BETWEEN 0 AND 23
            OR days_since_prior_order < 0
            OR days_since_prior_order > 30
            OR eval_set NOT IN ('prior', 'train', 'test')
        ) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.orders_clean

UNION ALL

-- EXPECTED VALUE
-- First orders do not have a previous order,
-- so days_since_prior_order is intentionally NULL.
SELECT
    'expected_null_days_since_prior_order',
    COUNT_IF(days_since_prior_order IS NULL),
    206209,
    CASE
        WHEN COUNT_IF(days_since_prior_order IS NULL) = 206209
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.orders_clean;