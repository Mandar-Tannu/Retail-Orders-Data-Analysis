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
