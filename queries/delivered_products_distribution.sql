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

Prod_order_delivered AS (
SELECT 
  Od.order_id,
  Od.product_id,
  Od.event_date,
  Od.status,
  P.product_family,
  P.product_brand
FROM Order_delivered AS Od
INNER JOIN `s-data-defy.data_24S.products` AS P
  ON P.product_id = Od.product_id
)

SELECT 
  product_family,
  COUNT(*) AS num_delivered_products,
  (COUNT(*) * 100.0) / SUM(COUNT(*)) OVER () AS distribution_percentage
FROM Prod_order_delivered 
GROUP BY product_family
ORDER BY num_delivered_products DESC;