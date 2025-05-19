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

/* Task Three
Find all the active accounts (savings or investments) with no transactions in the last 1 year (365 days)
*/

-- we are going to use 2 tables from the DB --
-- plans_plan --
-- savings_savingsaccount --

DESCRIBE plans_plan;
SELECT * FROM plans_plan;  																	-- This query helps to understand the plan table better --

DESCRIBE savings_savingsaccount;
SELECT * FROM savings_savingsaccount; 														-- This query helps to understand the savings table better -- 

SELECT 
	p.id AS plan_id,
    p.owner_id,
    CASE
		WHEN p.plan_type_id = 1 THEN 'Savings' 												-- Both queries with plan_type_id help to determine if the account is a savings or investment type --
        WHEN p.plan_type_id IN (2, 3, 4) THEN 'Investment'
        ELSE 'Other'
	END AS TYPE,
    p.last_charge_date AS last_transaction_date,
    DATEDIFF(CURRENT_DATE, p.last_charge_date) AS inactivity_days							-- This query helps to tract the most recent transactions --
FROM
	plans_plan p
WHERE
	p.is_deleted = 0 																		-- Ensuring we exclude deleted accounts --
    AND p.status_id = 1																		-- Assuming status_id = 1 means active accounts --
    AND ( 
		p.last_charge_date IS NULL 															-- For accounts that has never had a transaction --
		OR DATEDIFF(CURRENT_DATE, p.last_charge_date) > 365									-- Looking up accounts with no transactions in over one year --
	)
ORDER BY 
	inactivity_days DESC;