-- ============================================================
--  VIEWS, STORED PROCEDURES & TRIGGERS
-- ============================================================
USE istanbul_shopping;

-- -------------------------------------------------------
-- VIEW 1: Daily Sales Summary
-- -------------------------------------------------------
CREATE OR REPLACE VIEW vw_daily_sales AS
SELECT
  invoice_date,
  shopping_mall,
  category,
  gender,
  COUNT(*)                       AS transactions,
  SUM(quantity)                  AS units_sold,
  ROUND(SUM(total_sales), 2)     AS daily_revenue
FROM shopping_data
GROUP BY invoice_date, shopping_mall, category, gender;

-- Usage:
-- SELECT * FROM vw_daily_sales WHERE shopping_mall = 'Kanyon' ORDER BY invoice_date DESC LIMIT 20;


-- -------------------------------------------------------
-- VIEW 2: Customer Lifetime Value
-- -------------------------------------------------------
CREATE OR REPLACE VIEW vw_customer_ltv AS
SELECT
  customer_id,
  gender,
  age,
  COUNT(*)                       AS total_visits,
  SUM(quantity)                  AS total_units_bought,
  ROUND(SUM(total_sales), 2)     AS lifetime_value,
  ROUND(AVG(total_sales), 2)     AS avg_basket,
  MIN(invoice_date)              AS first_purchase,
  MAX(invoice_date)              AS last_purchase
FROM shopping_data
GROUP BY customer_id, gender, age;


-- -------------------------------------------------------
-- STORED PROCEDURE: Mall performance for a date range
-- -------------------------------------------------------
DROP PROCEDURE IF EXISTS MallReport;

DELIMITER //
CREATE PROCEDURE MallReport(
  IN  p_mall       VARCHAR(50),
  IN  p_start      DATE,
  IN  p_end        DATE,
  OUT p_txn_count  INT,
  OUT p_revenue    DECIMAL(15,2)
)
BEGIN
  SELECT
    COUNT(*),
    ROUND(SUM(total_sales), 2)
  INTO p_txn_count, p_revenue
  FROM shopping_data
  WHERE shopping_mall = p_mall
    AND invoice_date BETWEEN p_start AND p_end;
END //
DELIMITER ;

-- Usage:
-- CALL MallReport('Kanyon', '2022-01-01', '2022-12-31', @txns, @rev);
-- SELECT @txns AS transactions_2022, @rev AS revenue_2022;


-- -------------------------------------------------------
-- HIGH VALUE LOG TABLE + TRIGGER
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS high_value_log (
  log_id      INT PRIMARY KEY AUTO_INCREMENT,
  invoice_no  VARCHAR(10),
  total_sales DECIMAL(12,2),
  logged_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TRIGGER IF EXISTS trg_high_value;

DELIMITER //
CREATE TRIGGER trg_high_value
AFTER INSERT ON shopping_data
FOR EACH ROW
BEGIN
  IF NEW.total_sales > 5000 THEN
    INSERT INTO high_value_log (invoice_no, total_sales)
    VALUES (NEW.invoice_no, NEW.total_sales);
  END IF;
END //
DELIMITER ;
