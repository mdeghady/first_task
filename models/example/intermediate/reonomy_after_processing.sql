WITH all_usa_gro_parts AS(
    select addresses.address AS address , addresses.id AS address_id,
    cities.name as city_name , cities.id as city_id,
    states.name as state_name , states.id as state_id,
    counties.name as county_name , counties.id as county_id,
    zips.zip_code AS zip_code , zips.id as zip_id
    FROM {{ ref("Address") }} AS addresses
    LEFT JOIN {{ ref("State") }} AS states
    ON addresses.state_id = states.id
    LEFT JOIN {{ ref("County") }} AS counties
    ON addresses.county_id = counties.id
    LEFT JOIN {{ ref("City") }} AS cities
    ON addresses.city_id = cities.id
    LEFT JOIN {{ ref("zip_code") }} AS zips
    ON addresses.zip_code_id = zips.id
), reonomy_cleaned AS(
    SELECT property_id , state,
    TRIM(REPLACE(LOWER(county) , 'county' , '') ) AS county,
    TRIM(REPLACE(LOWER(city) , 'city' , '') ) AS city,
    TRIM(LOWER(address_line)) AS address,
    zip AS zip_code
    FROM {{ source('main_Sources' , 'reonomy_property') }}

)

SELECT reonomy_cleaned.property_id AS property_id,
    all_usa_gro_parts.address_id,
    all_usa_gro_parts.zip_id AS zip_code_id ,
    all_usa_gro_parts.state_id AS state_id ,
    all_usa_gro_parts.county_id AS county_id ,
    all_usa_gro_parts.city_id AS city_id
FROM reonomy_cleaned
LEFT JOIN all_usa_gro_parts
ON reonomy_cleaned.state = all_usa_gro_parts.state_name
AND reonomy_cleaned.county = all_usa_gro_parts.county_name
AND reonomy_cleaned.city = all_usa_gro_parts.city_name
AND reonomy_cleaned.zip_code = all_usa_gro_parts.zip_code
AND reonomy_cleaned.address = all_usa_gro_parts.address
