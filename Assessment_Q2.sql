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

/* Task Two
Calculating the average number of transactions per customer per month and cathegorize them
- High Frequency (>= 10 transactions/month)
- Medium Frequency (3-9 transactions/month)
- Low Frequency (<= 2 transactions/month)
*/

-- we are going to use 2 tables from the DB --
-- users_customuser --
-- savings_savingsaccount --

DESCRIBE users_customuser;
SELECT * FROM users_customuser;  															-- This query helps to understand the customers table better --

DESCRIBE savings_savingsaccount;
SELECT * FROM savings_savingsaccount; 														-- This query helps to understand the savings table better -- 

SELECT * FROM savings_savingsaccount; 														-- This query helps us to select the all the active columns in the tables to be used --
SELECT * FROM users_customuser;

WITH monthly_transactions AS ( 
	SELECT 
		u.id AS user_id,
        CONCAT(u.first_name, ' ', u.last_name) AS customer_name,
        DATE_FORMAT('month', s.transaction_date) AS month,									-- This query joins the users and savings table by a foreign - primary id --
		COUNT(*) AS transaction_count														-- It also enlists the monthly transactions by building a new column called the transaction counts --
	FROM users_customuser u
	JOIN savings_savingsaccount s ON u.id = s.owner_id
    GROUP BY u.id, customer_name, DATE_FORMAT('month', s.transaction_date)
),
customer_avg AS (
	SELECT 
		user_id,
        customer_name,
        AVG(transaction_count) AS avg_transactions_per_month								-- This query here builds a column for us knowm as the average transactions/months by customers --
	FROM monthly_transactions
    GROUP BY user_id, customer_name
)
SELECT
	CASE
		WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month >= 3 AND avg_transactions_per_month < 10 THEN 'Medium Fequency'			-- In this query, i have buily 3 categories of the monthly transactions by customes, --
        ELSE 'Low Frequency'																					-- classifying them as high frequency for those above 10, medium frequency for those --
	END AS frequency_category,																					-- between 3 to 9 and low frequency for less than 2. The average was rounded to a --
    COUNT(*) AS customer_count,																					-- 2 decimal points --
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM 
	customer_avg
GROUP BY
	frequency_category
ORDER BY
	CASE frequency_category
		WHEN  frequency_category = 'High Frequency' THEN 1
        WHEN  frequency_category = 'Medium Frewquency' THEN 2
        ELSE 3
	END;