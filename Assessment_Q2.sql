-- Calculate average transactions per customer per month and categorize frequency
WITH transactions_per_customer AS (
  SELECT
    owner_id,
    COUNT(*) AS total_transactions,
    -- Calculate months active as months between first and last transaction (or at least 1)
    GREATEST(
      TIMESTAMPDIFF(MONTH, MIN(transaction_date), MAX(transaction_date)),
      1
    ) AS months_active
  FROM savings_savingsaccount
  GROUP BY owner_id
),
transactions_per_month AS (
  SELECT
    owner_id,
    total_transactions,
    months_active,
    total_transactions / months_active AS avg_transactions_per_month
  FROM transactions_per_customer
)
SELECT
  CASE
    WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
    WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
    ELSE 'Low Frequency'
  END AS frequency_category,
  COUNT(*) AS customer_count,
  ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM transactions_per_month
GROUP BY frequency_category
ORDER BY
  CASE frequency_category
    WHEN 'High Frequency' THEN 1
    WHEN 'Medium Frequency' THEN 2
    ELSE 3
  END;
