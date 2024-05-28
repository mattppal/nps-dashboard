{{ config(materialized='table') }}

WITH source_data AS (

  SELECT
    parkname AS park_name,
    unitcode AS unit_code,
    parktype AS park_type,
    region,
    state,
    CONCAT(year, '-', month, '-01')::DATE AS date,
    REPLACE(recreationvisits, ',', '')::INT64 AS recreation_visits,
    REPLACE(nonrecreationvisits, ',', '')::INT64 AS non_recreation_visits,
    REPLACE(recreationhours, ',', '')::INT64 AS recreation_hours,
    REPLACE(nonrecreationhours, ',', '')::INT64 AS non_recreation_hours,
    REPLACE(concessionerlodging, ',', '')::INT64 AS concessioner_lodging,
    REPLACE(concessionercamping, ',', '')::INT64 AS concessioner_camping,
    REPLACE(tentcampers, ',', '')::INT64 AS tent_campers,
    REPLACE(rvcampers, ',', '')::INT64 AS rv_campers,
    REPLACE(backcountry, ',', '')::INT64 AS backcountry,
    REPLACE(nonrecreationovernightstays, ',', '')::INT64
      AS non_recreation_overnight_stays,
    REPLACE(miscellaneousovernightstays, ',', '')::INT64
      AS miscellaneous_overnight_stays
  FROM {{ ref('nps_irma_1979_2023') }}

)

SELECT *
FROM source_data
