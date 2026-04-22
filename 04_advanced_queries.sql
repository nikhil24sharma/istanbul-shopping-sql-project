-- ============================================================
--  ADVANCED QUERIES (Q11 - Q15) — Window Functions & CTEs
-- ============================================================
USE istanbul_shopping;

-- Q11: Running total revenue (SUM OVER window function)
SELECT
  invoice_date,
  invoice_no,
  ROUND(total_sales, 2) AS sale,
  ROUND(
    SUM(total_sales) OVER (
      ORDER BY invoice_date, invoice_no
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2
  ) AS running_total
FROM shopping_data
ORDER BY invoice_date
LIMIT 100;

-- Q12: Month-over-month revenue growth % (CTE + LAG)
WITH monthly_rev AS (
  SELECT
    DATE_FORMAT(invoice_date, '%Y-%m') AS yr_month,
    ROUND(SUM(total_sales), 2)         AS revenue
  FROM shopping_data
  GROUP BY yr_month
)
SELECT
  yr_month,
  revenue,
  LAG(revenue) OVER (ORDER BY yr_month)  AS prev_month_revenue,
  ROUND(
    (revenue - LAG(revenue) OVER (ORDER BY yr_month))
    / LAG(revenue) OVER (ORDER BY yr_month) * 100
  , 2) AS growth_pct
FROM monthly_rev;

-- Q13: Rank malls by revenue within each year (DENSE_RANK)
WITH yearly_mall AS (
  SELECT
    YEAR(invoice_date)           AS yr,
    shopping_mall,
    ROUND(SUM(total_sales), 2)   AS revenue
  FROM shopping_data
  GROUP BY yr, shopping_mall
)
SELECT
  yr,
  shopping_mall,
  revenue,
  DENSE_RANK() OVER (PARTITION BY yr ORDER BY revenue DESC) AS rank_in_year
FROM yearly_mall
ORDER BY yr, rank_in_year;

-- Q14: 3-month rolling average revenue per mall
WITH mall_monthly AS (
  SELECT
    shopping_mall,
    DATE_FORMAT(invoice_date, '%Y-%m') AS yr_month,
    SUM(total_sales)                   AS revenue
  FROM shopping_data
  GROUP BY shopping_mall, yr_month
)
SELECT
  shopping_mall,
  yr_month,
  ROUND(revenue, 2) AS revenue,
  ROUND(
    AVG(revenue) OVER (
      PARTITION BY shopping_mall
      ORDER BY yr_month
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2
  ) AS rolling_3m_avg
FROM mall_monthly
ORDER BY shopping_mall, yr_month;

-- Q15: Category revenue % contribution per year
WITH cat_year AS (
  SELECT
    YEAR(invoice_date) AS yr,
    category,
    SUM(total_sales)   AS cat_rev
  FROM shopping_data
  GROUP BY yr, category
),
year_total AS (
  SELECT yr, SUM(cat_rev) AS yr_rev
  FROM cat_year
  GROUP BY yr
)
SELECT
  c.yr,
  c.category,
  ROUND(c.cat_rev, 2)                   AS category_revenue,
  ROUND(c.cat_rev / y.yr_rev * 100, 2)  AS pct_of_year
FROM cat_year c
JOIN year_total y ON c.yr = y.yr
ORDER BY c.yr, pct_of_year DESC;
