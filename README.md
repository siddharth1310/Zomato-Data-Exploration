# Zomato-Data-Exploration

This repository demonstrates **data analysis using SQL** on a simulated Zomato customer and sales dataset. The project focuses on exploring customer behavior, transaction patterns, and loyalty program insights using **MS SQL Server**.

---

## Project Overview

The dataset includes:

- **users** – Information about Zomato customers and their signup dates.  
- **goldusers_signup** – Details of customers who joined the Zomato Gold membership program.  
- **sales** – Records of product purchases by customers with purchase dates.  
- **product** – Product catalog with prices.  

The project aims to **analyze customer transactions, identify trends, and calculate loyalty metrics** to derive actionable insights.

---

## Key Analyses Performed

### 1. Customer Spending & Behavior
- Calculated **total amount spent** by each customer.  
- Counted **distinct days visited** by customers.  
- Identified the **first product purchased** by each customer.  

### 2. Product Popularity
- Determined **most purchased items overall** and **most popular product per customer**.  
- Tracked **first and last product purchased relative to joining the Gold program**.  

### 3. Gold Membership Insights
- Calculated **total orders and spending before becoming a Gold member**.  
- Analyzed **points earned per product** based on Zomato’s loyalty program rules.  
- Computed **total cashback earned** and identified **products generating the most points**.  
- Evaluated **first-year points accumulation** for Gold members.  

### 4. Advanced SQL Techniques
- Used **window functions** like `RANK()` and `ROW_NUMBER()` for ranking transactions.  
- Performed **conditional joins** to separate Gold vs non-Gold members.  
- Aggregated spending and loyalty points with **grouping and joins**.  
- Created temporary tables and multi-level subqueries for detailed analysis.  

---

## Skills Demonstrated

- **SQL & T-SQL:** Joins, window functions, ranking, aggregation, conditional logic.  
- **Data Analysis:** Customer segmentation, spending patterns, loyalty program insights.  
- **Problem Solving:** Translating business logic (loyalty points, first-year earnings) into SQL queries.  
- **Database Management:** Simulating transactional datasets and performing multi-table analysis.

---

## How to Use

1. **Run the SQL Script:** Open `Zomato Project.sql` in **SQL Server Management Studio (SSMS)** or **Azure Data Studio**.  
2. **Explore Tables:** The script creates tables and inserts sample data to simulate customer transactions.  
3. **Execute Queries:** Review queries for insights into customer spending, product popularity, and loyalty program analysis.  

---

## Repository Structure
  - Zomato Project.sql
