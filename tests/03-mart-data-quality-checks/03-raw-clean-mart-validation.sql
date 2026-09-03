-- BRONZE → SILVER → GOLD ROW COUNT COMPARISON

SELECT
    'products' AS table_name,
    (SELECT COUNT(*) FROM `ftw-week-06`.`01-raw`.products) AS raw_count,
    (SELECT COUNT(*) FROM `ftw-week-06`.`02-clean`.products_clean) AS clean_count,
    (SELECT COUNT(*) FROM `ftw-week-06`.`03-mart`.dim_product) AS mart_count,
    CASE
        WHEN
            (SELECT COUNT(*) FROM `ftw-week-06`.`01-raw`.products)
            =
            (SELECT COUNT(*) FROM `ftw-week-06`.`02-clean`.products_clean)
            AND
            (SELECT COUNT(*) FROM `ftw-week-06`.`02-clean`.products_clean)
            =
            (SELECT COUNT(*) FROM `ftw-week-06`.`03-mart`.dim_product)
        THEN 'PASS'
        ELSE 'FAIL'
    END AS status

UNION ALL

SELECT
    'orders',
    (SELECT COUNT(*) FROM `ftw-week-06`.`01-raw`.orders),
    (SELECT COUNT(*) FROM `ftw-week-06`.`02-clean`.orders_clean),
    (SELECT COUNT(*) FROM `ftw-week-06`.`03-mart`.dim_order),
    CASE
        WHEN
            (SELECT COUNT(*) FROM `ftw-week-06`.`01-raw`.orders)
            =
            (SELECT COUNT(*) FROM `ftw-week-06`.`02-clean`.orders_clean)
            AND
            (SELECT COUNT(*) FROM `ftw-week-06`.`02-clean`.orders_clean)
            =
            (SELECT COUNT(*) FROM `ftw-week-06`.`03-mart`.dim_order)
        THEN 'PASS'
        ELSE 'FAIL'
    END

UNION ALL

SELECT
    'order_products',
    (SELECT COUNT(*) FROM `ftw-week-06`.`01-raw`.order_products_prior)
        +
    (SELECT COUNT(*) FROM `ftw-week-06`.`01-raw`.order_products_train),
    (SELECT COUNT(*) FROM `ftw-week-06`.`02-clean`.order_products_clean),
    (SELECT COUNT(*) FROM `ftw-week-06`.`03-mart`.fact_order_products),
    CASE
        WHEN
            (
                (SELECT COUNT(*) FROM `ftw-week-06`.`01-raw`.order_products_prior)
                +
                (SELECT COUNT(*) FROM `ftw-week-06`.`01-raw`.order_products_train)
            )
            =
            (SELECT COUNT(*) FROM `ftw-week-06`.`02-clean`.order_products_clean)
            AND
            (SELECT COUNT(*) FROM `ftw-week-06`.`02-clean`.order_products_clean)
            =
            (SELECT COUNT(*) FROM `ftw-week-06`.`03-mart`.fact_order_products)
        THEN 'PASS'
        ELSE 'FAIL'
    END;