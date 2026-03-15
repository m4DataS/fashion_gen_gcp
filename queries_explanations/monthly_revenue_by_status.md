# Monthly Revenue by Payment Status

## Purpose
This query calculates monthly revenue for orders based on their status: **authorized (paid)** or **delivered**. It also converts all amounts into euros using historical currency rates.

## Step 1 – Select Orders by Status
The `Order_delivered` CTE filters the `items` and `orde_status` tables to keep orders that are either `04_delivered` or `02_authorized`.

## Step 2 – Add Order Metadata
The `FullInfo_Order_delivered` CTE joins the filtered orders with the `orders` table to retrieve:
- `country`
- `currency`

## Step 3 – Currency Conversion
The `FullInfo_Order_delivered_withCurrency` CTE:
- Joins with the `currency` table to get the correct EUR conversion rate (`eur_value`) per order.
- Corrects inconsistent currency codes (`GPB` → `GBP`).
- Uses `ROW_NUMBER()` to pick the most recent rate before the order’s event date, partitioned by `(order_id, product_id, status)`.

## Step 4 – Select Latest Exchange Rate
The `final_step` CTE keeps only the first row (`row_n = 1`) for each order-product-status combination to ensure accurate revenue calculation.

## Step 5 – Aggregate Revenue by Status
The `paiement_livraison` CTE sums the revenue per year, month, and status (authorized vs delivered).

## Step 6 – Human-readable Month & Final Aggregation
The `Result` CTE:
- Converts numeric months into French month names.
- Aggregates total revenue by status into `ChiffreAffairePaye` and `ChiffreAffaireLivre`.

## Notes
- Comments in the original SQL were used to check for **NULL values** in intermediate datasets.
- The workflow ensures **data integrity** before final aggregation.
- This query supports financial reporting on **paid vs delivered orders**.