CREATE OR REPLACE TABLE `ftw-week-06`.`01-raw`.orders AS
SELECT *
FROM read_files(
  '/Volumes/ftw-week-06/00-source/cloudflare/shared/week06/instacart_csv/orders.csv',
  format => 'csv',
  header => true,
  inferSchema => true
);

CREATE OR REPLACE TABLE `ftw-week-06`.`01-raw`.products AS
SELECT *
FROM read_files(
  '/Volumes/ftw-week-06/00-source/cloudflare/shared/week06/instacart_csv/products.csv',
  format => 'csv',
  header => true,
  inferSchema => true
);

CREATE OR REPLACE TABLE `ftw-week-06`.`01-raw`.aisles AS
SELECT *
FROM read_files(
  '/Volumes/ftw-week-06/00-source/cloudflare/shared/week06/instacart_csv/aisles.csv',
  format => 'csv',
  header => true,
  inferSchema => true
);

CREATE OR REPLACE TABLE `ftw-week-06`.`01-raw`.departments AS
SELECT *
FROM read_files(
  '/Volumes/ftw-week-06/00-source/cloudflare/shared/week06/instacart_csv/departments.csv',
  format => 'csv',
  header => true,
  inferSchema => true
);

CREATE OR REPLACE TABLE `ftw-week-06`.`01-raw`.order_products_prior AS
SELECT *
FROM read_files(
  '/Volumes/ftw-week-06/00-source/cloudflare/shared/week06/instacart_csv/order_products__prior.csv',
  format => 'csv',
  header => true,
  inferSchema => true
);

CREATE OR REPLACE TABLE `ftw-week-06`.`01-raw`.order_products_train AS
SELECT *
FROM read_files(
  '/Volumes/ftw-week-06/00-source/cloudflare/shared/week06/instacart_csv/order_products__train.csv',
  format => 'csv',
  header => true,
  inferSchema => true
);

SHOW TABLES IN `ftw-week-06`.`01-raw`;