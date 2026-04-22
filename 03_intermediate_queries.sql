-- ============================================================
--  INTERMEDIATE QUERIES (Q6 - Q10)
-- ============================================================
USE istanbul_shopping;

-- Q6: Customer age segmentation with CASE WHEN
SELECT
  CASE
    WHEN age BETWEEN 18 AND 25 THEN '18-25 Gen Z'
    WHEN age BETWEEN 26 AND 35 THEN '26-35 Millennial'
    WHEN age BETWEEN 36 AND 50 THEN '36-50 Gen X'
    ELSE '51+ Boomer'
  END                            AS age_group,
  COUNT(*)                       AS transactions,
  ROUND(SUM(total_sales), 2)     AS total_spend,
  ROUND(AVG(total_sales), 2)     AS avg_basket
FROM shopping_data
GROUP BY age_group
ORDER BY total_spend DESC;

-- Q7: Top-selling category per mall (Subquery + RANK window function)
SELECT s.shopping_mall, s.category, s.revenue
FROM (
  SELECT
    shopping_mall,
    category,
    ROUND(SUM(total_sales), 2) AS revenue,
    RANK() OVER (
      PARTITION BY shopping_mall
      ORDER BY SUM(total_sales) DESC
    ) AS rnk
  FROM shopping_data
  GROUP BY shopping_mall, category
) s
WHERE s.rnk = 1
ORDER BY revenue DESC;

-- Q8: High-value customers (above average lifetime spend)
SELECT
  customer_id,
  gender,
  age,
  ROUND(SUM(total_sales), 2) AS lifetime_spend
FROM shopping_data
GROUP BY customer_id, gender, age
HAVING SUM(total_sales) > (
  SELECT AVG(cust_total)
  FROM (
    SELECT SUM(total_sales) AS cust_total
    FROM shopping_data
    GROUP BY customer_id
  ) t
)
ORDER BY lifetime_spend DESC
LIMIT 20;

-- Q9: Weekend vs Weekday sales (DAYOFWEEK: 1=Sunday, 7=Saturday)
SELECT
  CASE
    WHEN DAYOFWEEK(invoice_date) IN (1, 7) THEN 'Weekend'
    ELSE 'Weekday'
  END                            AS day_type,
  COUNT(*)                       AS transactions,
  ROUND(SUM(total_sales), 2)     AS revenue,
  ROUND(AVG(total_sales), 2)     AS avg_basket
FROM shopping_data
GROUP BY day_type;

-- Q10: Gender x Category cross-tab (CASE pivot)
SELECT
  category,
  ROUND(SUM(CASE WHEN gender = 'Male'   THEN total_sales ELSE 0 END), 2) AS male_revenue,
  ROUND(SUM(CASE WHEN gender = 'Female' THEN total_sales ELSE 0 END), 2) AS female_revenue,
  ROUND(SUM(total_sales), 2)                                              AS total_revenue
FROM shopping_data
GROUP BY category
ORDER BY total_revenue DESC;
