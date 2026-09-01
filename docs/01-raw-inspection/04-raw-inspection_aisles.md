%md
## Aisles - Data quality validation

| data quality check | result |
| ------------------ | -----: |
| row count | 134 |
| missing `aisle_id` | 0 |
| missing `aisle` | 0 |
| empty `aisle` | 0 |
| missing or empty `aisle` | 0 |
| encoded missing `aisle` | 1 |
| unique `aisle_id` | 134 |
| invalid `aisle_id` | 0 |

### findings

* all **134 rows** have a valid `aisle_id`.
* no NULL or empty aisle names were identified.
* **1 row contains the encoded value `"missing"` for `aisle`.**
* all `aisle_id` values are unique.
* no invalid or non-positive `aisle_id` values were identified.

overall, the `aisles` dataset passed the defined completeness, uniqueness, and validity checks, with **1 encoded missing aisle value** identified for tracking.