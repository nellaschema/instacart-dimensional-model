-- EXPECTED CATEGORY VALUE VALIDATION
-- Missing category values are intentionally retained from the source data.
-- In the Mart layer, NULL category values are converted to 'Unknown'.
-- Expected counts are based on the validated Clean layer and Mart transformation.

SELECT
    -- 1,258 products are expected to have no aisle classification
    'missing_aisle' AS check_name,
    COUNT_IF(aisle = 'missing') AS actual_value,
    1258 AS expected_value,
    CASE
        WHEN COUNT_IF(aisle = 'missing') = 1258
        THEN 'PASS'
        ELSE 'FAIL'
    END AS status
FROM `ftw-week-06`.`03-mart`.dim_product

UNION ALL

SELECT
    -- 1,258 products are expected to have no department classification
    'missing_department',
    COUNT_IF(department = 'missing'),
    1258,
    CASE
        WHEN COUNT_IF(department = 'missing') = 1258
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`03-mart`.dim_product

UNION ALL

SELECT
    -- 1 product had a NULL aisle in Clean and is expected to become 'Unknown' in the Mart
    'unknown_aisle',
    COUNT_IF(aisle = 'Unknown'),
    1,
    CASE
        WHEN COUNT_IF(aisle = 'Unknown') = 1
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`03-mart`.dim_product

UNION ALL

SELECT
    -- 1 product had a NULL department in Clean and is expected to become 'Unknown' in the Mart
    'unknown_department',
    COUNT_IF(department = 'Unknown'),
    1,
    CASE
        WHEN COUNT_IF(department = 'Unknown') = 1
        THEN 'PASS'
        ELSE 'FAIL'
    END
FROM `ftw-week-06`.`03-mart`.dim_product;