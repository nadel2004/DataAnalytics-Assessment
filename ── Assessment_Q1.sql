SELECT 
    p.owner_id,
    u.first_name, u.last_name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    SUM(p.amount) / 100.0 AS total_deposits  -- Convert from kobo to naira
FROM 
    plans_plan p
JOIN 
    users_customuser u ON p.owner_id = u.id
WHERE 
    p.is_deleted = 0 
    AND p.is_archived = 0
    AND p.status_id = 1  -- Active plans only
    AND p.amount > 0  -- Funded plans only
GROUP BY 
    p.owner_id, u.first_name, u.last_name
HAVING 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) > 0
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) > 0
ORDER BY 
    total_deposits DESC;
    
    
    