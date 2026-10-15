# 🛡️ Financial Risk & Policyholder Portfolio Analysis

## 📌 Executive Summary
An end-to-end SQL data analysis project evaluating insurance portfolio risk, cumulative financial exposure, and policyholder loss ratios. This project leverages relational joins, conditional aggregation, and running window totals to identify high-risk accounts and monitor payout trajectories for underwriting and risk management teams.

---

## 🛠️ Technical Stack & Skills Demonstrated
* **Database Management:** MySQL, Multi-Table Relational Schema Design (`policyholders`, `claims`)
* **Advanced Querying Techniques:**
  * **Multi-Table `LEFT JOIN` Logic:** Integrated policyholder risk tiers with transaction claims while retaining zero-claim accounts.
  * **Conditional Aggregation (`SUM(CASE WHEN ...)`):** Safely isolated approved claim amounts from pending and rejected logs in a single pass.
  * **Running Window Totals (`SUM() OVER (PARTITION BY ... ORDER BY ...)`):** Tracked cumulative financial payout exposure chronologically per policyholder with deterministic tie-breakers.
  * **Aggregated Filtering (`HAVING`):** Differentiated row-level filters (`WHERE`) from post-aggregation thresholds (`HAVING`) to flag loss-making policy accounts.

---

## 🔍 Key Analytical Queries & Business Insights

### 1. Policyholder Exposure Summary
* **Objective:** Consolidate individual policy profiles with total claim counts and approved payout sums.
* **SQL Implementation:** Employed a `LEFT JOIN` combined with conditional aggregation (`SUM(CASE WHEN claim_status = 'Approved' THEN ... END)`) to guarantee unblemished policyholders registered correct zero-values.
* **Business Insight:** Establishes a baseline portfolio view separating premium revenue from actual loss payouts per client.

### 2. Cumulative Financial Exposure Trajectory
* **Objective:** Track the running total of approved claim payouts over time for each policyholder.
* **SQL Implementation:** Isolated approved claims inside a CTE and applied the `SUM() OVER (PARTITION BY policy_id ORDER BY claim_date, claim_id)` window function.
* **Business Insight:** Enables risk officers to observe how quickly a client's claim history exhausts their premium threshold.

### 3. High-Risk Loss Ratio Identification
* **Objective:** Flag policyholders whose total approved claim payouts exceed their annual premium.
* **SQL Implementation:** Utilized a structured CTE framework paired with a post-aggregation `HAVING total_approved_payout > annual_premium` constraint.
* **Business Insight:** Directly flags accounts with negative loss ratios for immediate underwriting review or policy renewal adjustment.

---

## 📂 Repository Contents
* `financial_risk_analysis.sql` — Contains complete database initialization schemas, mock data injection, and all 3 analytical queries.

---

## 🚀 How to Run the Scripts
1. Open **MySQL Workbench** and connect to your local MySQL instance.
2. Execute the setup script to initialize the `financial_risk_db` database and populate tables.
3. Open a new query tab (`Ctrl + T`) and execute the analytical queries sequentially.