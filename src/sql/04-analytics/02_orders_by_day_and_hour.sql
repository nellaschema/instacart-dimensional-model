-- BUSINESS QUESTION:
-- How does customer purchasing behavior change by day of week and hour of day?
-- This allows us to identify:
-- 1. Which day has the most orders
-- 2. Which hours are busiest
-- 3. Which specific day + hour has the most orders
-- 4. Whether high order activity comes from many customers

-- Metric: order_count = number of unique orders
-- Dimensions:
--   order_dow = day of week
--   order_hour_of_day = hour of day
--   user_id/customer_count = number of unique customers

SELECT
    -- Convert the numeric DOW into a readable day name
    CASE
        WHEN order_dow = 0 THEN 'Sunday'
        WHEN order_dow = 1 THEN 'Monday'
        WHEN order_dow = 2 THEN 'Tuesday'
        WHEN order_dow = 3 THEN 'Wednesday'
        WHEN order_dow = 4 THEN 'Thursday'
        WHEN order_dow = 5 THEN 'Friday'
        WHEN order_dow = 6 THEN 'Saturday'
    END AS day_of_week,

    order_hour_of_day,    -- hour when the order was placed
    COUNT(DISTINCT order_id) AS order_count,    -- number of unique orders
    COUNT(DISTINCT user_id) AS customer_count   -- number of unique customers placing orders
FROM `ftw-week-06`.`03-mart`.dim_order

GROUP BY -- Analyze purchasing activity for every combination of day and hour
    order_dow,
    order_hour_of_day
ORDER BY -- Show the busiest purchasing periods first
    order_count DESC;
