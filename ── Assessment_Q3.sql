SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    MAX(s.created_on) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE, MAX(s.created_on)) AS inactivity_days
FROM 
    plans_plan p
LEFT JOIN 
    savings_savingsaccount s ON p.id = s.plan_id
WHERE 
    p.is_deleted = 0 
    AND p.is_archived = 0
    AND p.status_id = 1  -- Active plans only
GROUP BY 
    p.id, p.owner_id, type
HAVING 
    last_transaction_date IS NULL  -- No transactions at all
    OR DATEDIFF(CURRENT_DATE, last_transaction_date) > 365
ORDER BY 
    inactivity_days DESC;
    