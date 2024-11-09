# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis   
**Database**: `Retail_sales_analysis`

This project was done to demonstrate my SQL skills and techniques and my ability as a data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. 

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identified and removed any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Performed basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Used SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retail_sales_analysis`.
- **Table Creation**: A table named `sales` is created to store the sales data. The table structure includes columns for transactions_ID, sales_date, sales_time, customer_ID, gender, age, category, quantity_sold, price_per_unit, cost_value, and total_sales amount.

```sql
CREATE DATABASE retail_sales_analysis;

DROP TABLE IF EXISTS sales;
CREATE TABLE sales
(
    transactions_id INT PRIMARY KEY,
    sales_date DATE,	
    sales_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cost_value FLOAT,
    total_sales FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM sales;
SELECT COUNT(DISTINCT customer_id) FROM sales;
SELECT DISTINCT category FROM sales;

SELECT * FROM sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM sales
WHERE sales_date = '2022-11-05';
```

2. **Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022**:
```sql
SELECT * FROM sales
WHERE category ='Clothing'
AND quantity > 2
AND TO_CHAR(sales_date, 'YYYY-MM')='2022-11';
```

3. **Calculate the total sales (total_sale) for each category.**:
```sql
SELECT category, sum(total_sales) AS total_sales
FROM sales
GROUP BY category;
```

4. **Find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT category, avg(age) AS avg_age
FROM sales
WHERE category ='Beauty'
GROUP BY category
```

5. **Find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM sales
WHERE total_sales >1000
order by total_sales;
```

6. **Find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
	category,
	gender, 
	count(transactions_id)AS total_transactions
FROM sales
GROUP BY category, gender
ORDER BY category;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT  year, 
	month, 
	avg_sales 
FROM
	(SELECT 
		EXTRACT(YEAR FROM sales_date)AS year,
		EXTRACT(MONTH FROM sales_date)AS month,
		AVG(total_sales) AS avg_sales,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sales_date) ORDER BY AVG(total_sales)DESC) AS ranking		
	FROM sales
	GROUP BY year, month)
WHERE ranking = 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
	customer_id, sum(total_sales) AS total_sales
FROM sales
GROUP BY customer_id
ORDER BY total_sales desc
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT  category, 
	COUNT(DISTINCT customer_id) AS customer_id
FROM sales
GROUP BY category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH shift_sales AS
(
SELECT *,
	CASE
	WHEN EXTRACT(HOUR FROM sales_time)<=12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sales_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
	END AS Shift
FROM sales)

SELECT 	shift, 
	count(*) AS total_orders
FROM shift_sales
GROUP BY shift;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories of Clothing, Beauty and Electronics.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping us to identify peak seasons.
- **Customer Insights**: The analysis identify the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a detailed exploratory data analysis for key business decision makers. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.
