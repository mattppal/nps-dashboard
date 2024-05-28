{{ config(materialized='table') }}

WITH source_data AS (

  SELECT
    objectid AS park_id,
    parkname AS park_name,
    unit_code AS park_code,
    unit_name AS park_full_name,
    unit_type AS park_type,
    region,
    state,
    gis_notes,
    globalid AS global_id,
    gnis_id,
    metadata,
    shape,
    shape_area,
    shape_length
  FROM {{ ref('raw_nps_boundaries__boundaries') }}

)

SELECT *
FROM source_data
