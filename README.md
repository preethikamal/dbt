# Shopify Data Transformation with dbt & BigQuery

This project focuses on building a robust staging layer for Shopify JSONL data within Google BigQuery. It addresses the complexities of handling deeply nested semi-structured data, deduplication of records, and modular SQL development using dbt (data build tool).

## Project Overview

The primary goal is to transform raw Shopify order data into a clean, flattened, and deduplicated format suitable for downstream analytics. The architecture follows dbt best practices by isolating raw data, applying transformations in a staging layer, and utilizing reusable macros for complex JSON unnesting.

## Key Features

### 1. Robust Staging Layer

* **JSONL Integration:** Handles Shopify's Newline Delimited JSON format.
* **Deduplication:** Implements logic to ensure `order_id` uniqueness by selecting the latest record based on `updated_at` timestamps using `ROW_NUMBER()` window functions.
* **Schema Enforcement:** Casts Shopify’s nested strings and floats into appropriate BigQuery types (`NUMERIC`, `TIMESTAMP`, `STRING`).

### 2. Custom Recursive Unnesting Macro

To handle Shopify's deeply nested arrays (e.g., `shipping_lines` containing `tax_lines`), a custom Jinja macro was developed:

* **`unnest_query`**: A dynamic macro that automates the `LEFT JOIN UNNEST` syntax. It allows for chaining nested paths (e.g., `orders` -> `shipping_lines` -> `tax_lines`) without manual repetition or syntax errors.

### 3. Error Handling & Optimization

* **Syntax Resolution:** Resolved complex Jinja rendering issues related to nested expression tags and spacing in loop logic.
* **Column Aliasing:** Implemented strict aliasing to prevent "duplicate column name" errors common when unnesting multiple currency or amount fields (Presentment vs. Shop money).

## Project Structure

* **`models/staging/`**: Contains the SQL models for staging orders, shipping lines, and tax sets.
* **`macros/`**: Contains the `unnest_query.sql` and other utility macros for flattening Shopify's nested structures.
* **`dbt_project.yml`**: Configuration for the dbt environment and BigQuery connection.

## Implementation Details

### Example: Deduplication Logic

```sql
WITH deduplicated AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY id 
            ORDER BY updated_at DESC
        ) as row_num
    FROM {{ ref('raw_source') }}
)
SELECT * EXCEPT(row_num) FROM deduplicated WHERE row_num = 1

```

### Example: Macro Usage

```sql
{{ unnest_query('orders', ['shipping_lines', 'tax_lines']) }}

```


```



