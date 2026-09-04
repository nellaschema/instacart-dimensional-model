### Orders Clean – Data Quality Validation

| Data quality check | Result |
|---|---:|
| Unexpected NULLs | 0 |
| Duplicate `order_id` | 0 |
| Invalid values | 0 |
| Expected NULL `days_since_prior_order` | 206,209 |

### Findings

- All required order fields are populated, except `days_since_prior_order` for first orders.
- No duplicate `order_id` values were identified.
- All IDs, order sequences, day/hour values, and `eval_set` values are valid.
- `days_since_prior_order` contains **206,209 NULL values**, which is expected for first orders.
- **All validation checks passed.**