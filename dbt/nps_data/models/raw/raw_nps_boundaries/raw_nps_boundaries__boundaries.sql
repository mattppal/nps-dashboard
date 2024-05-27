{{ config(materialized='table') }}

WITH source_data AS (

    SELECT
        *
    FROM ST_Read('seeds/administrative_boundaries_of_national_parks.gdb')

)

SELECT
    *
FROM source_data