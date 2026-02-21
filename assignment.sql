-- ============================
-- TASK 3: Analytics Views 
-- ============================ 
-- View: offer received vs completed summary

CREATE OR REPLACE VIEW offer_summary AS
SELECT
    e.offer_id,
    COUNT(*) FILTER (WHERE e.event = 'offer received') AS received_count,
    COUNT(*) FILTER (WHERE e.event = 'offer completed') AS completed_count,
    CASE
        WHEN COUNT(*) FILTER (WHERE e.event = 'offer received') = 0 THEN NULL
        ELSE ROUND(
            COUNT(*) FILTER (WHERE e.event = 'offer completed')::NUMERIC
            / COUNT(*) FILTER (WHERE e.event = 'offer received'),
            3
        )
    END AS completion_rate
FROM events e
GROUP BY e.offer_id;


-- View: informational offers followed by transactions
CREATE OR REPLACE VIEW informational_offer_transactions AS 
SELECT 
    o.offer_id, 
	COUNT(DISTINCT e_txn.event_id) AS transaction_count 
FROM offers o 
JOIN events e_recv 
     ON e_recv.offer_id = o.offer_id 
	 AND e_recv.event = 'offer received' 
JOIN events e_txn 
    ON e_txn.customer_id = e_recv.customer_id 
	AND e_txn.event = 'transaction' 
	AND e_txn.time > e_recv.time 
WHERE o.offer_type = 'informational' 
GROUP BY o.offer_id;


-- ============================ 
-- TASK 4: Demographic Bucketing 
-- ============================


-- Income buckets 
ALTER TABLE customers 
  ADD COLUMN income_bucket TEXT;
  
UPDATE customers
SET income_bucket = CASE 
  WHEN income IS NULL THEN 'Unknown'
  WHEN income < 40000 THEN 'Low' 
  WHEN income BETWEEN 40000 AND 80000 THEN 'Medium'
  WHEN income > 80000 THEN 'High' 
END;


-- Age groups 
ALTER TABLE customers 
   ADD COLUMN age_group TEXT; 

UPDATE customers 
SET age_group = CASE 
WHEN age IS NULL THEN 'Unknown' 
WHEN age < 25 THEN '18-24' 
WHEN age BETWEEN 25 AND 34 THEN '25-34' 
WHEN age BETWEEN 35 AND 44 THEN '35-44' 
WHEN age BETWEEN 45 AND 54 THEN '45-54' 
WHEN age >= 55 THEN '55+' 
WHEN age <= 100 THEN '60+'
        ELSE 'Outlier'
END;