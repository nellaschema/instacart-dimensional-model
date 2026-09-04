### Order Products Clean – Data Quality Validation

| Data quality check | Result |
|---|---:|
| Unexpected NULLs | 0 |
| Duplicate `order_id` + `product_id` | 0 |
| Orphan order or product references | 0 |
| Invalid values | 0 |

### Findings

- All order-product records have values for `order_id`, `product_id`, `add_to_cart_order`, and `reordered`.
- No duplicate `order_id` + `product_id` combinations were identified.
- All `order_id` values have corresponding records in `orders_clean`, and all `product_id` values have corresponding records in `products_clean`.
- All `add_to_cart_order` values are valid, and `reordered` contains only `0` or `1`.
- **All validation checks passed.**