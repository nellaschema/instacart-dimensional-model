-- create orders_clean
CREATE OR REPLACE TABLE `ftw-week-06`.`02-clean`.orders_clean AS
SELECT
    order_id,
    user_id,
    eval_set,
    order_number,
    order_dow,
    order_hour_of_day,
    days_since_prior_order -- cleaned table should retain the 206,209 NULL values since they correspond to first orders.
FROM `ftw-week-06`.`01-raw`.orders;