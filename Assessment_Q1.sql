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

/* Task One
Finding Customers who have both savings plan and investment plan sorted by total deposits
*/

-- we are going to use 3 tables from the DB --
-- users_customuser --
-- savings_savingsaccount --
-- plans_plan --

DESCRIBE users_customuser;
SELECT * FROM users_customuser;  																-- This query helps to understand the customers table better -- 

DESCRIBE plans_plan;
SELECT * FROM plans_plan; 				 														-- This query helps to understand the plans table better -- 	
 
DESCRIBE savings_savingsaccount;
SELECT * FROM savings_savingsaccount; 															-- This query helps to understand the savings table better -- 

-- NOTE: plans table and savings table both has owner_id --

SELECT * FROM plans_plan;
SELECT * FROM savings_savingsaccount; 															-- This query helps us to select the all the active columns in the tables to be used --
SELECT * FROM users_customuser;

SELECT
	p.owner_id,
	CONCAT(first_name, ' ', last_name) AS name, 												-- This query combines the first and last names to be in a single column as full name --
    COUNT(DISTINCT CASE WHEN p.plan_type_id = 1 THEN p.id END) AS savings_count, 			 	-- This query counts all the plan type = 1 as a savings count --
    COUNT(DISTINCT CASE WHEN p.plan_type_id IN (2,3,4) THEN p.id END) AS investment_count, 		-- This query counts all the plan type more than 1 as an investment count
    SUM(p.amount) AS total_deposits
    
FROM plans_plan p
JOIN users_customuser u ON p.owner_id = u.id  													-- This query joins the plan and customers table together --
WHERE p.is_deleted = 0
	AND p.status_id = 1   																		-- This query assumes status_id 1 means active/funded account --
	AND (p.plan_type_id = 1 AND p.amount > 0) 													-- Savings plan --
		OR (p.plan_type_id IN (2, 3, 4) AND p.amount > 0)  										-- Investment plans (2: Fixed Investment, 3: Family, 4: Emergency) --
        
GROUP BY p.owner_id, name
HAVING COUNT(DISTINCT CASE WHEN p.plan_type_id = 1 THEN p.id END) > 0
	AND COUNT(DISTINCT CASE WHEN p.plan_type_id IN (2, 3, 4) THEN p.id END) > 0
ORDER BY total_deposits DESC;
