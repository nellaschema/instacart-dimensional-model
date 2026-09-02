-- create dim_order (user_id folded in as an attribute, not its own dimension)
CREATE OR REPLACE TABLE `ftw-week-06`.`03-mart`.dim_order AS
SELECT
    order_id,
    user_id,
    eval_set,
    order_number,
    order_dow,
    order_hour_of_day,
    days_since_prior_order
FROM `ftw-week-06`.`02-clean`.orders_clean;