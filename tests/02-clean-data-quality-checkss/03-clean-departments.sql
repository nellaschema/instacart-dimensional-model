-- DEPARTMENTS CLEAN VALIDATION
-- Validates department identifiers, department names,
-- and the expected 'missing' category.

SELECT
    'unexpected_nulls' AS check_name,

    -- Every department must have an ID and a name.
    -- The 'missing' value is valid and is checked separately.
    COUNT_IF(
        department_id IS NULL
        OR department IS NULL
        OR TRIM(department) = ''
    ) AS actual_value,

    0 AS expected_value,

    CASE
        WHEN COUNT_IF(
            department_id IS NULL
            OR department IS NULL
            OR TRIM(department) = ''
        ) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END AS status

FROM `ftw-week-06`.`02-clean`.departments_clean

UNION ALL

-- DUPLICATE CHECK
-- department_id uniquely identifies each department.
SELECT
    'duplicate_department_id',
    COUNT(*) - COUNT(DISTINCT department_id),
    0,
    CASE
        WHEN COUNT(*) - COUNT(DISTINCT department_id) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.departments_clean

UNION ALL

-- INVALID VALUE CHECK
-- Department IDs must be positive and names must not be blank.
SELECT
    'invalid_values',
    COUNT_IF(
        department_id <= 0
        OR TRIM(department) = ''
    ),
    0,
    CASE
        WHEN COUNT_IF(
            department_id <= 0
            OR TRIM(department) = ''
        ) = 0
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.departments_clean

UNION ALL

-- EXPECTED VALUE
-- The 'missing' department is intentionally retained to represent
-- products whose department information is unavailable.
SELECT
    'expected_missing_department',
    COUNT_IF(department = 'missing'),
    1,
    CASE
        WHEN COUNT_IF(department = 'missing') = 1
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`02-clean`.departments_clean;