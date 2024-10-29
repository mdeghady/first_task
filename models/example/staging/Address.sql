with sources_full_address AS(
    --- Get the full address from the sources
    SELECT TRIM(LOWER(address_line)) AS address ,
        TRIM(REPLACE(LOWER(county) , 'county' , '') ) AS county, state,
        TRIM(REPLACE(LOWER(city) , 'city' , '') ) AS city,
        zip AS zip_code
    FROM {{ source('main_Sources' , 'reonomy_property') }}
    UNION
    SELECT TRIM(LOWER(address)) AS address ,
        TRIM(REPLACE(LOWER(county) , 'county' , '') ) AS county, state,
        TRIM(REPLACE(LOWER(city) , 'city' , '') ) AS city,
        zip_code AS zip_code
    FROM {{ ref('dbusa_with_county') }}
),us_geo_parts AS(
    select cities.name as city_name , cities.id as city_id,
    states.name as state_name , states.id as state_id,
    counties.name as county_name , counties.id as county_id,
    zips.zip_code AS zip_code , zips.id as zip_id
    FROM {{ ref("zip_code") }} AS zips
    LEFT JOIN {{ ref("State") }} AS states
    ON zips.state_id = states.id
    LEFT JOIN {{ ref("County") }} AS counties
    ON zips.county_id = counties.id
    LEFT JOIN {{ ref("City") }} AS cities
    ON zips.city_id = cities.id
)


SELECT sources_full_address.address,
    us_geo_parts.zip_id AS zip_code_id ,
    us_geo_parts.state_id AS state_id ,
    us_geo_parts.county_id AS county_id ,
    us_geo_parts.city_id AS city_id ,
    ROW_NUMBER() OVER (ORDER BY sources_full_address.address) AS id
FROM sources_full_address
LEFT JOIN us_geo_parts
ON sources_full_address.state = us_geo_parts.state_name
AND sources_full_address.county = us_geo_parts.county_name
AND sources_full_address.city = us_geo_parts.city_name
AND sources_full_address.zip_code = us_geo_parts.zip_code
