-- RAW → CLEAN → MART ROW COUNT VALIDATION
-- Compares row counts across the three data layers to verify
-- that records are preserved during the current transformation.
-- Separate status checks make it easier to identify where a mismatch occurs.

WITH row_counts AS (

    -- PRODUCTS
    -- Compares product row counts across Raw, Clean, and Mart
    -- to verify that the current transformation preserves all records.
    SELECT
        'products' AS table_name,

        -- Raw source row count
        (SELECT COUNT(*)
         FROM `ftw-week-06`.`01-raw`.products) AS raw_count,

        -- Cleaned product row count
        (SELECT COUNT(*)
         FROM `ftw-week-06`.`02-clean`.products_clean) AS clean_count,

        -- Mart dimension row count
        (SELECT COUNT(*)
         FROM `ftw-week-06`.`03-mart`.dim_product) AS mart_count

    UNION ALL

    -- ORDERS
    -- Compares order row counts across Raw, Clean, and Mart
    -- to verify that the current transformation preserves all records.
    SELECT
        'orders',

        -- Raw source row count
        (SELECT COUNT(*)
         FROM `ftw-week-06`.`01-raw`.orders),

        -- Cleaned order row count
        (SELECT COUNT(*)
         FROM `ftw-week-06`.`02-clean`.orders_clean),

        -- Mart dimension row count
        (SELECT COUNT(*)
         FROM `ftw-week-06`.`03-mart`.dim_order)

    UNION ALL

    -- ORDER PRODUCTS
    -- Raw order-product data is currently split into prior and train tables.
    -- Their combined row count is compared with the single Clean and Mart tables.
    SELECT
        'order_products',

        -- Combined Raw row count from prior and train
        (SELECT COUNT(*)
         FROM `ftw-week-06`.`01-raw`.order_products_prior)
        +
        (SELECT COUNT(*)
         FROM `ftw-week-06`.`01-raw`.order_products_train),

        -- Cleaned order-product row count
        (SELECT COUNT(*)
         FROM `ftw-week-06`.`02-clean`.order_products_clean),

        -- Mart fact table row count
        (SELECT COUNT(*)
         FROM `ftw-week-06`.`03-mart`.fact_order_products)
)

SELECT
    table_name,
    raw_count,
    clean_count,
    mart_count,

    -- Confirms whether the Raw and Clean row counts match.
    CASE
        WHEN raw_count = clean_count THEN 'PASS'
        ELSE 'FAIL'
    END AS raw_to_clean_status,

    -- Confirms whether the Clean and Mart row counts match.
    CASE
        WHEN clean_count = mart_count THEN 'PASS'
        ELSE 'FAIL'
    END AS clean_to_mart_status

FROM row_counts;