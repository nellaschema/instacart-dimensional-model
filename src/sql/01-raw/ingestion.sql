-- ORDERS
CREATE TABLE IF NOT EXISTS (
    order_id INT,
    user_id INT,
    eval_set STRING,
    order_number INT,
    order_dow INT,
    order_hour_of_day INT,
    days_since_prior_order DOUBLE
);

COPY INTO `ftw-week-06`.`01-raw`.orders
FROM '/Volumes/ftw-week-06/00-source/cloudflare/shared/week06/instacart_csv/'
FILEFORMAT = CSV
PATTERN = 'orders.*\.csv' -- a pattern that matches only order files
FORMAT_OPTIONS (
    'header' = 'true'
);

--PRODUCTS
CREATE TABLE IF NOT EXISTS `ftw-week-06`.`01-raw`.products ( product_id INT, product_name STRING, aisle_id INT, department_id INT );

COPY INTO `ftw-week-06`.`01-raw`.products
FROM '/Volumes/ftw-week-06/00-source/cloudflare/shared/week06/instacart_csv/'
FILEFORMAT = CSV
PATTERN = 'products.*\.csv' -- a pattern that matches only product files
FORMAT_OPTIONS (
    'header' = 'true'
);

--AISLES
CREATE TABLE IF NOT EXISTS `ftw-week-06`.`01-raw`.aisles ( aisle_id INT, aisle STRING );

COPY INTO `ftw-week-06`.`01-raw`.aisles
FROM '/Volumes/ftw-week-06/00-source/cloudflare/shared/week06/instacart_csv/'
FILEFORMAT = CSV
PATTERN = 'aisles.*\.csv' -- a pattern that matches only aisles files
FORMAT_OPTIONS (
    'header' = 'true'
);

--DEPARTMENTS
CREATE TABLE IF NOT EXISTS `ftw-week-06`.`01-raw`.departments ( department_id INT, department STRING );

COPY INTO `ftw-week-06`.`01-raw`.departments
FROM '/Volumes/ftw-week-06/00-source/cloudflare/shared/week06/instacart_csv/'
FILEFORMAT = CSV
PATTERN = 'departments.*\.csv' -- a pattern that matches only departments files
FORMAT_OPTIONS (
    'header' = 'true'
);

--ORDER PRIOR
CREATE TABLE IF NOT EXISTS `ftw-week-06`.`01-raw`.order_products_prior ( order_id INT, product_id INT, add_to_cart_order INT, reordered INT );

COPY INTO `ftw-week-06`.`01-raw`.order_products_prior
FROM '/Volumes/ftw-week-06/00-source/cloudflare/shared/week06/instacart_csv/'
FILEFORMAT = CSV
PATTERN = 'order_products__prior*\.csv' -- a pattern that matches only order_products__prior files
FORMAT_OPTIONS (
    'header' = 'true'
); 

--ORDER TRAIN
CREATE TABLE IF NOT EXISTS `ftw-week-06`.`01-raw`.order_products_train ( order_id INT, product_id INT, add_to_cart_order INT, reordered INT );

COPY INTO `ftw-week-06`.`01-raw`.order_products_train
FROM '/Volumes/ftw-week-06/00-source/cloudflare/shared/week06/instacart_csv/'
FILEFORMAT = CSV
PATTERN = 'order_products__train*\.csv' -- a pattern that matches only order_products__train files
FORMAT_OPTIONS (
    'header' = 'true'
); 

SHOW TABLES IN `ftw-week-06`.`01-raw`;