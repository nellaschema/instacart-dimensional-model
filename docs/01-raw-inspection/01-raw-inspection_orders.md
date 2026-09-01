%md
## Orders - Data quality validation

| data quality check                   |    result |
| ------------------------------------ | --------: |
| row count                            | 3,421,083 |
| missing `order_id`                   |         0 |
| missing `user_id`                    |         0 |
| missing `eval_set`                   |         0 |
| missing `order_number`               |         0 |
| missing `order_dow`                  |         0 |
| missing `order_hour_of_day`          |         0 |
| missing `days_since_prior_order`     |   206,209 |
| unique `order_id`                    | 3,421,083 |
| unique `user_id`                     |   206,209 |
| duplicate `order_id` | 0 |
| unique `eval_set` | 3 |
| invalid `order_dow`                  |         0 |
| invalid `order_hour_of_day`          |         0 |
| invalid `order_number`               |         0 |
| negative `days_since_prior_order`    |         0 |
| `days_since_prior_order` above 30    |         0 |
| first order with prior order         |         0 |
| subsequent order without prior order |         0 |

### findings

* all **3,421,083 rows** have values for the required order fields.
* all `order_id` values are unique, with **3,421,083 unique orders**.
* the dataset contains **206,209 unique users**.
* `order_dow` values are within the expected range of **0–6**.
* `order_hour_of_day` values are within the expected range of **0–23**.
* all `order_number` values are valid.
* no duplicate `order_id` values were identified.
* `days_since_prior_order` contains **206,209 null values**, with no negative values or values above 30.
* the dataset contains **3 unique `eval_set` values**.
* no first orders incorrectly contain a prior-order value.
* no subsequent orders are missing `days_since_prior_order`.

overall, the `orders` dataset passed the checks. the null `days_since_prior_order` values are consistent with first orders and therefore do not indicate a data-quality issue
