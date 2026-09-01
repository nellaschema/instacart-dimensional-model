-- create order_products_clean
-- combined prior and train, same grain and columns
CREATE OR REPLACE TABLE `ftw-week-06`.`02-clean`.order_products_clean AS
SELECT * FROM `ftw-week-06`.`01-raw`.order_products_prior
UNION ALL
SELECT * FROM `ftw-week-06`.`01-raw`.order_products_train;