WITH LastStatus AS (
  SELECT 
    order_id,
    status,
    event_date,
    ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY status DESC) as row_n
  FROM `s-data-defy.data_24S.orde_status`
)
SELECT  
  order_id,
  status,
  event_date,
  row_n
FROM LastStatus
WHERE row_n = 1
ORDER BY order_id ASC
LIMIT 10;