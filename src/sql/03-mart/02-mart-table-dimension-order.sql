-- Create dim_order only if it does not already exist. (user_id folded in as an attribute, not its own dimension)
-- WHERE 1 = 0 creates the table structure without loading records.
CREATE TABLE IF NOT EXISTS `ftw-week-06`.`03-mart`.dim_order AS
SELECT
    order_id,
    user_id,
    eval_set,
    order_number,
    order_dow,
    order_hour_of_day,
    days_since_prior_order
FROM `ftw-week-06`.`02-clean`.orders_clean
WHERE 1 = 0;


-- Incrementally load new or updated orders into dim_order.
-- Existing order_id values are updated, while new orders are inserted.
MERGE INTO `ftw-week-06`.`03-mart`.dim_order AS target
USING `ftw-week-06`.`02-clean`.orders_clean AS source
ON target.order_id = source.order_id

-- Update an existing order if its attributes have changed.
WHEN MATCHED THEN UPDATE SET
    target.user_id = source.user_id,
    target.eval_set = source.eval_set,
    target.order_number = source.order_number,
    target.order_dow = source.order_dow,
    target.order_hour_of_day = source.order_hour_of_day,
    target.days_since_prior_order = source.days_since_prior_order

-- Insert a new order when the order_id does not yet exist.
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