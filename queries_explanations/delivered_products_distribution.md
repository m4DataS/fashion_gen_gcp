# Delivered Products Distribution by Family

## Purpose
This query calculates the distribution of delivered products across different product families.

## Step 1 – Select Delivered Orders
The `Order_delivered` CTE filters the `items` and `orde_status` tables to keep only orders with status `04_delivered`.

## Step 2 – Join with Product Information
The `Prod_order_delivered` CTE joins delivered orders with the `products` table to add:
- `product_family`
- `product_brand`

Notes:
- An **INNER JOIN** is used to ensure only products with valid entries in the `products` table are included.
- Some items may not have a corresponding product entry; those are excluded.

## Step 3 – Aggregate and Compute Distribution
The final query:
- Counts the number of delivered products per `product_family`.
- Computes the percentage of each family relative to the total delivered products.
- Orders results by the number of delivered products in descending order.

## Notes
- Original comments were used to check for **NULL values** and handle missing product records.
- This query helps understand which product families dominate delivered orders and can support inventory or sales analysis.