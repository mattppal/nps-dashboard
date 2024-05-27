{{ config(materialized='table') }}

WITH source_data AS (

    SELECT
        CREATED_BY as created_by,
        Creator as creator,
        DATE_EDIT as date_edit,
        EditDate as edit_date,
        Editor as editor,
        GIS_Notes as gis_notes,
        GlobalID as global_id,
        GNIS_ID as gnis_id,
        METADATA as metadata,
        OBJECTID as object_id,
        PARKNAME as parkname,
        REGION as region,
        Shape as shape,
        Shape_Area as shape_area,
        Shape_Length as shape_length,
        STATE as state,
        UNIT_CODE as unit_code,
        UNIT_NAME as unit_name,
        UNIT_TYPE as unit_type
    FROM {{ ref('raw_nps_boundaries__boundaries') }}

)

SELECT
    *
FROM source_data