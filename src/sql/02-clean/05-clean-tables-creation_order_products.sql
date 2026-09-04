-- Create order_products_clean only if it does not already exist.
-- combined prior and train, same grain and columns
-- columns listed explicitly instead of SELECT * for safety if source tables change (per Sara's and Nella's suggestion)
-- WHERE 1 = 0 creates the table structure without loading any records.
CREATE TABLE IF NOT EXISTS `ftw-week-06`.`02-clean`.order_products_clean AS
SELECT
    order_id,
    product_id,
    add_to_cart_order,
    reordered
FROM `ftw-week-06`.`01-raw`.order_products_prior
WHERE 1 = 0;


-- Load the existing prior and train records into order_products_clean.
-- This is the initial load of the table.
INSERT INTO `ftw-week-06`.`02-clean`.order_products_clean (
    order_id,
    product_id,
    add_to_cart_order,
    reordered
)
SELECT
    order_id,
    product_id,
    add_to_cart_order,
    reordered
FROM `ftw-week-06`.`01-raw`.order_products_prior

UNION ALL

SELECT
    order_id,
    product_id,
    add_to_cart_order,
    reordered
FROM `ftw-week-06`.`01-raw`.order_products_train;