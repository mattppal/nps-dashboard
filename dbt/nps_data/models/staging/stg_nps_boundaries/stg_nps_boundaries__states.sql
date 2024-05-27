{{ config(materialized='table') }}

WITH source_data AS (

    SELECT
        DISTINCT state
    FROM {{ ref('stg_nps_boundaries__boundaries') }}

)

SELECT
    *
FROM source_data