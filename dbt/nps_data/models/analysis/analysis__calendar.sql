WITH date_spine AS (
    SELECT
       range as date_day
    FROM range(DATE '2000-01-01', current_date + INTERVAL 50 YEAR, INTERVAL 1 DAY)

), calculated AS (
  SELECT
    date_day,
    date_day AS date_actual,
    DATE_TRUNC('WEEK', date_day) AS date_week,
    DATE_TRUNC('MONTH', date_day) AS date_month,
    DATE_TRUNC('QUARTER', date_day) AS date_quarter,
    DATE_TRUNC('YEAR', date_day) AS date_year,
    DAYNAME(date_day) AS day_name,
    EXTRACT(month FROM date_day) AS month_actual,
    EXTRACT(year FROM date_day) AS year_actual,
    EXTRACT(QUARTER FROM date_day) AS quarter_actual,
    EXTRACT(DOW FROM date_day) + 1 AS day_of_week,
    CASE
      WHEN day_name = 'Sun'
      THEN date_day
      ELSE CAST(DATE_TRUNC('WEEK', date_day) AS TIMESTAMP) + INTERVAL (-1) DAY
    END AS first_day_of_week,
    CASE
      WHEN day_name = 'Sun'
      THEN EXTRACT(WEEK FROM date_day) + 1
      ELSE EXTRACT(WEEK FROM date_day)
    END AS week_of_year_temp,
    CASE
      WHEN day_name = 'Sun' AND LEAD(week_of_year_temp) OVER (ORDER BY date_day) = '1'
      THEN '1'
      ELSE week_of_year_temp
    END AS week_of_year,
    EXTRACT(day FROM date_day) AS day_of_month,
    ROW_NUMBER() OVER (PARTITION BY year_actual, quarter_actual ORDER BY date_day) AS day_of_quarter,
    ROW_NUMBER() OVER (PARTITION BY year_actual ORDER BY date_day) AS day_of_year,
    CASE WHEN month_actual < 2 THEN year_actual ELSE (
      year_actual + 1
    ) END AS fiscal_year,
    CASE
      WHEN month_actual < 2
      THEN '4'
      WHEN month_actual < 5
      THEN '1'
      WHEN month_actual < 8
      THEN '2'
      WHEN month_actual < 11
      THEN '3'
      ELSE '4'
    END AS fiscal_quarter,
    ROW_NUMBER() OVER (PARTITION BY fiscal_year, fiscal_quarter ORDER BY date_day) AS day_of_fiscal_quarter,
    ROW_NUMBER() OVER (PARTITION BY fiscal_year ORDER BY date_day) AS day_of_fiscal_year,
    MONTHNAME(date_day) AS month_name,
    DATE_TRUNC('MONTH', date_day) AS first_day_of_month,
    LAST_VALUE(date_day) OVER (PARTITION BY year_actual, month_actual ORDER BY date_day ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_day_of_month,
    FIRST_VALUE(date_day) OVER (PARTITION BY year_actual ORDER BY date_day ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS first_day_of_year,
    LAST_VALUE(date_day) OVER (PARTITION BY year_actual ORDER BY date_day ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_day_of_year,
    FIRST_VALUE(date_day) OVER (PARTITION BY year_actual, quarter_actual ORDER BY date_day ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS first_day_of_quarter,
    LAST_VALUE(date_day) OVER (PARTITION BY year_actual, quarter_actual ORDER BY date_day ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_day_of_quarter,
    FIRST_VALUE(date_day) OVER (PARTITION BY fiscal_year, fiscal_quarter ORDER BY date_day ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS first_day_of_fiscal_quarter,
    LAST_VALUE(date_day) OVER (PARTITION BY fiscal_year, fiscal_quarter ORDER BY date_day ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_day_of_fiscal_quarter,
    FIRST_VALUE(date_day) OVER (PARTITION BY fiscal_year ORDER BY date_day ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS first_day_of_fiscal_year,
    LAST_VALUE(date_day) OVER (PARTITION BY fiscal_year ORDER BY date_day ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_day_of_fiscal_year,
    DATE_DIFF('WEEK', CAST(first_day_of_fiscal_year AS TIMESTAMP), CAST(date_actual AS TIMESTAMP)) + 1 AS week_of_fiscal_year,
    CASE
      WHEN EXTRACT(MONTH FROM date_day) = 1
      THEN 12
      ELSE EXTRACT(MONTH FROM date_day) - 1
    END AS month_of_fiscal_year,
    LAST_VALUE(date_day) OVER (PARTITION BY first_day_of_week ORDER BY date_day ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_day_of_week,
    (
      year_actual || '-Q' || EXTRACT(QUARTER FROM date_day)
    ) AS quarter_name,
    (
      fiscal_year || '-' || CASE
        WHEN fiscal_quarter = 1
        THEN 'Q1'
        WHEN fiscal_quarter = 2
        THEN 'Q2'
        WHEN fiscal_quarter = 3
        THEN 'Q3'
        WHEN fiscal_quarter = 4
        THEN 'Q4'
      END
    ) AS fiscal_quarter_name,
    (
      'FY' || SUBSTRING(fiscal_quarter_name, 3, 7)
    ) AS fiscal_quarter_name_fy,
    DENSE_RANK() OVER (ORDER BY fiscal_quarter_name) AS fiscal_quarter_number_absolute,
    fiscal_year || '-' || STRFTIME(date_day, 'Month') AS fiscal_month_name,
    (
      'FY' || SUBSTRING(fiscal_month_name, 3, 8)
    ) AS fiscal_month_name_fy,
    DATE_TRUNC('MONTH', last_day_of_fiscal_quarter) AS last_month_of_fiscal_quarter,
    DATE_TRUNC('MONTH', last_day_of_fiscal_quarter) = date_actual AS is_first_day_of_last_month_of_fiscal_quarter,
    DATE_TRUNC('MONTH', last_day_of_fiscal_year) AS last_month_of_fiscal_year,
    DATE_TRUNC('MONTH', last_day_of_fiscal_year) = date_actual AS is_first_day_of_last_month_of_fiscal_year,
    CAST(CAST(first_day_of_month AS TIMESTAMP) + INTERVAL 1 MONTH AS TIMESTAMP) + INTERVAL 7 DAY AS snapshot_date_fpa,
    CAST(CAST(first_day_of_month AS TIMESTAMP) + INTERVAL 1 MONTH AS TIMESTAMP) + INTERVAL 44 DAY AS snapshot_date_billings,
    COUNT(date_actual) OVER (PARTITION BY first_day_of_month) AS days_in_month_count,
    90 - DATE_DIFF('DAY', CAST(date_actual AS TIMESTAMP), CAST(last_day_of_fiscal_quarter AS TIMESTAMP)) AS day_of_fiscal_quarter_normalised,
    12 - FLOOR(
      (
        DATE_DIFF('DAY', CAST(date_actual AS TIMESTAMP), CAST(last_day_of_fiscal_quarter AS TIMESTAMP)) / 7
      )
    ) AS week_of_fiscal_quarter_normalised,
    CASE
      WHEN week_of_fiscal_quarter_normalised < 5
      THEN week_of_fiscal_quarter_normalised
      WHEN week_of_fiscal_quarter_normalised < 9
      THEN week_of_fiscal_quarter_normalised - 4
      ELSE week_of_fiscal_quarter_normalised - 8
    END AS week_of_month_normalised,
    365 - DATE_DIFF('DAY', CAST(date_actual AS TIMESTAMP), CAST(last_day_of_fiscal_year AS TIMESTAMP)) AS day_of_fiscal_year_normalised,
    CASE
      WHEN (
        (
          DATE_DIFF('DAY', CAST(date_actual AS TIMESTAMP), CAST(last_day_of_fiscal_quarter AS TIMESTAMP)) - 6
        ) % 7 = 0
        OR date_actual = first_day_of_fiscal_quarter
      )
      THEN 1
      ELSE 0
    END AS is_first_day_of_fiscal_quarter_week,
    DATE_DIFF('DAY', CAST(date_day AS TIMESTAMP), CAST(last_day_of_month AS TIMESTAMP)) AS days_until_last_day_of_month
  FROM date_spine
), current_date_information AS (
  SELECT
    fiscal_year AS current_fiscal_year,
    first_day_of_fiscal_year AS current_first_day_of_fiscal_year,
    fiscal_quarter_name_fy AS current_fiscal_quarter_name_fy,
    first_day_of_month AS current_first_day_of_month
  FROM calculated
  WHERE
    date_actual = current_date
)
SELECT
  calculated.date_day,
  calculated.date_week,
  calculated.date_month,
  calculated.date_quarter,
  calculated.date_year,
  calculated.date_actual,
  calculated.day_name,
  calculated.month_actual,
  calculated.year_actual,
  calculated.quarter_actual,
  calculated.day_of_week,
  calculated.first_day_of_week,
  calculated.week_of_year,
  calculated.day_of_month,
  calculated.day_of_quarter,
  calculated.day_of_year,
  calculated.fiscal_year,
  calculated.fiscal_quarter,
  calculated.day_of_fiscal_quarter,
  calculated.day_of_fiscal_year,
  calculated.month_name,
  calculated.first_day_of_month,
  calculated.last_day_of_month,
  calculated.first_day_of_year,
  calculated.last_day_of_year,
  calculated.first_day_of_quarter,
  calculated.last_day_of_quarter,
  calculated.first_day_of_fiscal_quarter,
  calculated.last_day_of_fiscal_quarter,
  calculated.first_day_of_fiscal_year,
  calculated.last_day_of_fiscal_year,
  calculated.week_of_fiscal_year,
  calculated.month_of_fiscal_year,
  calculated.last_day_of_week,
  calculated.quarter_name,
  calculated.fiscal_quarter_name,
  calculated.fiscal_quarter_name_fy,
  calculated.fiscal_quarter_number_absolute,
  calculated.fiscal_month_name,
  calculated.fiscal_month_name_fy,
  calculated.last_month_of_fiscal_quarter,
  calculated.is_first_day_of_last_month_of_fiscal_quarter,
  calculated.last_month_of_fiscal_year,
  calculated.is_first_day_of_last_month_of_fiscal_year,
  calculated.snapshot_date_fpa,
  calculated.snapshot_date_billings,
  calculated.days_in_month_count,
  calculated.week_of_month_normalised,
  calculated.day_of_fiscal_quarter_normalised,
  calculated.week_of_fiscal_quarter_normalised,
  calculated.day_of_fiscal_year_normalised,
  calculated.is_first_day_of_fiscal_quarter_week,
  calculated.days_until_last_day_of_month,
  -- current_date_information.current_fiscal_year,
  -- current_date_information.current_first_day_of_fiscal_year,
  -- current_date_information.current_fiscal_quarter_name_fy,
  -- current_date_information.current_first_day_of_month
FROM calculated
-- CROSS JOIN current_date_information
