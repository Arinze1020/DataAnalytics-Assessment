SELECT 
    u.id as owner_id,
    u.name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) as savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) as investment_count,
    SUM(s.confirmed_amount) / 100.0 as total_deposits
FROM 
    users_customuser u
JOIN 
    plans_plan p ON u.id = p.owner_id
JOIN 
    savings_savingsaccount s ON p.id = s.plan_id AND u.id = s.owner_id
GROUP BY 
    u.id, u.name
HAVING 
    savings_count >= 1 AND investment_count >= 1
ORDER BY 
    total_deposits DESC;
