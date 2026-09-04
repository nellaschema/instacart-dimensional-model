-- Create departments_clean only if it does not already exist.
-- WHERE 1 = 0 creates the table structure without loading any records.
CREATE TABLE IF NOT EXISTS `ftw-week-06`.`02-clean`.departments_clean AS
SELECT
    department_id,
    TRIM(department) AS department
FROM `ftw-week-06`.`01-raw`.departments
WHERE 1 = 0;


-- Incrementally load new or updated departments from the raw table.
-- MERGE prevents duplicate department_id values and updates existing
-- departments if their name changes.
MERGE INTO `ftw-week-06`.`02-clean`.departments_clean AS target
USING `ftw-week-06`.`01-raw`.departments AS source
ON target.department_id = source.department_id

-- Update the existing department when the same department_id is found in RAW.
WHEN MATCHED THEN UPDATE SET
    target.department = TRIM(source.department)

-- Insert the department when its department_id does not yet exist in CLEAN.
WHEN NOT MATCHED THEN INSERT (
    department_id,
    department
)
VALUES (
    source.department_id,
    TRIM(source.department)
);
