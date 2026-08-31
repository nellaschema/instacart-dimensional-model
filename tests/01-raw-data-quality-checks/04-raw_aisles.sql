-- inspect aisles
SELECT
    COUNT(*) AS row_count,

    -- completeness
    COUNT_IF(aisle_id IS NULL) AS missing_aisle_id,
    COUNT_IF(aisle IS NULL) AS missing_aisle,
    COUNT_IF(TRIM(aisle) = '') AS empty_aisle,
    COUNT_IF(
        aisle IS NULL OR TRIM(aisle) = ''
    ) AS missing_or_empty_aisle,

    -- uniqueness
    COUNT(DISTINCT aisle_id) AS unique_aisle_id,

    -- validity
    COUNT_IF(aisle_id <= 0) AS invalid_aisle_id

FROM `ftw-week-06`.`01-raw`.aisles;