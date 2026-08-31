CREATE OR REPLACE TABLE `ftw-week-06`.`01-raw`.orders AS -- ORDERS
SELECT *
FROM read_files(
  '/Volumes/ftw-week-06/00-source/cloudflare/shared/week06/instacart_csv/orders.csv',
  format => 'csv',
  header => true,
  schema => 'order_id INT, user_id INT, eval_set STRING, order_number INT, order_dow INT, order_hour_of_day INT, days_since_prior_order DOUBLE'
);
--PRODUCTS
CREATE OR REPLACE TABLE `ftw-week-06`.`01-raw`.products AS
SELECT *
FROM read_files(
  '/Volumes/ftw-week-06/00-source/cloudflare/shared/week06/instacart_csv/products.csv',
  format => 'csv',
  header => true,
  schema => 'product_id INT, product_name STRING, aisle_id INT, department_id INT'
);
--AISLES
CREATE OR REPLACE TABLE `ftw-week-06`.`01-raw`.aisles AS
SELECT *
FROM read_files(
  '/Volumes/ftw-week-06/00-source/cloudflare/shared/week06/instacart_csv/aisles.csv',
  format => 'csv',
  header => true,
  schema => 'aisle_id INT, aisle STRING'
);
--DEPARTMENTS
CREATE OR REPLACE TABLE `ftw-week-06`.`01-raw`.departments AS
SELECT *
FROM read_files(
  '/Volumes/ftw-week-06/00-source/cloudflare/shared/week06/instacart_csv/departments.csv',
  format => 'csv',
  header => true,
  schema => 'department_id INT, department STRING'
);
--ORDER PRIOR
CREATE OR REPLACE TABLE `ftw-week-06`.`01-raw`.order_products_prior AS
SELECT *
FROM read_files(
  '/Volumes/ftw-week-06/00-source/cloudflare/shared/week06/instacart_csv/order_products__prior.csv',
  format => 'csv',
  header => true,
  schema => 'order_id INT, product_id INT, add_to_cart_order INT, reordered INT'
);
--ORDER TRAIN
CREATE OR REPLACE TABLE `ftw-week-06`.`01-raw`.order_products_train AS
SELECT *
FROM read_files(
  '/Volumes/ftw-week-06/00-source/cloudflare/shared/week06/instacart_csv/order_products__train.csv',
  format => 'csv',
  header => true,
  schema => 'order_id INT, product_id INT, add_to_cart_order INT, reordered INT'
);

SHOW TABLES IN `ftw-week-06`.`01-raw`;