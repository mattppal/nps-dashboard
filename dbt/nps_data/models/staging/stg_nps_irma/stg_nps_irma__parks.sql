{{ config(materialized='table') }}

WITH source_data AS (

    SELECT
        DISTINCT park_name,
        unit_code,
        park_type
    FROM {{ ref('stg_nps_irma__usage_1979_2023') }}

)

SELECT
    *
FROM source_data