-- Identify customers who have at least one funded savings and one funded investment plan
SELECT
  u.id AS owner_id,
  CONCAT(u.first_name, ' ', u.last_name) AS name,
  COALESCE(s.savings_count, 0) AS savings_count,
  COALESCE(i.investment_count, 0) AS investment_count,
  COALESCE(s.total_savings, 0) + COALESCE(i.total_investment, 0) AS total_deposits
FROM users_customuser u

-- Savings accounts aggregation
LEFT JOIN (
  SELECT
    sa.owner_id,
    COUNT(*) AS savings_count,
    SUM(sa.confirmed_amount) / 100.0 AS total_savings  -- converting kobo to base currency units
  FROM savings_savingsaccount sa
  JOIN plans_plan pl ON sa.plan_id = pl.id
  WHERE pl.is_regular_savings = 1 AND sa.confirmed_amount > 0
  GROUP BY sa.owner_id
) s ON u.id = s.owner_id

-- Investment plans aggregation
LEFT JOIN (
  SELECT
    sa.owner_id,
    COUNT(*) AS investment_count,
    SUM(sa.confirmed_amount) / 100.0 AS total_investment  -- converting kobo to base currency units
  FROM savings_savingsaccount sa
  JOIN plans_plan pl ON sa.plan_id = pl.id
  WHERE pl.is_a_fund = 1 AND sa.confirmed_amount > 0
  GROUP BY sa.owner_id
) i ON u.id = i.owner_id

-- Filter to only customers having at least one savings and one investment plan
WHERE COALESCE(s.savings_count, 0) > 0
  AND COALESCE(i.investment_count, 0) > 0

ORDER BY total_deposits DESC
LIMIT 1000;
