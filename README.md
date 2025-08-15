# Retail Orders Data Analysis  

An end-to-end retail data analysis project using **PostgreSQL** and **Python (Pandas)**.  
The dataset was sourced from Kaggle using the Kaggle API, cleaned and processed in Python, then loaded into PostgreSQL for SQL-based analysis.  
The analysis focuses on revenue trends, top-selling products, month-over-month growth, and category-level insights.  

---

## 📝 Project Summary  

This project demonstrates how to perform real-world retail data analysis by combining **data cleaning, database management, and analytical SQL queries**.  
It simulates a retail store's transactional dataset, enabling business stakeholders to:  

- Identify top revenue-generating products.  
- Understand regional product sales performance.  
- Compare sales trends year-over-year.  
- Detect the highest sales months per category.  
- Measure profit growth across product sub-categories.  

---

## 📌 Objective  

The goal is to **clean, structure, and analyze** retail sales data to generate actionable business insights using SQL queries executed on a PostgreSQL database.  

---

## 🛠️ Tools & Technologies  

- **Python (Pandas)** – Data cleaning, transformation, and export to PostgreSQL.  
- **PostgreSQL** – Database to store and query the cleaned dataset.  
- **SQL** – For performing business analysis and answering key questions.  
- **Jupyter Notebook** – To perform EDA and document the workflow.  
- **Kaggle API** – To download the dataset programmatically.  

---

## 📊 Key SQL Analyses Performed  

1. **Top 10 highest revenue-generating products**.  
2. **Top 5 highest selling products in each region**.  
3. **Month-over-month sales growth comparison for 2022 vs 2023**.  
4. **Highest sales month per category**.  
5. **Sub-category with the highest profit growth in 2023 compared to 2022**.  

---

## 🗂️ Project Structure  

| Folder/File | Description |
|-------------|-------------|
| `dataset/` | Contains the raw and cleaned CSV files used in the project. |
| `notebook/` | Jupyter notebook containing data cleaning and export to PostgreSQL steps. |
| `database/` | SQL script to create the `df_orders` table and execute analytical queries. |
| `README.md` | Documentation for the project (this file). |

**Example Layout:**  
```plaintext
Retail-Orders-Data-Analysis/
│
├── dataset/
│   └── orders.csv
│
├── notebook/
│   └── orders_data_analysis.ipynb
│
├── database/
│   └── analysis_queries.sql
│
└── README.md
```

---

## 📁 Datasets
The dataset contains retail order transactions with the following key columns:
- order_id – Unique ID for each order.
- order_date – Date of the order.
- ship_mode – Mode of shipping.
- segment – Customer segment (Consumer, Corporate, Home Office).
- region – Geographic region of the customer.
- category – Main category of the product.
- sub_category – Sub-category of the product.
- product_id – Unique product identifier.
- quantity – Units sold.
- discount – Discount applied to the order.
- sale_price – Selling price per unit.
- profit – Profit made from the order.

---

## 📜 SQL Queries  

```sql
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

SELECT * FROM df_orders;

-- 1. Find top 10 highest revenue generating products
SELECT product_id, SUM(sale_price * quantity) AS revenue
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

-- 3. Month-over-month growth comparison for 2022 and 2023
WITH cte AS (
    SELECT EXTRACT(YEAR FROM order_date) AS order_year,
           EXTRACT(MONTH FROM order_date) AS order_month,
           SUM(sale_price) AS sales
    FROM df_orders
    GROUP BY order_year, order_month
)
SELECT order_month,
       SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
       SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM cte
GROUP BY order_month
ORDER BY order_month;

-- 4. For each category, find month with highest sales
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

-- 5. Sub-category with highest profit growth in 2023 vs 2022
WITH cte AS (
    SELECT sub_category,
           EXTRACT(YEAR FROM order_date) AS order_year,
           SUM(profit) AS total_profit
    FROM df_orders
    GROUP BY sub_category, EXTRACT(YEAR FROM order_date)
),
cte2 AS (
    SELECT sub_category,
           SUM(CASE WHEN order_year = 2022 THEN total_profit ELSE 0 END) AS profit_2022,
           SUM(CASE WHEN order_year = 2023 THEN total_profit ELSE 0 END) AS profit_2023
    FROM cte
    GROUP BY sub_category
)
SELECT *,
       ROUND((profit_2023 - profit_2022) * 100.0 / profit_2022, 2) AS growth_percent
FROM cte2
ORDER BY growth_percent DESC
LIMIT 1;
```
---


## 🚀 How to Use

1. Clone the repository:
   ```bash
   git clone https://github.com/Mandar-Tannu/Retail-Orders-Data-Analysis.git

2. Download dataset from Kaggle API and place it inside the dataset/ folder.
3. Run the Jupyter Notebook in the notebook/ folder to clean the data and export it to PostgreSQL.
3. Execute the SQL queries from the database/analysis_queries.sql file to perform the analysis.

---

## ⚠️ Challenges Faced

- Cleaning inconsistent date formats in order_date.
- Handling missing values in discount, sale_price, and profit columns.
- Removing duplicate records for accurate analysis.
- Ensuring correct data types before exporting to PostgreSQL.
- Creating efficient SQL queries to handle large datasets.

---

## 🔮 Future Improvements

- Add data visualizations for SQL outputs in Power BI or Tableau.
- Automate data refresh from Kaggle using a scheduled script.
- Include more advanced metrics like Customer Lifetime Value (CLV) or RFM analysis.
- Build a dashboard to track these metrics interactively.

---

## 🧠 My Learning Journey

- Learned to integrate Python and PostgreSQL for an end-to-end data pipeline.
- Gained hands-on experience in SQL analytical functions like ROW_NUMBER() and CTEs.
- Practiced real-world retail KPIs like revenue growth and profit analysis.
- Improved workflow documentation for GitHub portfolio projects.
  
---

## 📬 Contact

Created by Mandar Tannu  
Email: mandartannu19@gmail.com  
LinkedIn: https://www.linkedin.com/in/mandartannu/
