-- inspect departments
SELECT
    COUNT(*) AS row_count,

    -- completeness
    COUNT_IF(department_id IS NULL) AS missing_department_id,
    COUNT_IF(department IS NULL) AS missing_department,
    COUNT_IF(TRIM(department) = '') AS empty_department,
    COUNT_IF(
        department IS NULL OR TRIM(department) = ''
    ) AS missing_or_empty_department,

    -- uniqueness
    COUNT(DISTINCT department_id) AS unique_department_id,

    -- validity
    COUNT_IF(department_id <= 0) AS invalid_department_id

FROM `ftw-week-06`.`01-raw`.departments;