DATA ANALYTICS ASSESSMENT
OLUFOWOBI OLABODE KASHIF

INTRODUCTION
This repository is my submission for the SQL Proficiency Assessment. I approached this task not just as a test, but as if I were solving real-life business problems at a Nigerian fintech company like the one I hope to work with. Every query here is written with attention to clarity, correctness, and performance.
I used the schema provided (and later converted from a `.mwb` to SQL dump) to answer four practical questions using SQL. The tables involved include:

- `users_customuser` – user profiles and demographic data
- `plans_plan` – customer savings and investment plans
- `savings_savingsaccount` – deposit transactions
- `withdrawals_withdrawal` – withdrawal records

# SQL Assessment Solutions

## Overview

This document explains the approach taken to solve each of the SQL questions provided, highlighting methodology, challenges encountered, and how those challenges were resolved. The focus was on accuracy, efficiency, completeness, and readability.

## 1. High-Value Customers with Multiple Products

**Goal:**  
Identify customers who have at least one funded savings plan **and** one funded investment plan, sorted by total deposits.

**Approach:**

- Aggregated savings and investment plans separately using subqueries with filters on `is_regular_savings` and `is_a_fund`.
- Calculated counts and total deposits (converted from kobo to base currency).
- Joined results on `owner_id` to find customers with both types of plans.
- Used `COALESCE` to handle NULLs and filter customers who have at least one of each plan.
- Sorted results by total deposits descending.

**Challenges & Solutions:**

- Avoided ambiguous column names by explicitly aliasing all columns.
- Converted all amount values from kobo to base units (dividing by 100).
- Ensured filtering on funded accounts (`confirmed_amount > 0`).
- Ensured logical join conditions to avoid losing customers.

## 2. Transaction Frequency Analysis

**Goal:**  
Categorize customers by their average monthly transaction frequency.

**Approach:**

- Calculated monthly transaction counts per customer by grouping transactions by `owner_id` and year-month.
- Averaged monthly transaction counts per customer.
- Categorized customers into "High Frequency", "Medium Frequency", and "Low Frequency" using a CASE statement.
- Aggregated customer counts and average transaction frequency per category.
- Ordered categories logically.

**Challenges & Solutions:**

- Addressed SQL syntax issues by using correct grouping and date formatting functions.
- Avoided ambiguous columns by prefixing table aliases.
- Carefully handled edge cases in frequency categorization.
- Tested and adjusted query for compatibility with MySQL versions (especially CTE support).

## 3. Account Inactivity Alert

**Goal:**  
Identify active accounts (savings or investment) with no transactions in the past year.

**Approach:**

- Retrieved last transaction date per plan and owner.
- Classified plan type based on flags (`is_regular_savings` and `is_a_fund`).
- Calculated inactivity days as difference between current date and last transaction date.
- Filtered accounts with inactivity over 365 days.
- Sorted results by inactivity duration descending.

**Challenges & Solutions:**

- Removed assumption of `is_active` column (which did not exist).
- Used `DATEDIFF` and `DATE_SUB` for accurate date comparisons.
- Ensured to only consider confirmed transactions for activity status.
- Handled missing or null values carefully.

## 4. Customer Lifetime Value (CLV) Estimation

**Goal:**  
Estimate CLV per customer based on account tenure and transaction volume.

**Approach:**

- Calculated tenure in months from customer signup date.
- Counted total transactions per customer.
- Estimated profit per transaction as 0.1% of transaction value.
- Applied the formula:  
  \[
  CLV = \left(\frac{total_transactions}{tenure}\right) \times 12 \times avg_profit_per_transaction
  \]
- Ordered customers by estimated CLV descending.

**Challenges & Solutions:**

- Used `TIMESTAMPDIFF` for precise tenure calculation.
- Ensured no division by zero by handling edge cases.
- Converted transaction amounts from kobo to base currency.
- Joined tables properly to consolidate data.

## General Challenges and Resolutions

- **Ambiguous Columns:** Explicit aliasing resolved conflicts with columns named similarly across tables.
- **Kobo Conversion:** All monetary amounts converted by dividing by 100 for readability and correctness.
- **SQL Syntax Errors:** Adjusted queries for MySQL compatibility, particularly CTE usage and date functions.
- **Missing Schema Info:** Made logical assumptions for missing flags (e.g., transaction status), clarified and documented assumptions.
- **Performance Considerations:** Used aggregation and joins efficiently, minimized nested subqueries.

## Notes

- The queries assume the availability of fields such as `confirmed_amount`, `transaction_date`, and plan flags (`is_regular_savings`, `is_a_fund`).
- Amount fields stored in kobo must be converted for financial calculations.
- Some assumptions (e.g., on transaction status) were made in absence of complete schema details.
