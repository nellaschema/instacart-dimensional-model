-- Create orders_clean only if it does not already exist.
-- WHERE 1 = 0 creates the table structure without loading any records.
CREATE TABLE IF NOT EXISTS `ftw-week-06`.`02-clean`.orders_clean AS
SELECT
    order_id,
    user_id,
    eval_set,
    order_number,
    order_dow,
    order_hour_of_day,
    days_since_prior_order -- Retain NULL values because they correspond to first orders.
FROM `ftw-week-06`.`01-raw`.orders
WHERE 1 = 0;


-- Incrementally load new or updated orders from the raw table.
-- MERGE prevents duplicate order_id values and updates existing records
-- if their data has changed.
MERGE INTO `ftw-week-06`.`02-clean`.orders_clean AS target
USING `ftw-week-06`.`01-raw`.orders AS source
ON target.order_id = source.order_id

-- Update the existing order when the same order_id is found in RAW.
WHEN MATCHED THEN UPDATE SET
    target.user_id = source.user_id,
    target.eval_set = source.eval_set,
    target.order_number = source.order_number,
    target.order_dow = source.order_dow,
    target.order_hour_of_day = source.order_hour_of_day,
    target.days_since_prior_order = source.days_since_prior_order

-- Insert the order when its order_id does not yet exist in CLEAN.
WHEN NOT MATCHED THEN INSERT (
    order_id,
    user_id,
    eval_set,
    order_number,
    order_dow,
    order_hour_of_day,
    days_since_prior_order
)
VALUES (
    source.order_id,
    source.user_id,
    source.eval_set,
    source.order_number,
    source.order_dow,
    source.order_hour_of_day,
    source.days_since_prior_order
);