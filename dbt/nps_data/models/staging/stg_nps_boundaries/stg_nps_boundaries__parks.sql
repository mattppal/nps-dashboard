{{ config(materialized='table') }}

WITH source_data AS (

  SELECT DISTINCT
    park_id,
    park_name,
    park_code,
    park_full_name,
    park_type
      AS region,
    state
  FROM {{ ref('stg_nps_boundaries__boundaries') }}

)

SELECT *
FROM source_data
