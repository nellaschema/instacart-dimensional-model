-- addressed github comment by sara: retain the nulls in the clean layer (row 6816)
-- Create products_clean only if it does not already exist.
-- WHERE 1 = 0 creates the table structure without loading any records.
CREATE TABLE IF NOT EXISTS `ftw-week-06`.`02-clean`.products_clean AS
SELECT
    product_id,
    product_name,
    aisle_id,
    department_id
FROM `ftw-week-06`.`01-raw`.products
WHERE 1 = 0;


-- Incrementally load new or updated products from the raw table.
-- MERGE prevents duplicate product_id values and updates existing
-- products if their information has changed.
MERGE INTO `ftw-week-06`.`02-clean`.products_clean AS target
USING `ftw-week-06`.`01-raw`.products AS source
ON target.product_id = source.product_id

-- Update the existing product when the same product_id is found in RAW.
WHEN MATCHED THEN UPDATE SET
    target.product_name = source.product_name,
    target.aisle_id = source.aisle_id,
    target.department_id = source.department_id

-- Insert the product when its product_id does not yet exist in CLEAN.
WHEN NOT MATCHED THEN INSERT (
    product_id,
    product_name,
    aisle_id,
    department_id
)
VALUES (
    source.product_id,
    source.product_name,
    source.aisle_id,
    source.department_id
);