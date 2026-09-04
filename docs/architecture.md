# Architecture

## Architecture Overview

The project follows a **Raw ➡️ Clean ➡️ Mart** pipeline that transforms Instacart source data into an analytics-ready dimensional Star Schema model.

```text
       Instacart Source Data
                 │
                 ▼
          Raw (Landing)
                 │
                 ▼
         Raw Validation
                 │
                 ▼
      Clean (Standardized)
                 │
                 ▼
        Clean Validation
                 │
                 ▼
      Mart (Gold / Star Schema)
                 │
                 ▼
         Mart Validation
                 │
                 ▼
      Cross-Layer Validation
                 │
                 ▼
         Analysis Queries
                 │
                 ▼
         Visual Dashboard
```

Each stage has a defined role in data ingestion, transformation, validation, dimensional modeling, and business analysis.

> **Note:** Raw ➡️ Clean ➡️ Mart corresponds to the assignment's Bronze ➡️ Silver ➡️ Gold terminology.

---

## Data Layers

The pipeline separates source data, transformed data, and analytics-ready data into three distinct layers.

| Layer     | Purpose                                                                  | Main Tables                                                                                   |
| :-------- | :----------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------- |
| **Raw**   | Stores ingested source data with minimal transformation.                 | `products`, `aisles`, `departments`, `orders`, `order_products_prior`, `order_products_train` |
| **Clean** | Applies cleaning and standardization rules to prepare data for modeling. | `products_clean`, `aisles_clean`, `departments_clean`, `orders_clean`, `order_products_clean` |
| **Mart**  | Organizes cleaned data into an analytics-ready dimensional Star Schema.  | `dim_product`, `dim_order`, `fact_order_products`                                             |

The detailed dimensional model, including table grain, keys, and relationships, is documented separately in [`star-schema.md`](star-schema.md).

---

## Validation Framework

Data quality checks are integrated throughout the pipeline to identify data quality and integrity issues before downstream processing.

* **Layer-Specific Validation:** Validates the data within the Raw, Clean, and Mart layers.
* **Cross-Layer Validation:** Compares row counts across Raw, Clean, and Mart to identify unexpected changes during transformation.

Detailed validation rules and SQL implementations are maintained separately in the validation scripts.

---

## Incremental Loading Logic

The pipeline supports incremental processing when new data is added to the source.

```text
                       New Data Batch
                              │
                              ▼
                     Incremental Processing
                              │
             ┌────────────────┴────────────────┐
             ▼                                 ▼
      Dimension Records                  Transaction Records
             │                                 │
             ▼                                 ▼
           MERGE                       INSERT + Deduplication
             │                                 │
             └────────────────┬────────────────┘
                              ▼
                         Clean Layer
                              │
                              ▼
                         Mart Layer
```

Incremental processing identifies new or changed records and applies the appropriate loading strategy. This allows new data to be incorporated while preserving existing records and preventing duplicates.

---

## Analysis and Dashboard

The Mart layer serves as the primary source for downstream analysis and dashboarding.

Business-question queries use the dimensional Star Schema to generate analytical results, which are presented through interactive dashboards to communicate trends, comparisons, and business insights.
