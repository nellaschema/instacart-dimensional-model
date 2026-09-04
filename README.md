# Instacart Dimensional Model

## Overview

This project transforms the Instacart dataset into a dimensional model designed for analytics and reporting.

The pipeline follows a Medallion Architecture:

```text
Raw Data
   ↓
Bronze
   ↓
Silver / Clean
   ↓
Gold / Mart
   ↓
Dimensional Model
```

The final model uses a star-schema structure to analyze customer ordering behavior, product popularity, and reordering patterns.

## Data Model

The dimensional model consists of one fact table and two dimension tables.

<img width="1066" height="488" alt="image" src="https://github.com/user-attachments/assets/fb70dac5-e1aa-4743-8548-9d9520b3c36a" />


### Fact: `fact_order_product`

The fact table represents the relationship between an order and the products included in that order.

| Column              | Description                                          |
| ------------------- | ---------------------------------------------------- |
| `order_id`          | Foreign key to `dim_order`                           |
| `product_id`        | Foreign key to `dim_product`                         |
| `add_to_cart_order` | Position in which the product was added to the cart  |
| `reordered`         | Indicates whether the product was previously ordered |

The grain of the fact table is:

> **One product within one order.**

This grain allows analysis of product-level purchasing and reordering behavior.

### Dimension: `dim_order`

Contains order-level attributes used to analyze when and how customers place orders.

| Column                   | Description                              |
| ------------------------ | ---------------------------------------- |
| `order_id`               | Primary key                              |
| `user_id`                | Customer identifier                      |
| `order_dow`              | Day of week when the order was placed    |
| `order_hour_of_day`      | Hour when the order was placed           |
| `days_since_prior_order` | Days since the customer's previous order |

This dimension supports analyses such as:

* Orders by day of week
* Orders by hour of day
* Customer ordering patterns
* Time between consecutive orders

### Dimension: `dim_product`

Contains product-level descriptive attributes.

| Column         | Description        |
| -------------- | ------------------ |
| `product_id`   | Primary key        |
| `product_name` | Product name       |
| `aisle`        | Product aisle      |
| `department`   | Product department |

Aisle and department are flattened into `dim_product` rather than modeled as separate dimensions because they serve as descriptive attributes of a product in this analytical model.

The source `aisle_id` and `department_id` are retained in the clean layer for lookup and transformation purposes but are not required in the final dimensional model.

## Handling Missing Values

Products with missing or unmatched aisle or department information should not be removed from the product dimension.

`LEFT JOIN` is used when enriching products with aisle and department information so that every product remains represented in `dim_product`.

Missing categorical values can be represented as:

```text
Unknown
```

rather than `NULL`, making downstream analytical queries easier to interpret.

## Data Quality

Data quality checks were performed on the cleaned datasets before building the dimensional model.

Key checks include:

* Row counts
* Null values in key columns
* Uniqueness of primary keys
* Referential integrity
* Validity of categorical values
* Consistency between source IDs and descriptive attributes

For the product data, `product_id` is expected to uniquely identify each product.

## Example Analytical Questions

The dimensional model supports questions such as:

1. What products are ordered most frequently?
2. Which products have the highest reorder rates?
3. How does purchasing behavior vary by day of week?
4. What hours have the highest order volume?
5. Which departments have the highest number of orders?
6. Which aisles have the highest reorder rates?
7. How does reorder behavior vary across departments?
8. How long do customers typically wait between orders?

## Technology

* Python
* SQL
* Databricks
  * Apache Spark
  * Delta Lake
* GitHub

## Project Structure

```text
01-raw/
    Raw Instacart datasets

02-clean/
    Cleaned and validated datasets

03-mart/
    fact_order_product
    dim_order
    dim_product

04-analytics/
    Business analytics queries

instacart-test-queries/
    Development and testing queries
```

## Architecture

The project separates data processing from analytical modeling:

<img width="1672" height="941" alt="image" src="https://github.com/user-attachments/assets/db704852-6422-4749-980f-c8323f40c2d8" />


## Key Design Decision

The model uses a **star schema** rather than reproducing the source database structure.

The fact table stores the measurable order-product relationship, while dimensions provide descriptive context for analysis.

Aisle and department are treated as product attributes rather than separate dimensions, keeping the model simple while retaining the information needed for the intended analytical use cases.
