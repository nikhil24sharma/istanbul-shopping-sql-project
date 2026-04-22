-- ============================================================
--  Istanbul Shopping Mall Analysis
--  Dataset : Kaggle - Customer Shopping Dataset (Retail Sales)
--  Author  : [Your Name] | B.Tech Final Year Project
--  Tool    : MySQL Workbench 8.0+
-- ============================================================

CREATE DATABASE IF NOT EXISTS istanbul_shopping;
USE istanbul_shopping;

-- -------------------------------------------------------
-- TABLE CREATION
-- -------------------------------------------------------
DROP TABLE IF EXISTS shopping_data;

CREATE TABLE shopping_data (
  invoice_no      VARCHAR(10)   PRIMARY KEY,
  customer_id     VARCHAR(10)   NOT NULL,
  gender          ENUM('Male','Female'),
  age             INT,
  category        VARCHAR(30),
  quantity        INT,
  price           DECIMAL(10,2),
  payment_method  VARCHAR(15),
  invoice_date    DATE,
  shopping_mall   VARCHAR(50)
);

-- -------------------------------------------------------
-- AFTER CSV IMPORT: add computed column
-- -------------------------------------------------------
ALTER TABLE shopping_data
  ADD COLUMN total_sales DECIMAL(12,2)
  GENERATED ALWAYS AS (quantity * price) STORED;

-- -------------------------------------------------------
-- VERIFY IMPORT
-- -------------------------------------------------------
SELECT
  COUNT(*)          AS total_rows,
  MIN(invoice_date) AS earliest_date,
  MAX(invoice_date) AS latest_date,
  COUNT(DISTINCT shopping_mall) AS malls,
  COUNT(DISTINCT category)      AS categories
FROM shopping_data;
