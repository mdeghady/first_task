--- Adding the zip code model
with all_zip_codes AS(
    --- Get All zip codes in the sources
    SELECT zip AS zip_code ,
        TRIM(REPLACE(LOWER(county) , 'county' , '') ) AS county, state,
        TRIM(REPLACE(LOWER(city) , 'city' , '') ) AS city
    FROM {{ source('main_Sources' , 'reonomy_property') }}
    UNION
    SELECT zip_code AS zip_code ,
        TRIM(REPLACE(LOWER(county) , 'county' , '') ) AS county, state,
        TRIM(REPLACE(LOWER(city) , 'city' , '') ) AS city
    FROM {{ ref('dbusa_with_county') }}
),us_city_county_state AS(
    select cities.name as city_name , cities.id as city_id,
    states.name as state_name , states.id as state_id,
    counties.name as county_name , counties.id as county_id
    FROM {{ ref("City") }} AS cities
    LEFT JOIN {{ ref("State") }} AS states
    ON cities.state_id = states.id
    LEFT JOIN {{ ref("County") }} AS counties
    ON cities.county_id = counties.id
)

--- define the zip code model query
SELECT all_zip_codes.zip_code AS zip_code ,
    us_city_county_state.state_id AS state_id ,
    us_city_county_state.county_id AS county_id ,
    us_city_county_state.city_id AS city_id ,
    ROW_NUMBER() OVER (ORDER BY all_zip_codes.zip_code) AS id
FROM all_zip_codes
LEFT JOIN us_city_county_state
ON all_zip_codes.state = us_city_county_state.state_name
AND all_zip_codes.county = us_city_county_state.county_name
AND all_zip_codes.city = us_city_county_state.city_name

