{{ config(materialized='table') }}

WITH source_data AS (

  SELECT *
  FROM ST_READ('seeds/administrative_boundaries_of_national_parks.gdb')

)

SELECT *
FROM source_data
