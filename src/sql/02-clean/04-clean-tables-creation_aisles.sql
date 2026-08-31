-- create aisles_clean
CREATE OR REPLACE TABLE `ftw-week-06`.`02-clean`.aisles_clean AS
SELECT
    aisle_id,
    TRIM(aisle) AS aisle
FROM `ftw-week-06`.`01-raw`.aisles