# 🛍️ Istanbul Shopping Mall — SQL Data Analysis Project

![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?logo=mysql&logoColor=white)
![Dataset](https://img.shields.io/badge/Dataset-Kaggle-20BEFF?logo=kaggle&logoColor=white)
![Rows](https://img.shields.io/badge/Rows-5%2C000-green)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)

> **B.Tech Final Year Project** — End-to-end SQL data analysis on real Kaggle retail data using MySQL Workbench. Covers data modeling, exploratory analysis, window functions, CTEs, stored procedures, and business insight generation.

---

## 📌 Project Overview

This project analyzes customer shopping behavior across **10 shopping malls in Istanbul** using SQL. The dataset spans **January 2021 to March 2023** and contains 5,000 transactions across 8 product categories.

**Business Questions Answered:**
- Which mall and category generate the highest revenue?
- How does revenue trend month over month?
- Who are the high-value customers?
- Do weekends outperform weekdays?
- How do spending patterns differ across age groups and genders?

---

## 📁 Project Structure

```
istanbul-shopping-sql-project/
│
├── data/
│   └── customer_shopping_data.csv      # Kaggle dataset (5,000 rows)
│
├── sql/
│   ├── 01_setup.sql                    # Database creation & table schema
│   ├── 02_basic_queries.sql            # Q1–Q5: Aggregations & GROUP BY
│   ├── 03_intermediate_queries.sql     # Q6–Q10: Subqueries, CASE, RANK
│   ├── 04_advanced_queries.sql         # Q11–Q15: CTEs, Window Functions
│   └── 05_views_procedures_triggers.sql # Views, Stored Procs, Triggers
│
├── charts/
│   ├── 01_revenue_by_category.png
│   ├── 02_monthly_revenue_trend.png
│   ├── 03_revenue_by_mall.png
│   ├── 04_payment_method_pie.png
│   ├── 05_gender_category_revenue.png
│   └── 06_age_group_revenue.png
│
├── docs/
│   └── schema_diagram.png              # ER / table schema diagram
│
└── README.md
```

---

## 📊 Dataset

| Attribute | Details |
|---|---|
| **Source** | [Kaggle — Customer Shopping Dataset](https://www.kaggle.com/datasets/mehmettahiraslan/customer-shopping-dataset) |
| **Author** | Mehmet Tahir Arslan |
| **Rows** | 5,000 (original: 99,457) |
| **Columns** | 10 |
| **Period** | Jan 2021 – Mar 2023 |

### Column Descriptions

| Column | Type | Description |
|---|---|---|
| `invoice_no` | VARCHAR(10) | Unique transaction ID (e.g. I100001) |
| `customer_id` | VARCHAR(10) | Customer identifier (e.g. C142445) |
| `gender` | ENUM | Male / Female |
| `age` | INT | Customer age (18–69) |
| `category` | VARCHAR | Product category (8 types) |
| `quantity` | INT | Units purchased |
| `price` | DECIMAL | Unit price in Turkish Liras (TL) |
| `payment_method` | VARCHAR | Cash / Credit Card / Debit Card |
| `invoice_date` | DATE | Transaction date |
| `shopping_mall` | VARCHAR | One of 10 Istanbul malls |

---

## 🗄️ Database Schema

```sql
CREATE TABLE shopping_data (
  invoice_no      VARCHAR(10)  PRIMARY KEY,
  customer_id     VARCHAR(10)  NOT NULL,
  gender          ENUM('Male','Female'),
  age             INT,
  category        VARCHAR(30),
  quantity        INT,
  price           DECIMAL(10,2),
  payment_method  VARCHAR(15),
  invoice_date    DATE,
  shopping_mall   VARCHAR(50),
  -- Computed column (auto-calculated):
  total_sales     DECIMAL(12,2) GENERATED ALWAYS AS (quantity * price) STORED
);
```

---

## 🔍 SQL Concepts Covered

| Level | Concept | Query |
|---|---|---|
| Basic | GROUP BY, ORDER BY, COUNT, SUM, AVG | Q1–Q5 |
| Basic | Subquery for % share | Q3 |
| Intermediate | CASE WHEN segmentation | Q6, Q9 |
| Intermediate | RANK() inside subquery | Q7 |
| Intermediate | HAVING with correlated subquery | Q8 |
| Intermediate | CASE pivot (cross-tab) | Q10 |
| Advanced | SUM OVER (running total) | Q11 |
| Advanced | CTE + LAG (MoM growth) | Q12 |
| Advanced | DENSE_RANK, PARTITION BY | Q13 |
| Advanced | Rolling AVG (ROWS BETWEEN) | Q14 |
| Advanced | Multi-CTE join | Q15 |
| Pro | CREATE VIEW | vw_daily_sales, vw_customer_ltv |
| Pro | Stored Procedure (IN/OUT params) | MallReport() |
| Pro | AFTER INSERT Trigger | trg_high_value |
| Pro | GENERATED ALWAYS AS column | total_sales |

---

## 📈 Key Findings

- **Technology** has the highest average transaction value (~3,100 TL per unit)
- **Clothing** drives the highest transaction volume (most purchases)
- **Kanyon** and **Mall of Istanbul** consistently rank as top-revenue malls
- **Female customers** account for ~60% of total spend
- **Gen X (36–50)** is the highest-spending age group overall
- Revenue peaks in **Q4 (Oct–Dec)** across all years — clear seasonal trend
- **Credit Card** is the most popular payment method (~35% share)
- Weekend revenue is **~12% higher** than weekday average basket size

---

## 🚀 How to Run

### Prerequisites
- MySQL 8.0+ installed
- MySQL Workbench 8.0+

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/istanbul-shopping-sql-project.git
   cd istanbul-shopping-sql-project
   ```

2. **Create the database and table**
   - Open MySQL Workbench
   - Run `sql/01_setup.sql`

3. **Import the dataset**
   - Right-click `shopping_data` in the left panel
   - Select **Table Data Import Wizard**
   - Browse to `data/customer_shopping_data.csv`
   - Map all columns → click **Finish**

4. **Run queries in order**
   ```
   sql/02_basic_queries.sql
   sql/03_intermediate_queries.sql
   sql/04_advanced_queries.sql
   sql/05_views_procedures_triggers.sql
   ```

---

## 📷 Charts & Visualizations

### Revenue by Category
![Revenue by Category](charts/01_revenue_by_category.png)

### Monthly Revenue Trend
![Monthly Trend](charts/02_monthly_revenue_trend.png)

### Revenue by Shopping Mall
![Mall Revenue](charts/03_revenue_by_mall.png)

### Payment Method Distribution
![Payment Methods](charts/04_payment_method_pie.png)

### Revenue by Gender & Category
![Gender Category](charts/05_gender_category_revenue.png)

### Revenue by Age Group
![Age Groups](charts/06_age_group_revenue.png)

---

## 🛠️ Tools & Technologies

- **Database:** MySQL 8.0
- **IDE:** MySQL Workbench 8.0
- **Data Source:** Kaggle
- **Visualization:** Matplotlib (Python) / MySQL Workbench Export
- **Version Control:** Git & GitHub

---

## 👤 Author

**[Your Name]**
B.Tech — [Your Branch] | [Your College Name] | Batch [Year]

- GitHub: [@your_username](https://github.com/your_username)
- LinkedIn: [linkedin.com/in/your_profile](https://linkedin.com/in/your_profile)

---

## 📄 License

This project is licensed under the MIT License.
The dataset is sourced from Kaggle under its respective terms of use.

---

## 🙏 Acknowledgements

- Dataset by [Mehmet Tahir Arslan](https://www.kaggle.com/mehmettahiraslan) on Kaggle
- Inspired by real-world retail analytics use cases
