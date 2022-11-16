-- Show table schem-fa 
\d+ retail;

-- Show first 10 rows
SELECT * FROM retail limit 10;

-- Check # of records
SELECT COUNT(*) FROM retail;

-- number of clients (e.g. unique client ID)
SELECT COUNT(*) FROM (SELECT COUNT(*) FROM retail WHERE customer_id IS NOT NULL GROUP BY customer_id) AS client;

--invoice date range (e.g. max/min dates)
SELECT MAX(invoice_date) AS max, MIN(invoice_date) AS min FROM retail;

--number of SKU/merchants (e.g. unique stock code)
SELECT COUNT(*) FROM (SELECT COUNT(*) FROM retail WHERE stock_code IS NOT NULL GROUP BY stock_code) AS merchants;

--Calculate average invoice amount excluding invoices with a negative amount (e.g. canceled orders have negative amount)
SELECT AVG(invoice) FROM (SELECT SUM(unit_price * quantity)AS invoice, invoice_no FROM retail GROUP BY invoice_no HAVING SUM(unit_price * quantity) >0) AS AVG;

--Calculate total revenue (e.g. sum of unit_price * quantity)
SELECT sum(unit_price * quantity) FROM retail as sum;

-- Calculate total revenue by YYYYMM 
SELECT (CAST(EXTRACT(YEAR FROM invoice_date) AS INTEGER)*100+ CAST(EXTRACT( MONTH FROM invoice_date) AS INTEGER)) AS YYYYMM, SUM(unit_price * quantity) FROM retail GROUP BY YYYYMM ORDER BY YYYYMM;
