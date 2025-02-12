SELECT
    lastIndexedDate::varchar AS lastindexeddate,
    relevanceScore::double AS relevancescore,
    multimedia::struct("type" varchar, url varchar, id varchar, title varchar)[] AS multimedia,
    addresses::struct("type" varchar, line2 varchar, line1 varchar, statecode varchar, countrycode varchar, line3 varchar, city varchar, provinceterritorycode varchar, postalcode varchar)[] AS addresses,
    images::struct(url varchar, caption varchar, alttext varchar, title varchar, crops varchar[], credit varchar)[] AS images,
    directionsInfo::varchar AS directionsinfo,
    amenities::varchar[] AS amenities,
    passportStampLocationDescription::varchar AS passportstamplocationdescription,
    directionsUrl::varchar AS directionsurl,
    geometryPoiId::varchar AS geometrypoiid,
    name::varchar AS name,
    description::varchar AS description,
    isPassportStampLocation::bigint AS ispassportstamplocation,
    operatingHours::struct("name" varchar, standardhours struct(friday varchar, sunday varchar, thursday varchar, tuesday varchar, saturday varchar, monday varchar, wednesday varchar), description varchar, exceptions struct(enddate date, "name" varchar, startdate date, exceptionhours struct(friday varchar, sunday varchar, thursday varchar, saturday varchar, monday varchar, wednesday varchar, tuesday varchar))[])[] AS operatinghours,
    audioDescription::varchar AS audiodescription,
    parkCode::varchar AS parkcode,
    latLong::varchar AS latlong,
    passportStampImages::struct(url varchar, caption varchar, title varchar, alttext varchar, crops struct(url varchar, aspectratio double)[], description varchar, credit varchar)[] AS passportstampimages,
    latitude::double AS latitude,
    url::varchar AS url,
    longitude::double AS longitude,
    contacts::struct(emailaddresses struct(emailaddress varchar, description varchar)[], phonenumbers struct("extension" varchar, "type" varchar, description varchar, phonenumber varchar)[]) AS contacts,
    id::varchar AS id
FROM {{ source('raw_nps_api', 'visitorcenters') }}