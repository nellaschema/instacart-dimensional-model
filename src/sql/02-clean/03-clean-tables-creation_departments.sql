-- create departments_clean

CREATE OR REPLACE TABLE `ftw-week-06`.`02-clean`.departments_clean AS
SELECT
    department_id,
    TRIM(department) AS department
FROM `ftw-week-06`.`01-raw`.departments
