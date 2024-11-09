--create table
DROP TABLE IF EXISTS sales;
CREATE TABLE sales
		(
			transactions_id	INT PRIMARY KEY,
			sales_date	DATE,
			sales_time	TIME,
			customer_id	INT,
			gender VARCHAR(10),
			age	INT,
			category VARCHAR(20),	
			quantity INT,
			price_per_unit FLOAT,	
			cost_value FLOAT,
			total_sales FLOAT
		);

SELECT * FROM sales;

--data cleaning
SELECT * FROM sales
WHERE transactions_id IS NULL
OR
sales_date IS NULL
OR
sales_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR 
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cost_value IS NULL
OR
total_sales IS NULL
;

DELETE FROM sales
WHERE transactions_id IS NULL
OR
sales_date IS NULL
OR
sales_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR 
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cost_value IS NULL
OR
total_sales IS NULL;

--data exploration
--HOW MANY SALES WE HAVE?
SELECT 
	COUNT(*)
FROM sales;

--HOW MANY UNIQUE CUSTOMERS DO WE HAVE?
SELECT COUNT (DISTINCT customer_id)
FROM sales;

--WHAT ARE THE CATEGORIES WE HAVE?
SELECT DISTINCT category
FROM sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Retrieve all columns for sales made on '2022-11-05
SELECT * FROM sales
WHERE sales_date ='2022-11-05';

/*Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 
in the month of Nov-2022*/
SELECT * FROM sales
WHERE category ='Clothing'
AND quantity > 2
AND TO_CHAR(sales_date, 'YYYY-MM')='2022-11';

-- Calculate the total sales for each category.
SELECT category, sum(total_sales) AS total_sales
FROM sales
GROUP BY category;

-- Find the average age of customers who purchased items from the 'Beauty' category.
SELECT category, avg(age) AS avg_age
FROM sales
WHERE category ='Beauty'
GROUP BY category

-- Find all transactions where the total_sale is greater than 1000.
SELECT * FROM sales
WHERE total_sales >1000
order by total_sales;

-- Find the total number of transactions each gender makes in each category.
SELECT 
	category,
	gender, 
	count(transactions_id)AS total_transactions
FROM sales
GROUP BY category, gender
ORDER BY category;

-- Calculate the average sale for each month. Find out the BEST selling month in each year
SELECT year, 
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

-- Find the top 5 customers based on the highest total sales 
SELECT 
	customer_id, sum(total_sales) AS total_sales
FROM sales
GROUP BY customer_id
ORDER BY total_sales desc
LIMIT 5;

-- Find the number of unique customers who purchased items from each category.
SELECT  category, 
		COUNT(DISTINCT customer_id) AS customer_id
FROM sales
GROUP BY category;

-- Create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
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
