%md
## Products - Data quality validation

| data quality check              | result |
| ------------------------------- | -----: |
| row count                       | 49,688 |
| missing `product_id`            |      0 |
| missing `product_name`          |      0 |
| empty `product_name`            |      0 |
| missing or empty `product_name` |      0 |
| missing `aisle_id`              |      1 |
| missing `department_id`         |      1 |
| unique `product_id`             | 49,688 |
| unique `aisle_id`               |    134 |
| unique `department_id`          |     21 |
| invalid `product_id`            |      0 |
| invalid `aisle_id`              |      0 |
| invalid `department_id`         |      0 |

### findings

* all **49,688 rows** have a valid `product_id` and `product_name`.
* all `product_id` values are unique.
* no empty or missing product names were identified.
* the dataset contains **134 unique aisles** and **21 unique departments**.
* **1 row** has a missing `aisle_id`, and **1 row** has a missing `department_id`.
* no invalid or non-positive product, aisle, or department identifiers were identified.

overall, the `products` dataset passed the defined completeness, uniqueness, and validity checks. 

the two missing foreign-key values was reviewed:

- products.aisle_id → should match an aisle_id in the `aisles` table.
- products.department_id → should match a department_id in the `departments` table.

however, the corresponding values could not be determined from the available reference data (aisles and department tables do not contain product id) so the values are retained as `-1` (unknown) rather than being arbitrarily assigned.
