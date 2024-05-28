{{ config(materialized='table') }}

WITH source_data AS (

  SELECT DISTINCT region
  FROM {{ ref('stg_nps_boundaries__boundaries') }}

)

SELECT *
FROM source_data
