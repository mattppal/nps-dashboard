SELECT
    longitude::double AS longitude,
    url::varchar AS url,
    tags::varchar[] AS tags,
    status::varchar AS status,
    relatedParks::struct("name" varchar, fullname varchar, parkcode varchar, designation varchar, url varchar, states varchar)[] AS relatedparks,
    credit::varchar AS credit,
    images::struct(crops struct(url varchar, aspectratio double)[], caption varchar, description varchar, title varchar, alttext varchar, credit varchar, url varchar)[] AS images,
    geometryPoiId::varchar AS geometrypoiid,
    isStreaming::boolean AS isstreaming,
    description::varchar AS description,
    title::varchar AS title,
    latitude::double AS latitude,
    statusMessage::varchar AS statusmessage,
    id::varchar AS id
FROM {{ source('raw_nps_api', 'webcams') }}