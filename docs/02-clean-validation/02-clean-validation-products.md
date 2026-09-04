### Products Clean – Data Quality Validation

| Data quality check | Result |
|---|---:|
| Unexpected NULLs | 0 |
| Duplicate `product_id` | 0 |
| Duplicate `product_name` | 0 |
| Orphan category references | 0 |
| Invalid values | 0 |
| Expected NULL `aisle_id` | 1 |
| Expected NULL `department_id` | 1 |

### Findings

- All products have a valid `product_id` and `product_name`.
- No duplicate `product_id` or `product_name` values were identified.
- All non-NULL `aisle_id` and `department_id` values have valid references in their respective category tables.
- No invalid product, aisle, or department values were identified.
- `aisle_id` contains **1 NULL value**, which is expected based on the source data.
- `department_id` contains **1 NULL value**, which is expected based on the source data.
- **All validation checks passed.**