### Departments Clean – Data Quality Validation

| Data quality check | Result |
|---|---:|
| Unexpected NULLs | 0 |
| Duplicate `department_id` | 0 |
| Invalid values | 0 |
| Expected `missing` department | 1 |

### Findings

- All departments have a valid `department_id` and department name.
- No duplicate `department_id` values were identified.
- No invalid department IDs or blank department names were identified.
- The `missing` department category is present **once**, as expected, to represent unavailable department information.
- **All validation checks passed.**