-- Create fact_order_products only if it does not already exist.(one row per product within an order)
-- WHERE 1 = 0 creates the table structure without loading records.
CREATE TABLE IF NOT EXISTS `ftw-week-06`.`03-mart`.fact_order_products AS
SELECT
    order_id,
    product_id,
    add_to_cart_order,
    reordered
FROM `ftw-week-06`.`02-clean`.order_products_clean
WHERE 1 = 0;


-- Initial load of the existing order-product records.
INSERT INTO `ftw-week-06`.`03-mart`.fact_order_products (
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
FROM `ftw-week-06`.`02-clean`.order_products_clean;