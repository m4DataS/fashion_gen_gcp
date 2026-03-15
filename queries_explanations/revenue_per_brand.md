# Revenue per Brand

## Purpose
This query calculates the total revenue per product brand for delivered orders and expresses each brand’s revenue as a percentage of the total.

## Step 1 – Select Delivered Orders
The `Order_delivered` CTE filters items with status `04_delivered` from the `items` and `orde_status` tables.

## Step 2 – Enrich Orders with Metadata
The `FullInfo_Order_delivered` CTE joins with the `orders` table to retrieve additional information such as `country` and `currency`.

## Step 3 – Currency Conversion
The `FullInfo_Order_delivered_withCurrency` CTE:
- Joins with the `currency` table to get the EUR conversion rate (`eur_value`) at the order date.
- Corrects currency codes (`GPB` → `GBP`).
- Uses `ROW_NUMBER()` to pick the most recent exchange rate per `(order_id, product_id)`.

## Step 4 – Join Product Information
The `final_step_2` CTE joins with the `products` table to get the `product_brand` for each product.
- Only valid product IDs are included (INNER JOIN).
- Product brand names are normalized to lowercase in the next step.

## Step 5 – Aggregate Revenue per Brand
The `amount_per_brand` CTE sums the revenue (`amount * eur_value`) per brand.
- Brand names are normalized with `LOWER()` to handle inconsistencies (e.g., `'Louis Vuitton'` vs `'louis vuitton'`).

## Step 6 – Compute Percentage Contribution
The final query calculates:
- Total revenue per brand (`total_amount`)
- Each brand’s revenue as a percentage of the total revenue (`percentage`)

## Notes
- Original comments were used to validate missing values and handle product-brand inconsistencies.
- This query is useful for **brand-level revenue analysis**, business reporting, and identifying top-performing brands.