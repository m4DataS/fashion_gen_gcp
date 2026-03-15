WITH Order_delivered AS (
SELECT 
  I.amount,
  I.order_id,
  I.product_id,
  OS.event_date,
  OS.status
FROM `s-data-defy.data_24S.items` AS I
RIGHT JOIN `s-data-defy.data_24S.orde_status` AS OS
  ON I.order_id = OS.order_id
WHERE OS.status='04_delivered'
),

FullInfo_Order_delivered AS (
SELECT 
  O.country,
  O.currency,
  Od.amount,
  Od.order_id,
  Od.product_id,
  Od.event_date,
  Od.status
FROM `s-data-defy.data_24S.orders` AS O
RIGHT JOIN Order_delivered AS Od
  ON O.order_id = Od.order_id
),

FullInfo_Order_delivered_withCurrency AS (
SELECT 
  C.eur_value,
  C.start_date,
  FOd.event_date,
  CASE 
    WHEN C.currency = 'GPB' THEN 'GBP'
    ELSE C.currency
  END AS corrected_currency,
  FOd.amount,
  FOd.order_id,
  FOd.product_id,
  FOd.status,
  ROW_NUMBER() OVER (PARTITION BY order_id, product_id ORDER BY start_date DESC) AS row_n
FROM `s-data-defy.data_24S.currency` AS C
RIGHT JOIN FullInfo_Order_delivered AS FOd
ON (
    CASE 
      WHEN C.currency = 'GPB' THEN 'GBP'
      ELSE C.currency
    END
) = (
    CASE 
      WHEN FOd.currency = 'GPB' THEN 'GBP'
      ELSE FOd.currency
    END
)
AND C.start_date <= FOd.event_date
),

final_step AS (
SELECT
  FOdwC.eur_value,
  FOdwC.start_date,
  FOdwC.event_date,
  FOdwC.corrected_currency,
  FOdwC.row_n,
  FOdwC.amount,
  FOdwC.order_id,
  FOdwC.product_id,
  FOdwC.status
FROM FullInfo_Order_delivered_withCurrency AS FOdwC
WHERE row_n = 1
ORDER BY order_id DESC
),

final_step_2 AS (
SELECT
  P.product_brand,
  fs.product_id,
  fs.eur_value,
  fs.amount
FROM final_step AS fs
INNER JOIN `s-data-defy.data_24S.products` AS P 
  ON fs.product_id = P.product_id
ORDER BY fs.order_id DESC
),

amount_per_brand AS (
SELECT 
  LOWER(product_brand) AS product_brand,
  SUM(amount * eur_value) AS total_amount
FROM final_step_2
GROUP BY product_brand
ORDER BY product_brand DESC
)

SELECT
  apb.product_brand,
  apb.total_amount,
  (apb.total_amount / total.total_amount) * 100 AS percentage
FROM amount_per_brand AS apb
CROSS JOIN (
  SELECT SUM(total_amount) AS total_amount
  FROM amount_per_brand
) AS total;