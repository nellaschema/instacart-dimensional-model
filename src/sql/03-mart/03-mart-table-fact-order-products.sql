-- Create fact_order_products if it does not already exist. (one row per product within an order)
-- WHERE 1 = 0 creates the table structure without loading records.
CREATE TABLE IF NOT EXISTS `ftw-week-06`.`03-mart`.fact_order_products AS
SELECT
    order_id,
    product_id,
    add_to_cart_order,
    reordered
FROM `ftw-week-06`.`02-clean`.order_products_clean
WHERE 1 = 0;


-- Insert only order-product records that are not already in the fact table.
-- order_id + product_id serve as the composite key.
INSERT INTO `ftw-week-06`.`03-mart`.fact_order_products (
    order_id,
    product_id,
    add_to_cart_order,
    reordered
)
SELECT
    source.order_id,
    source.product_id,
    source.add_to_cart_order,
    source.reordered
FROM `ftw-week-06`.`02-clean`.order_products_clean AS source
WHERE NOT EXISTS (
    SELECT target.order_id, target.product_id
    FROM `ftw-week-06`.`03-mart`.fact_order_products AS target
    WHERE target.order_id = source.order_id
      AND target.product_id = source.product_id
);