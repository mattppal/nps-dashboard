SELECT
    liveStatus::struct(expirationdate timestamp with time zone, description varchar, estimatedwaittimeinminutes bigint, occupancy varchar, isactive boolean) AS livestatus,
    accessibility::struct(adafacilitiesdescription varchar, numberofadastepfreespaces bigint, numberofadavanaccessbilespaces bigint, numberofadaspaces bigint, totalspaces bigint, numberofoversizevehiclespaces bigint, islotaccessibletodisabled boolean) AS accessibility,
    images::struct(url varchar, caption varchar, alttext varchar, title varchar, credit varchar)[] AS images,
    operatingHours::struct("name" varchar, standardhours struct(friday varchar, sunday varchar, thursday varchar, tuesday varchar, saturday varchar, monday varchar, wednesday varchar), description varchar, exceptions struct(enddate date, "name" varchar, startdate date, exceptionhours struct(friday varchar, sunday varchar, thursday varchar, tuesday varchar, saturday varchar, monday varchar, wednesday varchar))[])[] AS operatinghours,
    fees::struct(description varchar, title varchar, "cost" double)[] AS fees,
    name::varchar AS name,
    geometryPoiId::varchar AS geometrypoiid,
    webcamUrl::varchar AS webcamurl,
    managedByOrganization::varchar AS managedbyorganization,
    latitude::double AS latitude,
    description::varchar AS description,
    altName::varchar AS altname,
    timeZone::varchar AS timezone,
    relatedParks::struct("name" varchar, fullname varchar, parkcode varchar, designation varchar, url varchar, states varchar)[] AS relatedparks,
    longitude::double AS longitude,
    contacts::struct(emailaddresses struct(emailaddress varchar, description varchar)[], phonenumbers struct("extension" varchar, "type" varchar, description varchar, phonenumber varchar)[]) AS contacts,
    id::varchar AS id
FROM {{ source('raw_nps_api', 'parkinglots') }}