-- Create the table structure if it does not exist.
CREATE TABLE IF NOT EXISTS `ftw-week-06`.`02-clean`.order_products_clean AS
SELECT
    order_id,
    product_id,
    add_to_cart_order,
    reordered
FROM `ftw-week-06`.`01-raw`.order_products_prior
WHERE 1 = 0;


-- Insert only order-product records that do not already exist.
-- order_id + product_id serve as the composite key.
INSERT INTO `ftw-week-06`.`02-clean`.order_products_clean (
    order_id,
    product_id,
    add_to_cart_order,
    reordered
)
SELECT
    s.order_id,
    s.product_id,
    s.add_to_cart_order,
    s.reordered
FROM (
    SELECT
        order_id,
        product_id,
        add_to_cart_order,
        reordered
    FROM `ftw-week-06`.`01-raw`.order_products_prior

    UNION

    SELECT
        order_id,
        product_id,
        add_to_cart_order,
        reordered
    FROM `ftw-week-06`.`01-raw`.order_products_train
) s
WHERE NOT EXISTS (
    SELECT t.order_id
    FROM `ftw-week-06`.`02-clean`.order_products_clean t
    WHERE t.order_id = s.order_id
      AND t.product_id = s.product_id
);