# World Layoffs Data Analysis (SQL)

## 📖 Introduction
This project involves a deep dive into global layoffs data from 2020 to 2023. The goal was to transform raw, messy data into a clean dataset ready for analysis and then extract meaningful insights.

## 🛠️ Skills Demonstrated
- **Data Cleaning**: Handled duplicates, standardized inconsistent text, formatted dates, and populated null values using self-joins.
- **EDA**: Analyzed layoff trends by industry, geography, and time.
- **SQL Techniques**: Window Functions (`ROW_NUMBER`, `DENSE_RANK`), CTEs, Joins, Aggregate Functions, and Substrings.

## 📂 Project Structure
- `Data_Cleaning_layoffs.sql`: The full ETL process to clean the raw data.
- `Exploratory_Data_Analysis_layoffs.sql`: SQL queries used to uncover trends and rankings.
- `layoffs.csv`: The raw dataset used for this project.

## 💡 Key Insight Example
During the analysis, the Consumer and Retail industries experienced the most significant volume of layoffs, while the Tech sector saw a dramatic acceleration in workforce reductions starting from late 2022, as evidenced by the monthly rolling total analysis.
