-- Create aisles_clean only if it does not already exist.
-- WHERE 1 = 0 creates the table structure without loading any records.
CREATE TABLE IF NOT EXISTS `ftw-week-06`.`02-clean`.aisles_clean AS
SELECT
    aisle_id,
    TRIM(aisle) AS aisle
FROM `ftw-week-06`.`01-raw`.aisles
WHERE 1 = 0;


-- Incrementally load new or updated aisles from the raw table.
-- MERGE prevents duplicate aisle_id values and updates existing records
-- if the aisle name has changed.
MERGE INTO `ftw-week-06`.`02-clean`.aisles_clean AS target
USING `ftw-week-06`.`01-raw`.aisles AS source
ON target.aisle_id = source.aisle_id

-- Update the aisle name if the aisle_id already exists.
WHEN MATCHED THEN UPDATE SET
    target.aisle = TRIM(source.aisle)

-- Insert the aisle if the aisle_id does not yet exist.
WHEN NOT MATCHED THEN INSERT (
    aisle_id,
    aisle
)
VALUES (
    source.aisle_id,
    TRIM(source.aisle)
);