# Architecture

## 1. Architecture Overview

The project follows a **Raw → Clean → Mart → Analytics → Dashboard** pipeline that transforms Instacart source data into an analytics-ready dimensional model.

![Instacart Data Pipeline Architecture](https://github.com/user-attachments/assets/64f5ffbd-d830-473f-a5f7-ce8cc043c1c5)

Each layer has a defined role in data ingestion, transformation, modeling, analysis, and reporting.

---

## 2. Data Layer & Tables

| Layer         | Purpose                                                     | Main Tables / Outputs                                                                         |
| ------------- | ----------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| **Raw**       | Stores source data with minimal transformation.             | `products`, `aisles`, `departments`, `orders`, `order_products_prior`, `order_products_train` |
| **Clean**     | Cleans and standardizes data for modeling.                  | `products_clean`, `aisles_clean`, `departments_clean`, `orders_clean`, `order_products_clean` |
| **Mart**      | Organizes cleaned data into an analytics-ready Star Schema. | `dim_product`, `dim_order`, `fact_order_products`                                             |
| **Analytics** | Applies business logic and generates analytical results.    | Analysis queries / outputs                                                                    |
| **Dashboard** | Presents KPIs, trends, and business insights.               | Visualizations                                                                                |

---

## 3. Grain & Keys

| Table                  | Grain                               | Key                     |
| ---------------------- | ----------------------------------- | ----------------------- |
| `orders_clean`         | One row per order                   | `order_id`              |
| `products_clean`       | One row per product                 | `product_id`            |
| `aisles_clean`         | One row per aisle                   | `aisle_id`              |
| `departments_clean`    | One row per department              | `department_id`         |
| `order_products_clean` | One row per product within an order | `order_id + product_id` |
| `dim_order`            | One row per order                   | `order_id`              |
| `dim_product`          | One row per product                 | `product_id`            |
| `fact_order_products`  | One row per product within an order | `order_id + product_id` |

The `order_id + product_id` combination serves as the composite key for order-product records.

Aisle and department information are included directly in dim_product to simplify downstream queries and joins, as they are primarily used as product classification attributes in this project.

---

## 4. Loading & Incremental Strategy

Loading strategies are selected based on table behavior and size.

| Table                  | Strategy                     | Behavior                               |
| ---------------------- | ---------------------------- | -------------------------------------- |
| `orders_clean`         | `MERGE`                      | Insert new and update existing records |
| `products_clean`       | `MERGE`                      | Insert new and update existing records |
| `aisles_clean`         | `MERGE`                      | Insert new and update existing records |
| `departments_clean`    | `MERGE`                      | Insert new and update existing records |
| `order_products_clean` | `INSERT INTO` + `NOT EXISTS` | Append new records without duplicates  |
| `dim_product`          | `CREATE OR REPLACE`          | Rebuild the relatively small dimension |
| `dim_order`            | `MERGE`                      | Insert new and update existing records |
| `fact_order_products`  | `INSERT INTO` + `NOT EXISTS` | Append new records without duplicates  |

`NOT EXISTS` prevents existing order-product records from being duplicated when transformations are rerun.

---

## 5. Validation Framework

Validation is performed throughout the pipeline to check data quality and integrity.

* **Layer-specific validation** checks data within the Raw, Clean, and Mart layers.
* **Cross-layer validation** compares row counts to identify unexpected record loss or duplication.
* **Key validation** checks the uniqueness of defined keys and composite keys.

Detailed validation rules and SQL implementations are maintained separately.

---

## 6. Analysis & Dashboard

The **Mart layer** serves as the primary source for downstream analysis.

Analysis queries use the dimensional model to answer the project's business questions. The resulting outputs are used to create dashboard visualizations and communicate purchasing patterns, product performance, and reorder behavior.
