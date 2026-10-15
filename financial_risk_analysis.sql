-- ==========================================
-- PROJECT 2: FINANCIAL RISK & POLICYHOLDER ANALYSIS
-- ==========================================

-- 1. Database & Table Setup
CREATE DATABASE IF NOT EXISTS financial_risk_db;
USE financial_risk_db;

-- Policyholders Table
DROP TABLE IF EXISTS policyholders;
CREATE TABLE policyholders (
    policy_id INT PRIMARY KEY,
    policyholder_name VARCHAR(100),
    age_group VARCHAR(20),
    risk_rating VARCHAR(20), -- 'Low', 'Medium', 'High'
    annual_premium DECIMAL(10, 2),
    policy_start_date DATE
);

INSERT INTO policyholders VALUES
(5001, 'Chong Wei', '30-45', 'Low', 2400.00, '2024-01-01'),
(5002, 'Nurul Ain', '18-29', 'Medium', 3600.00, '2024-03-15'),
(5003, 'Devan Nair', '46-60', 'High', 5500.00, '2024-06-01'),
(5004, 'Lim Mei Ling', '30-45', 'Low', 2800.00, '2024-07-10'),
(5005, 'Zulkifli Ahmad', '46-60', 'High', 6000.00, '2024-09-01');

-- Claims Table
DROP TABLE IF EXISTS claims;
CREATE TABLE claims (
    claim_id INT PRIMARY KEY,
    policy_id INT,
    claim_date DATE,
    claim_amount DECIMAL(10, 2),
    claim_status VARCHAR(20) -- 'Approved', 'Pending', 'Rejected'
);

INSERT INTO claims VALUES
(901, 5001, '2024-04-10', 500.00, 'Approved'),
(902, 5001, '2024-11-20', 1200.00, 'Approved'),
(903, 5002, '2024-05-12', 4500.00, 'Approved'),
(904, 5002, '2024-08-19', 2000.00, 'Rejected'),
(905, 5003, '2024-07-05', 8000.00, 'Approved'),
(906, 5003, '2024-10-15', 3500.00, 'Approved'),
(907, 5003, '2024-12-01', 5000.00, 'Pending'),
(908, 5004, '2024-09-10', 300.00, 'Approved'),
(909, 5005, '2024-10-05', 12000.00, 'Approved'),
(910, 5005, '2024-12-20', 4000.00, 'Approved');


-- ==========================================
-- 2. ANALYTICAL QUERIES
-- ==========================================

-- Query 1: Policyholder Exposure Summary
WITH TotalTable AS (
	SELECT 
		policyholders.policy_id,
		policyholder_name,
		age_group,
		risk_rating,
		annual_premium,
		policy_start_date,
        claim_id,
        claim_date,
		claim_amount,
		claim_status
    FROM policyholders
		LEFT JOIN claims
			ON policyholders.policy_id = claims.policy_id
)
SELECT 
	policy_id, 
    policyholder_name, 
    risk_rating, 
    annual_premium,
    COUNT(claim_id) AS total_claims,
    SUM(CASE WHEN claim_status = 'Approved' THEN claim_amount ELSE 0 END) AS total_approved_payout
FROM TotalTable
GROUP BY policy_id;


-- Query 2: Running Total of Claim Payouts
WITH ApprovedClaims AS (
	SELECT
		policy_id, 
        claim_id, 
        claim_date, 
        claim_amount
	FROM claims
    WHERE claim_status = 'Approved'
)
SELECT
	policy_id, 
	claim_id, 
	claim_date, 
	claim_amount,
	SUM(claim_amount) OVER(PARTITION BY policy_id ORDER BY claim_date ASC, claim_id ASC) AS running_total_payout
FROM ApprovedClaims
ORDER BY policy_id, claim_date;


-- Query 3: High-Risk Loss Ratio Identification
WITH TotalTable AS (
	SELECT 
		policyholders.policy_id,
		policyholder_name,
		risk_rating,
		annual_premium,
		claim_amount,
		claim_status
    FROM policyholders
		LEFT JOIN claims
			ON policyholders.policy_id = claims.policy_id
)
SELECT 
	policy_id, 
    policyholder_name, 
    risk_rating, 
    annual_premium,
    SUM(CASE WHEN claim_status = 'Approved' THEN claim_amount ELSE 0 END) AS total_approved_payout
FROM TotalTable
GROUP BY policy_id
HAVING total_approved_payout > annual_premium;