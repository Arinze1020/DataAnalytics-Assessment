WITH customer_monthly_transactions AS (
    SELECT 
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m-01') AS month_start,
        COUNT(*) AS transaction_count
    FROM 
        savings_savingsaccount
    WHERE 
        transaction_status = 'success'
    GROUP BY 
        owner_id, 
        DATE_FORMAT(transaction_date, '%Y-%m-01')
),
customer_avg_transactions AS (
    SELECT 
        owner_id,
        AVG(transaction_count) AS avg_transactions_per_month,
        CASE 
            WHEN AVG(transaction_count) >= 10 THEN 'High Frequency'
            WHEN AVG(transaction_count) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM 
        customer_monthly_transactions
    GROUP BY 
        owner_id
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM 
    customer_avg_transactions
GROUP BY 
    frequency_category
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        WHEN frequency_category = 'Low Frequency' THEN 3
    END;