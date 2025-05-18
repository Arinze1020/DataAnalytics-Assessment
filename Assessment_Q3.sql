SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    MAX(sa.transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(sa.transaction_date)) AS inactivity_days
FROM 
    plans_plan p
LEFT JOIN 
    savings_savingsaccount sa ON p.id = sa.plan_id
WHERE 
    p.status_id = 1  -- Assuming status_id 1 means active
GROUP BY 
    p.id, p.owner_id
HAVING 
    inactivity_days > 365 OR last_transaction_date IS NULL
ORDER BY 
    inactivity_days DESC;