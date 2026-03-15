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
WHERE OS.status='04_delivered' OR OS.status='02_authorized'
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
  ROW_NUMBER() OVER (PARTITION BY order_id, product_id, status ORDER BY start_date DESC) AS row_n
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

paiement_livraison AS (
SELECT 
  EXTRACT(YEAR FROM event_date) AS year,
  EXTRACT(MONTH FROM event_date) AS month,
  status,
  SUM(amount * eur_value) AS total_amount
FROM final_step
GROUP BY year, month, status
ORDER BY year, month, status
),

Result AS (
SELECT
    CASE
        WHEN month = 1 THEN 'janvier'
        WHEN month = 2 THEN 'février'
        WHEN month = 3 THEN 'mars'
        WHEN month = 4 THEN 'avril'
        WHEN month = 5 THEN 'mai'
        WHEN month = 6 THEN 'juin'
        WHEN month = 7 THEN 'juillet'
        WHEN month = 8 THEN 'août'
        WHEN month = 9 THEN 'septembre'
        WHEN month = 10 THEN 'octobre'
        WHEN month = 11 THEN 'novembre'
        WHEN month = 12 THEN 'décembre'
        ELSE 'Unknown'
    END AS month_string,
    year,
    SUM(CASE WHEN status = '02_authorized' THEN total_amount ELSE 0 END) AS ChiffreAffairePaye,
    SUM(CASE WHEN status = '04_delivered' THEN total_amount ELSE 0 END) AS ChiffreAffaireLivre
FROM paiement_livraison
GROUP BY year, month
ORDER BY year, month
)

SELECT *
FROM Result;