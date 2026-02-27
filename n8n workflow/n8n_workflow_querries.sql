--Summary workflow
--1) Daily KPI Summary (static data, “yesterday” = max(order_date) - 1)
WITH asof AS (
  SELECT MAX(order_date)::date AS as_of_date
  FROM dw_supply_chain_clean
),
d AS (
  SELECT
    (as_of_date - INTERVAL '1 day')::date AS yday,
    (as_of_date - INTERVAL '2 day')::date AS day_before
  FROM asof
),
yday_data AS (
  SELECT *
  FROM dw_supply_chain_clean s
  JOIN d ON s.order_date::date = d.yday
),
prev_data AS (
  SELECT *
  FROM dw_supply_chain_clean s
  JOIN d ON s.order_date::date = d.day_before
)
SELECT
  (SELECT yday FROM d) AS report_date,

  ROUND(COALESCE(SUM(sales), 0), 2) AS total_sales,
  ROUND(COALESCE(SUM(order_profit), 0), 2) AS total_profit,

  ROUND(
    COALESCE(SUM(order_profit),0)
    / NULLIF(COALESCE(SUM(order_total),0),0) * 100
  , 2) AS profit_margin_pct,

  ROUND(AVG(CASE WHEN late_delivery_risk = 1 THEN 1 ELSE 0 END) * 100, 2) AS late_delivery_pct,

  COUNT(*) FILTER (WHERE late_delivery_risk = 1) AS high_risk_orders,

  ROUND(
    (
      (SELECT COUNT(*) FROM yday_data WHERE late_delivery_risk = 1)
      -
      (SELECT COUNT(*) FROM prev_data WHERE late_delivery_risk = 1)
    ) * 100.0
    / NULLIF((SELECT COUNT(*) FROM prev_data WHERE late_delivery_risk = 1),0)
  ,2) AS late_orders_change_pct
FROM yday_data;

--2) Top 5 Products by Sales (yesterday)
WITH asof AS (
  SELECT MAX(order_date)::date AS as_of_date
  FROM dw_supply_chain_clean
),
d AS (
  SELECT (as_of_date - INTERVAL '1 day')::date AS yday
  FROM asof
)
SELECT
  product_name,
  ROUND(SUM(sales), 2) AS total_sales
FROM dw_supply_chain_clean s
JOIN d ON s.order_date::date = d.yday
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 5;

--3) Website Traffic (yesterday, from access logs)
WITH asof AS (
  SELECT MAX(access_day)::date AS as_of_date
  FROM dw_access_logs_clean
),
d AS (
  SELECT (as_of_date - INTERVAL '1 day')::date AS yday
  FROM asof
)
SELECT
  (SELECT yday FROM d) AS report_date,
  COALESCE(SUM(total_views), 0) AS total_views,
  COALESCE(SUM(unique_visitors), 0) AS unique_visitors
FROM dw_access_logs_clean a
JOIN d ON a.access_day::date = d.yday;

-- Add Code Node (Merge All Data)
--Node: Code
--Language: JavaScript

const kpi = $items("KPI_Summary_Static")[0].json;
const views = $items("Traffic_Static")[0].json;
const topProducts = $items("Top5_Products_Static").map(i => i.json);

return [{
  json: {
    report_date: kpi.report_date,
    total_sales: kpi.total_sales,
    total_profit: kpi.total_profit,
    profit_margin_pct: kpi.profit_margin_pct,
    late_delivery_pct: kpi.late_delivery_pct,
    high_risk_orders: kpi.high_risk_orders,
    late_orders_change_pct: kpi.late_orders_change_pct,
    total_views: views.total_views,
    top_products: topProducts
  }
}];

-- USER Prompt:
-- Here are business KPIs:

-- {{ JSON.stringify($json) }}

-- Tasks:
-- 1) Write DAILY SUMMARY (max 140 words).
-- 2) Highlight key risks.
-- 3) Suggest 3 actions.
-- 4) If late_delivery_pct > 15%, call it operational risk.
-- 5) If late_orders_change_pct > 10%, mention increase trend.

-- Format:

-- DAILY SUMMARY:
-- ...

-- RISKS:
-- - ...
-- - ...

-- ACTIONS:
-- 1) ...
-- 2) ...
-- 3) ...


------------------------------------------
--Risk alert workflow
--1)Risk Alert Headline (yday vs day_before)

WITH asof AS (
  SELECT MAX(order_date)::date AS as_of_date
  FROM dw_supply_chain_clean
),
d AS (
  SELECT
    (as_of_date - INTERVAL '1 day')::date AS yday,
    (as_of_date - INTERVAL '2 day')::date AS day_before
  FROM asof
),
yday AS (
  SELECT *
  FROM dw_supply_chain_clean s
  JOIN d ON s.order_date::date = d.yday
),
prev AS (
  SELECT *
  FROM dw_supply_chain_clean s
  JOIN d ON s.order_date::date = d.day_before
)
SELECT
  (SELECT yday FROM d) AS report_date,

  (SELECT COUNT(*) FROM yday WHERE late_delivery_risk = 1) AS late_orders_today,
  (SELECT COUNT(*) FROM prev WHERE late_delivery_risk = 1) AS late_orders_prev,

  ROUND((SELECT AVG(shipping_delay) FROM yday), 2) AS avg_shipping_delay_today,

  (SELECT COUNT(*) FROM yday
   WHERE shipping_mode = 'Same Day'
     AND delay_flag = 'Late') AS same_day_late_today,

  ROUND(
    (
      (SELECT COUNT(*) FROM yday WHERE late_delivery_risk = 1)
      -
      (SELECT COUNT(*) FROM prev WHERE late_delivery_risk = 1)
    ) * 100.0
    / NULLIF((SELECT COUNT(*) FROM prev WHERE late_delivery_risk = 1),0)
  ,2) AS late_orders_change_pct;


--2) STEP 4: IF Node (Risk Trigger)

-- Conditions (OR logic):

-- late_orders_today > late_orders_prev

-- avg_delay_today > 0

-- same_day_late > 0

--3)STEP 5: OpenAI Alert Generator

-- Prompt:

-- You are a supply chain risk analyst.
-- Metrics:
-- {{ JSON.stringify($json) }}
-- Write:
-- ⚠️ Supply Chain Alert
-- Explain what changed.
-- Explain likely cause.
-- Suggest 3 immediate actions.
-- Keep under 120 words.
