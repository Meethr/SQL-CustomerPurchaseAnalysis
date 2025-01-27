-- Changing table name for ease of use (for project use)
ALTER TABLE cust_purchase_behav
RENAME cust;

-- Understanding data in table 
select*
from cust;

----------------- ANALYSIS -----------------------------

-- How many customers does the store have?
select count(distinct user_id) as Total_Customers
from cust;

-- Insights 
-- 1. Dataset has no duplicates 
-- 2. Total number of customers are 238. 


-- Average income of customers who come to the store (by year and month)
select round(avg(annual_income),2) as Average_Yearly_income, round(avg(annual_income)/12,2) as Average_Monthly_income
from cust;

-- Insight
-- 3. The average annual income for customers is USD 57407.56 while average monthly income is  USD 4783.96. 

-- Max and min annual income 
select min(annual_income) as min_annual_income, max(annual_income) as max_annual_income
from cust;

-- Average income by age group
-- Method 1 
SELECT 
    CASE
        WHEN age BETWEEN 20 AND 29 THEN '20s'
        WHEN age BETWEEN 30 AND 39 THEN '30s'
        WHEN age BETWEEN 40 AND 49 THEN '40s'
        ELSE 'Other'
    END AS age_group,
    AVG(ANNUAL_INCOME) AS avg_income
FROM cust
GROUP BY
    CASE
        WHEN age BETWEEN 20 AND 29 THEN '20s'
        WHEN age BETWEEN 30 AND 39 THEN '30s'
        WHEN age BETWEEN 40 AND 49 THEN '40s'
        ELSE 'Other'
    END;
    
    -- Method 2
    SELECT 
    CASE
        WHEN age BETWEEN 20 AND 29 THEN '20s'
        WHEN age BETWEEN 30 AND 39 THEN '30s'
        WHEN age BETWEEN 40 AND 49 THEN '40s'
        ELSE '50s'
    END AS age_group,
    AVG(ANNUAL_INCOME) AS avg_income, COUNT(DISTINCT USER_ID)
FROM cust
GROUP By 1;

-- Insights 
-- 4. The average income shows an upward trend, with average income increasing with age

-- Avg puchase amount by age 
SELECT 
    CASE
        WHEN age BETWEEN 20 AND 29 THEN '20s'
        WHEN age BETWEEN 30 AND 39 THEN '30s'
        WHEN age BETWEEN 40 AND 49 THEN '40s'
        ELSE '50s'
    END AS age_group,
    round(AVG(purchase_amount), 2) AS avg_purchase_amount
FROM cust
GROUP By 1;

-- Insights 
-- 5. The average purchase amount shows an upward trend, similar to the average income, where the purchase amount increases with age.
-- 6. Highest purchase amount is those in their 50s while lowest purchase amount is those in their 20s.
-- 7. Validates the viewpoint that those with higher average annual income have higher purchasing power. 


-- What is the average income and purchase amount by loyalty_score?
SELECT distinct loyalty_score,  round(AVG(ANNUAL_INCOME),2) AS avg_income, round(AVG(purchase_amount), 2) AS avg_purchase_amount
FROM cust
GROUP By 1
order by 1;

-- What is the average income and purchase amount based on purchase frequency?
-- What is the total amount spent by those in each category (purchase_freq_avg_check)?

select min(purchase_frequency), round(avg(purchase_frequency)), max(purchase_frequency)
from cust;

with income_purchase_correlation as (
SELECT
	CASE
		WHEN purchase_frequency < 20  then 'Purchse frequency below average'
        WHEN purchase_frequency = 20 then 'Purchse frequency same as average'
        WHEN purchase_frequency > 20 then 'Purchse frequency above average'
	END AS purchase_freq_avg_check, 
    round(avg(annual_income),2) as avg_annual_income,
    round(avg(purchase_amount),2) as avg_purchase_amount,
    count(distinct user_id) as number_of_customers
FROM CUST
GROUP BY 1
)
select *, avg_purchase_amount*number_of_customers as total_amount_spent
from income_purchase_correlation
order by total_amount_spent DESC;


-- Insights 
-- 8. Those with higher average incomes tend to make higher-than-average purchases and spend more overall compared to individuals with lower incomes.
-- 9. Majority of the customers are those whose purchase frequency is above average.
-- 10. The second highest total amount spent is by customers whose purchase frequency is below average, hence marketing team should target this group as well. 

-- How does this data vary by region?
with region_purchase_correlation as (
SELECT
	CASE
		WHEN purchase_frequency < 20  then 'Purchse frequency below average'
        WHEN purchase_frequency = 20 then 'Purchse frequency same as average'
        WHEN purchase_frequency > 20 then 'Purchse frequency above average'
	END AS purchase_freq_avg_check, 
    region,
    round(avg(annual_income),2) as avg_annual_income,
    round(avg(purchase_amount),2) as avg_purchase_amount,
    count(distinct user_id) as number_of_customers,
    avg_purchase_amount*number_of_customers as Total_amount_spent
FROM CUST
GROUP BY 1,2
)
select *
from region_purchase_correlation;

with region_purchase_correlation as (
SELECT
	CASE
		WHEN purchase_frequency < 20  then 'Purchse frequency below average'
        WHEN purchase_frequency = 20 then 'Purchse frequency same as average'
        WHEN purchase_frequency > 20 then 'Purchse frequency above average'
	END AS purchase_freq_avg_check, 
    region,
    round(avg(annual_income),2) as avg_annual_income,
    round(avg(purchase_amount),2) as avg_purchase_amount,
    count(distinct user_id) as number_of_customers
FROM CUST
GROUP BY 1,2
)
select *,   avg_purchase_amount*number_of_customers as Total_amount_spent
from region_purchase_correlation;


-- Insights 
-- 11. Highest total amount spent is in the West. 
-- 12. Largest customer base is in the North. 
-- 13. Smallest customer base is in east - look to run marketing campaigns here 

    
