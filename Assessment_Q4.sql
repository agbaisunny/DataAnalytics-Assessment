/* 
Calling in the DataBase for the Assessment
*/

SHOW DATABASES;
USE adashi_staging;

/* 
Showing all the Tables in the Database (DB)
*/

SHOW TABLES; 
/* As indicated in the assessment instructions, the database contains 4 table, name: plans_plan, savings_savingsaccount, users_customuser and withdrawals_withdrawal using the above query*/

/* Describing all the tables in the DB */
DESCRIBE plans_plan;
DESCRIBE savings_savingsaccount;
DESCRIBE users_customuser;
DESCRIBE withdrawals_withdrawal;

/* Task Four
For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
- Account tenure (months since signup)
- Total transactions
- Estimated CLV (Assume: CLV = (total_transactions/tenure) * 12 * avg_profit_per_transaction)
- Order by estimated CLV from highest to lowest
*/

-- we are going to use 2 tables from the DB --
-- users_customuser --
-- savings_savingsaccount --

DESCRIBE users_customuser;
SELECT * FROM users_customuser;  															-- This query helps to understand the customers table better --

DESCRIBE savings_savingsaccount;
SELECT * FROM savings_savingsaccount; 														-- This query helps to understand the savings table better --

WITH customer_stats AS (
	SELECT
		s.owner_id AS customer_id,
        MIN(s.created_on) AS signup_date,													-- This query is to use the account creation date as the signup date to help with our calculation --
        COUNT(*) AS total_transactions,														-- This query counts the whole savings table for all the total transactions that happened --
        SUM(s.amount) AS total_transaction_value,		
        AVG(s.amount) AS avg_transaction_value
	FROM
		savings_savingsaccount s
	JOIN
		users_customuser u ON s.owner_id = u.id
	GROUP BY
		s.owner_id
)

SELECT 
	cs.customer_id,
    CONCAT(u.first_name, ' ', last_name) AS name,
    TIMESTAMPDIFF(MONTH, cs.signup_date, CURRENT_DATE) AS tenure_months,		-- This query used the default sql functuions to lookup the months and current date, where tenure_months means, --
    cs.total_transactions,														-- months since first plan creation (signup) and total_transactions is the count of all plans for the customer --
    ROUND((cs.total_transactions / NULLIF(TIMESTAMPDIFF(MONTH, cs.signup_date, CURRENT_DATE), 0)) 	-- The estimated_clv query calculated the transaction/month * 12 months * aveg transaction * 0.001 profit --
			* 12 * (cs.avg_transaction_value * 0.001), 2) AS estimated_clv
FROM
	customer_stats cs
JOIN
	users_customuser u ON cs.customer_id = u.id
ORDER BY
	estimated_clv DESC;