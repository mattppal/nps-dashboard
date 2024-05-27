{{ config(materialized='table') }}

WITH source_data AS (

    SELECT
        ParkName AS park_name,
        UnitCode AS unit_code,
        ParkType AS park_type,
        Region AS region,
        State AS state,
        CONCAT(Year, '-', Month, '-01')::DATE AS date,
        REPLACE(RecreationVisits, ',', '')::INT64 AS recreation_visits,
        REPLACE(NonRecreationVisits, ',', '')::INT64 AS non_recreation_visits,
        REPLACE(RecreationHours, ',', '')::INT64 AS recreation_hours,
        REPLACE(NonRecreationHours, ',', '')::INT64 AS non_recreation_hours,
        REPLACE(ConcessionerLodging, ',', '')::INT64 AS concessioner_lodging,
        REPLACE(ConcessionerCamping, ',', '')::INT64 AS concessioner_camping,
        REPLACE(TentCampers, ',', '')::INT64 AS tent_campers,
        REPLACE(RVCampers, ',', '')::INT64 AS rv_campers,
        REPLACE(Backcountry, ',', '')::INT64 AS backcountry,
        REPLACE(NonRecreationOvernightStays, ',', '')::INT64 AS non_recreation_overnight_stays,
        REPLACE(MiscellaneousOvernightStays, ',', '')::INT64 AS miscellaneous_overnight_stays
    FROM {{ ref('nps_irma_1979_2023') }}

)

SELECT
    *
FROM source_data