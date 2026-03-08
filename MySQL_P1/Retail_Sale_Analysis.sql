
DROP TABLE IF EXISTS retail;
CREATE TABLE retail
			(
				transactions_id	INT PRIMARY	KEY,
				sale_date	DATE,
				sale_time	TIME,
				customer_id	INT,
				gender	VARCHAR(10),
				age	INT,
				category	VARCHAR(20),
				quantity		INT,
				price_per_unit FLOAT,
				cogs	FLOAT,
				total_sale	FLOAT
			);
            
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE '/Users/mr.tian/Desktop/mysql_project.csv'
INTO TABLE retail
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(transactions_id, sale_date, sale_time, customer_id, gender, @age, category, @quantity, @price_per_unit, @cogs, @total_sale)
SET
  age = NULLIF(@age, ''),
  quantity = NULLIF(@quantity, ''),
  price_per_unit = NULLIF(@price_per_unit, ''),
  cogs = NULLIF(@cogs, ''),
  total_sale = NULLIF(@total_sale, '');

select 
	count(*)
from retail;

--
select * from retail;

select * from retail
where transactions_id is null;

select * from retail
where
	transactions_id is null
    or
    sale_date is null
    or
    sale_time is null
    or
    gender is null
    or
    category is null
    or
    quantity is null
    or
    cogs is null
    or
    total_sale is null;
    
-- 
Delete from retail
where
	transactions_id is null
    or
    sale_date is null
    or
    sale_time is null
    or
    gender is null
    or
    category is null
    or
    quantity is null
    or
    cogs is null
    or
    total_sale is null;

-- Data Exploration 

-- How many sales we have?
Select count(*) as total_sale from retail;

-- How many unique customers we have?
Select count(distinct customer_id) as total_customer from retail;

Select count(distinct category) as total_category from retail;

select distinct category from retail;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'.

select *
from retail
where sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022.

select *
from retail
where 
	category = 'Clothing' 
    and 
    quantity >= 4 
    and 
    sale_date >= '2022-11-01'
    and
    sale_date <= '2022-11-30';


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category, sum(total_sale) as total_sales_category
from retail
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select round(avg(age), 0) as avg_age
from retail
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select *
from retail
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category, gender, count(transactions_id)
from retail
group by category, gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

select * from
(
	select 
		extract(year from sale_date) as year,
		extract(month from sale_date) as month, 
		avg(total_sale) as avg_total_sale,
		rank() over (partition by extract(year from sale_date) order by avg(total_sale) DESC) as rnk
	from retail
	group by year, month
) as t1
where rnk = 1;
-- order by year, avg_total_sale DESC;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.

select customer_id, sum(total_sale) as total_sales
from retail
group by customer_id
order by total_sales DESC
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select count(distinct customer_id), category
from retail
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders 

with hourly_sale
as
(
select *,
	case
		when extract(hour from sale_time) < 12 then 'Morning'
        when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
        else 'Evening'
	end as shift
from retail
)
select
	shift,
	count(*) as total_orders
from hourly_sale
group by shift

-- End of Project














