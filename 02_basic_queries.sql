-- ============================================================
--  BASIC QUERIES (Q1 - Q5)
-- ============================================================
USE istanbul_shopping;

-- Q1: Total revenue per product category
SELECT
  category,
  COUNT(*)                       AS transactions,
  SUM(quantity)                  AS units_sold,
  ROUND(SUM(total_sales), 2)     AS total_revenue,
  ROUND(AVG(price), 2)           AS avg_unit_price
FROM shopping_data
GROUP BY category
ORDER BY total_revenue DESC;

-- Q2: Revenue by shopping mall
SELECT
  shopping_mall,
  COUNT(*)                       AS total_transactions,
  ROUND(SUM(total_sales), 2)     AS total_revenue,
  ROUND(AVG(total_sales), 2)     AS avg_basket_size
FROM shopping_data
GROUP BY shopping_mall
ORDER BY total_revenue DESC;

-- Q3: Payment method breakdown (with % share)
SELECT
  payment_method,
  COUNT(*)                                                             AS usage_count,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM shopping_data), 2)  AS pct_share,
  ROUND(SUM(total_sales), 2)                                          AS revenue
FROM shopping_data
GROUP BY payment_method
ORDER BY usage_count DESC;

-- Q4: Gender-wise spending comparison
SELECT
  gender,
  COUNT(*)                       AS transactions,
  ROUND(SUM(total_sales), 2)     AS total_spend,
  ROUND(AVG(total_sales), 2)     AS avg_spend_per_txn
FROM shopping_data
GROUP BY gender;

-- Q5: Monthly revenue trend
SELECT
  YEAR(invoice_date)             AS yr,
  MONTHNAME(invoice_date)        AS month_name,
  COUNT(*)                       AS transactions,
  ROUND(SUM(total_sales), 2)     AS monthly_revenue
FROM shopping_data
GROUP BY yr, MONTH(invoice_date), month_name
ORDER BY yr, MONTH(invoice_date);
