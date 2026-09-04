### Cross-Layer Row Count Validation

| Table | Raw Count | Clean Count | Mart Count | Status |
|---|---:|---:|---:|---|
| `products` | 49,688 | 49,688 | 49,688 | PASS |
| `orders` | 3,421,083 | 3,421,083 | 3,421,083 | PASS |
| `order_products` | 33,819,106 | 33,819,106 | 33,819,106 | PASS |

### Findings

- `products` maintains the same **49,688 records** across the Raw, Clean, and Mart layers.
- `orders` maintains the same **3,421,083 records** across all three layers.
- `order_products` maintains the same **33,819,106 records** across all three layers.
- No unexpected record loss or duplication was identified between layers.
- **All cross-layer row count checks passed.**