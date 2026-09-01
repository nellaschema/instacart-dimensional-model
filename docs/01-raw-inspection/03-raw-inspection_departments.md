%md
## Departments - Data quality validation


| data quality check            | result |
| ----------------------------- | -----: |
| row count                     |     21 |
| missing `department_id`       |      0 |
| missing `department`          |      0 |
| empty `department`            |      0 |
| missing or empty `department` |      0 |
| encoded "missing" `department` |      1 |
| unique `department_id`        |     21 |
| invalid `department_id`       |      0 |

### findings

* all **21 rows** have a valid `department_id` and `department` name.
* no missing or empty department names were identified.
* **1 row contains the encoded value `"missing"` for `department`.**
* all `department_id` values are unique.
* no invalid or non-positive `department_id` values were identified.

overall, the `departments` dataset passed the defined completeness, uniqueness, and validity checks.

