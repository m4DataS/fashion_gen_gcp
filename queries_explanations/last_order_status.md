# Latest Order Status Query

## Purpose
This query retrieves the most recent status recorded for each order.

## Method
1. A Common Table Expression (CTE) named `LastStatus` assigns a row number to each status event per `order_id`.
2. The `ROW_NUMBER()` window function partitions records by `order_id` and orders them by `status` in descending order.
3. Only the first row (`row_n = 1`) is kept, representing the latest status per order.

## Output
The result returns:
- `order_id`
- `status`
- `event_date`
- `row_n` (used internally to select the latest record)

The output is limited to the first 10 orders for preview purposes.