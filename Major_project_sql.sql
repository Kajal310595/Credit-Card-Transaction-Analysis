-- SQL Query to create and import data from csv files:

-- Create a database 
CREATE DATABASE credit_card_db;

-- Create credit_card_detail table
CREATE TABLE credit_card (
    Client_Num INT,
    Card_Category VARCHAR(20),
    Annual_Fees INT,
    Activation_30_Days INT,
    Customer_Acq_Cost INT,
    Week_Start_Date DATE,
    Week_Num VARCHAR(20),
    Qtr VARCHAR(10),
    current_year INT,
    Credit_Limit DECIMAL(10,2),
    Total_Revolving_Bal INT,
    Total_Trans_Amt INT,
    Total_Trans_Ct INT,
    Avg_Utilization_Ratio DECIMAL(10,3),
    Use_Chip VARCHAR(10),
    Exp_Type VARCHAR(50),
    Interest_Earned DECIMAL(10,3),
    Delinquent_Acc VARCHAR(5)
);


-- Create customer_detail table
CREATE TABLE customer (
    Client_Num INT,
    Customer_Age INT,
    Gender VARCHAR(5),
    Dependent_Count INT,
    Education_Level VARCHAR(50),
    Marital_Status VARCHAR(20),
    State_cd VARCHAR(50),
    Zipcode VARCHAR(20),
    Car_Owner VARCHAR(5),
    House_Owner VARCHAR(5),
    Personal_Loan VARCHAR(5),
    Contact VARCHAR(50),
    Customer_Job VARCHAR(50),
    Income INT,
    Cust_Satisfaction_Score INT
);


-- >>>>> KPI QUERIES <<<<<

-- 1. Total Revenue
SELECT 
    ROUND(SUM(Annual_Fees + Total_Trans_Amt + Interest_Earned) / 1000000, 2) 
    AS Total_Revenue_Million
FROM credit_card;

-- 2. Total Customers
SELECT COUNT(DISTINCT Client_Num) AS Total_Customers
FROM customer;

-- 3. Total Transactions
SELECT SUM(Total_Trans_Ct) AS Total_Transactions
FROM credit_card;

-- 4. Total Interest Earned
SELECT 
    ROUND(SUM(Interest_Earned) / 1000000, 2) AS Total_Interest_Millions
FROM credit_card;



-- >>>>> QUERIES <<<<<

-- 1.Revenue Per Customer
SELECT 
    Client_Num,
    SUM(Annual_Fees + Total_Trans_Amt + Interest_Earned) AS Revenue
FROM credit_card
GROUP BY Client_Num
ORDER BY Revenue DESC;


-- 2.Revenue by Card Category
SELECT 
    Card_Category,
    SUM(Annual_Fees + Total_Trans_Amt + Interest_Earned) AS Revenue
FROM credit_card
GROUP BY Card_Category
ORDER BY Revenue DESC;

-- 3.Revenue by Gender
SELECT 
    c.Gender,
    SUM(cc.Annual_Fees + cc.Total_Trans_Amt + cc.Interest_Earned) AS Revenue
FROM customer c
JOIN credit_card cc ON c.Client_Num = cc.Client_Num
GROUP BY c.Gender;

-- 4.Revenue by Education Level
SELECT 
    c.Education_Level,
    SUM(cc.Annual_Fees + cc.Total_Trans_Amt + cc.Interest_Earned) AS Revenue
FROM customer c
JOIN credit_card cc ON c.Client_Num = cc.Client_Num
GROUP BY c.Education_Level
ORDER BY Revenue DESC;


-- 5.Top Earning States
SELECT 
    c.State_cd,
    SUM(cc.Annual_Fees + cc.Total_Trans_Amt + cc.Interest_Earned) AS Revenue
FROM customer c
JOIN credit_card cc ON c.Client_Num = cc.Client_Num
GROUP BY c.State_cd
ORDER BY Revenue DESC;


-- 6.Revenue by Chip
 SELECT 
    Use_Chip,
    ROUND(SUM(Annual_Fees + Total_Trans_Amt + Interest_Earned) / 1000000, 2) 
        AS Revenue_Million
FROM credit_card
GROUP BY Use_Chip
ORDER BY Revenue_Million DESC;


-- 7.Income Group Spending
SELECT 
    CASE 
        WHEN Income < 35000 THEN 'Low'
        WHEN Income BETWEEN 35000 AND 70000 THEN 'Mid'
        ELSE 'High'
    END AS Income_Group,
    SUM(cc.Total_Trans_Amt) AS Total_Spend
FROM customer c
JOIN credit_card cc ON c.Client_Num = cc.Client_Num
GROUP BY Income_Group
ORDER BY Total_Spend DESC;


-- 8. Customer Age Group Spending
SELECT 
    CASE 
        WHEN Customer_Age < 30 THEN '20-30'
        WHEN Customer_Age BETWEEN 30 AND 40 THEN '30-40'
        WHEN Customer_Age BETWEEN 40 AND 50 THEN '40-50'
        ELSE '50+'
    END AS Age_Group,
    SUM(cc.Total_Trans_Amt) AS Total_Spend
FROM customer c
JOIN credit_card cc ON c.Client_Num = cc.Client_Num
GROUP BY Age_Group;


-- 9. Customer Satisfaction vs Spend
SELECT 
    c.Client_Num,
    c.Cust_Satisfaction_Score,
    SUM(cc.Total_Trans_Amt) AS Total_Spend
FROM customer c
JOIN credit_card cc ON c.Client_Num = cc.Client_Num
GROUP BY c.Client_Num, c.Cust_Satisfaction_Score
ORDER BY c.Cust_Satisfaction_Score DESC;





