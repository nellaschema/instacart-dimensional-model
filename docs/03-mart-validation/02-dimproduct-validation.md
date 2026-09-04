### Expected Category Value Validation

| Data quality check | Result |
|---|---:|
| Expected `missing` aisle | 1,258 |
| Expected `missing` department | 1,258 |
| Expected `Unknown` aisle | 1 |
| Expected `Unknown` department | 1 |

### Findings

- The Mart contains **1,258 products** with the `missing` aisle category, matching the expected count from the Clean layer.
- The Mart contains **1,258 products** with the `missing` department category, matching the expected count.
- The **1 product** with a NULL `aisle_id` in the Clean layer was correctly converted to `Unknown` in the Mart.
- The **1 product** with a NULL `department_id` in the Clean layer was correctly converted to `Unknown` in the Mart.
- **All expected category value checks passed.**