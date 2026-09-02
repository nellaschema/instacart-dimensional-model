-- create order_products_clean
-- combined prior and train, same grain and columns
-- columns listed explicitly instead of SELECT * for safety if source tables change (per Sara's and Nella's suggestion)
CREATE OR REPLACE TABLE `ftw-week-06`.`02-clean`.order_products_clean AS
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