-- models/staging/stg_shipping_lines.sql

WITH base AS (
    SELECT * FROM {{ ref("Main") }}
)

SELECT 
    orders.id as order_id,
    shipping_lines.id as shipping_line_id,
    tax_lines.price as tax_amount
FROM base AS orders
-- Pass the alias 'orders' as a string, and the columns as a list
{{ unnest_query('orders', ['shipping_lines', 'tax_lines']) }}