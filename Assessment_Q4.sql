-- Estimate Customer Lifetime Value based on tenure and transaction volume
WITH customer_transactions AS (
  SELECT
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    u.date_joined,
    COUNT(sa.id) AS total_transactions
  FROM users_customuser u
  LEFT JOIN savings_savingsaccount sa ON u.id = sa.owner_id
  GROUP BY u.id, u.first_name, u.last_name, u.date_joined
),

customer_tenure AS (
  SELECT
    customer_id,
    name,
    date_joined,
    total_transactions,
    TIMESTAMPDIFF(MONTH, date_joined, CURRENT_DATE) AS tenure_months
  FROM customer_transactions
  WHERE date_joined IS NOT NULL
)

SELECT
  customer_id,
  name,
  tenure_months,
  total_transactions,
  -- estimated CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
  ROUND(
    CASE 
      WHEN tenure_months > 0 THEN (total_transactions / tenure_months) * 12 * (0.001 * 100)  -- 0.1% profit per transaction, multiply by 100 for kobo to base unit
      ELSE total_transactions * (0.001 * 100)  -- if tenure 0, just total transactions * profit per transaction
    END, 2) AS estimated_clv
FROM customer_tenure
ORDER BY estimated_clv DESC;