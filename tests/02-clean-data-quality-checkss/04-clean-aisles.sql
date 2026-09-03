-- AISLES CLEAN VALIDATION
-- Validates aisle identifiers, aisle names,
-- and the expected 'missing' category.

SELECT
    'unexpected_nulls' AS check_name,

    -- Every aisle must have an ID and a name.
    -- The 'missing' value is valid and is checked separately.
    COUNT_IF(
        aisle_id IS NULL
        OR aisle IS NULL
        OR TRIM(aisle) = ''
    ) AS actual_value,

    0 AS expected_value,

    CASE
        WHEN COUNT_IF(
            aisle_id IS NULL
            OR aisle IS NULL
            OR TRIM(aisle) = ''
        ) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END AS status

FROM `ftw-week-06`.`02-clean`.aisles_clean

UNION ALL

-- DUPLICATE CHECK
-- aisle_id uniquely identifies each aisle.
SELECT
    'duplicate_aisle_id',
    COUNT(*) - COUNT(DISTINCT aisle_id),
    0,
    CASE
        WHEN COUNT(*) - COUNT(DISTINCT aisle_id) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.aisles_clean

UNION ALL

-- INVALID VALUE CHECK
-- Aisle IDs must be positive and aisle names must not be blank.
SELECT
    'invalid_values',
    COUNT_IF(
        aisle_id <= 0
        OR TRIM(aisle) = ''
    ),
    0,
    CASE
        WHEN COUNT_IF(
            aisle_id <= 0
            OR TRIM(aisle) = ''
        ) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.aisles_clean

UNION ALL

-- EXPECTED VALUE
-- The 'missing' aisle is intentionally retained to represent
-- products whose aisle information is unavailable.
SELECT
    'expected_missing_aisle',
    COUNT_IF(aisle = 'missing'),
    1,
    CASE
        WHEN COUNT_IF(aisle = 'missing') = 1
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.aisles_clean;