WITH monthly_transactions AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS transaction_count,
        COUNT(DISTINCT DATE_FORMAT(s.created_on, '%Y-%m')) AS active_months,
        COUNT(*) / COUNT(DISTINCT DATE_FORMAT(s.created_on, '%Y-%m')) AS avg_monthly_transactions
    FROM 
        savings_savingsaccount s
    WHERE 
        s.confirmed_amount > 0  -- Only successful transactions
    GROUP BY 
        s.owner_id
)
SELECT 
    CASE 
        WHEN avg_monthly_transactions >= 10 THEN 'High Frequency'
        WHEN avg_monthly_transactions >= 3 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_monthly_transactions), 1) AS avg_transactions_per_month
FROM 
    monthly_transactions
GROUP BY 
    frequency_category
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;
    