WITH customer_transactions AS (
    SELECT 
        sa.owner_id,
        u.username as name,
        MIN(sa.created_on) AS first_transaction_date,
        COUNT(*) AS total_transactions,
        SUM(sa.confirmed_amount) AS total_transaction_value
    FROM 
        savings_savingsaccount sa
    JOIN 
        users_customuser u ON sa.owner_id = u.id
    WHERE 
        sa.transaction_status = 'success'
    GROUP BY 
        sa.owner_id, u.username
)
SELECT 
    owner_id AS customer_id,
    name,
    TIMESTAMPDIFF(MONTH, first_transaction_date, CURDATE()) AS tenure_months,
    total_transactions,
    (total_transactions / 
        GREATEST(TIMESTAMPDIFF(MONTH, first_transaction_date, CURDATE()), 1)) * 12 * 
        (total_transaction_value * 0.001 / 100) AS estimated_clv  -- 0.1% of transaction value, converted from kobo
FROM 
    customer_transactions
WHERE 
    TIMESTAMPDIFF(MONTH, first_transaction_date, CURDATE()) > 0
ORDER BY 
    estimated_clv DESC;