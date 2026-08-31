-- orders validation
SELECT
    COUNT(*) AS row_count,

    -- Completeness
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS missing_order_id,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS missing_user_id,
    SUM(CASE WHEN eval_set IS NULL THEN 1 ELSE 0 END) AS missing_eval_set,
    SUM(CASE WHEN order_number IS NULL THEN 1 ELSE 0 END) AS missing_order_number,
    SUM(CASE WHEN order_dow IS NULL THEN 1 ELSE 0 END) AS missing_order_dow,
    SUM(CASE WHEN order_hour_of_day IS NULL THEN 1 ELSE 0 END) AS missing_order_hour_of_day,
    SUM(CASE WHEN days_since_prior_order IS NULL THEN 1 ELSE 0 END)
        AS missing_days_since_prior_order,

    -- Uniqueness
    COUNT(DISTINCT order_id) AS unique_order_id,
    COUNT(DISTINCT user_id) AS unique_user_id,

    -- Validity
    SUM(CASE WHEN order_dow NOT BETWEEN 0 AND 6 THEN 1 ELSE 0 END)
        AS invalid_order_dow,
    SUM(CASE WHEN order_hour_of_day NOT BETWEEN 0 AND 23 THEN 1 ELSE 0 END)
        AS invalid_order_hour,
    SUM(CASE WHEN order_number <= 0 THEN 1 ELSE 0 END)
        AS invalid_order_number,
    SUM(CASE WHEN days_since_prior_order < 0 THEN 1 ELSE 0 END)
        AS negative_days_since_prior_order,
    SUM(CASE WHEN days_since_prior_order > 30 THEN 1 ELSE 0 END)
        AS days_since_prior_order_above_30,

    -- Business Rules
    SUM(
        CASE
            WHEN order_number = 1
                 AND days_since_prior_order IS NOT NULL
            THEN 1
            ELSE 0
        END
    ) AS first_order_with_prior_order,

    SUM(
        CASE
            WHEN order_number > 1
                 AND days_since_prior_order IS NULL
            THEN 1
            ELSE 0
        END
    ) AS subsequent_order_without_prior_order

FROM `ftw-week-06`.`01-raw`.orders;