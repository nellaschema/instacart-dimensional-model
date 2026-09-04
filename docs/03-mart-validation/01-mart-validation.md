### Mart Layer – Data Quality Validation

| Table | NULLs | Duplicates | Referential Integrity | Invalid Values |
|---|---:|---:|---:|---:|
| `dim_product` | 0 | 0 | 0 | 0 |
| `dim_order` | 0 | 0 | 0 | 0 |
| `fact_order_products` | 0 | 0 | 0 | 0 |

### Findings

- `dim_product` contains no unexpected NULLs, duplicate products, or invalid values.
- `dim_order` contains no unexpected NULLs, duplicate `order_id` values, or invalid order attributes.
- `fact_order_products` contains no unexpected NULLs or duplicate `order_id` + `product_id` combinations.
- All order-product records have valid references to `dim_order` and `dim_product`.
- No invalid order-product values were identified.
- **All Mart layer validation checks passed.**