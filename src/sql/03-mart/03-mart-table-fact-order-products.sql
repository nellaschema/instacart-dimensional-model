-- create fact_order_products (one row per product within an order)
CREATE OR REPLACE TABLE `ftw-week-06`.`03-mart`.fact_order_products AS
SELECT
    order_id,
    product_id,
    add_to_cart_order,
    reordered
FROM `ftw-week-06`.`02-clean`.order_products_clean;