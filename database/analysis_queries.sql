CREATE TABLE df_orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    ship_mode VARCHAR(20),
    segment VARCHAR(20),
    country VARCHAR(20),
    city VARCHAR(20),
    state VARCHAR(20),
    postal_code VARCHAR(20),
    region VARCHAR(20),
    category VARCHAR(20),
    sub_category VARCHAR(20),
    product_id VARCHAR(50),
    quantity INT,
    discount DECIMAL(7, 2),
    sale_price DECIMAL(7, 2),
    profit DECIMAL(7, 2)
);

SELECT *FROM df_orders;

-- 1. Find top 10 highest revenue generating products
SELECT product_id, SUM(sale_price*quantity) AS revenue
FROM df_orders
GROUP BY product_id
ORDER BY revenue DESC
LIMIT 10;

-- 2. Find top 5 highest selling products in each region
SELECT region, product_id, total_sales
FROM (
    SELECT region, product_id, SUM(sale_price * quantity) AS total_sales,
           ROW_NUMBER() OVER(PARTITION BY region ORDER BY SUM(sale_price * quantity) DESC) AS top_selling_product
    FROM df_orders
    GROUP BY region, product_id
) AS ranked
WHERE top_selling_product <= 5;

-- 3. Find month over month growth comparison for 2022 and 2023 sales e.g. jan 2022 vs jan 2023
WITH cte AS(
			SELECT EXTRACT(YEAR FROM order_date) AS order_year, EXTRACT(MONTH FROM order_date) AS order_month,
			SUM(sale_price) AS sales
			FROM df_orders
			GROUP BY order_year, order_month
			)
SELECT order_month,
SUM(CASE WHEN order_year=2022 THEN sales ELSE 0 END) AS sales_2022,
SUM(CASE WHEN order_year=2023 THEN sales ELSE 0 END) AS sales_2023
FROM cte
GROUP BY order_month
ORDER BY order_month;

-- 4. For each category which month had highest sales
SELECT category, years, months, total_sales
FROM (
    SELECT category,
           EXTRACT(YEAR FROM order_date) AS years,
           EXTRACT(MONTH FROM order_date) AS months,
           SUM(sale_price * quantity) AS total_sales,
           ROW_NUMBER() OVER(PARTITION BY category ORDER BY SUM(sale_price * quantity) DESC) AS highest_sale
    FROM df_orders
    GROUP BY category, years, months
) AS ranked
WHERE highest_sale = 1;

-- 5. Which sub_category had highest growth by profit in 2023 compare to 2022
WITH cte AS (
    SELECT sub_category, EXTRACT(YEAR FROM order_date) AS order_year,
           SUM(profit) AS total_profit
    FROM df_orders
    GROUP BY sub_category, EXTRACT(YEAR FROM order_date)
),
cte2 AS (
    SELECT sub_category,
           SUM(CASE WHEN order_year=2022 THEN total_profit ELSE 0 END) AS profit_2022,
           SUM(CASE WHEN order_year=2023 THEN total_profit ELSE 0 END) AS profit_2023
    FROM cte
    GROUP BY sub_category
)
SELECT *, ROUND((profit_2023 - profit_2022)*100.0 / profit_2022, 2) AS growth_percent
FROM cte2
ORDER BY growth_percent DESC
LIMIT 1;