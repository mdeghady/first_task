--- Adding counties that exist in both sources
with sources_state_county_city AS (
    --- rmoving word county if placed in county name and any spaces
    SELECT TRIM(REPLACE(LOWER(county) , 'county' , '') ) AS county, state,
        TRIM(REPLACE(LOWER(city) , 'city' , '') ) AS city
    FROM {{ source('main_Sources' , 'reonomy_property') }}
    UNION
    SELECT TRIM(REPLACE(LOWER(county) , 'county' , '') ) AS county, state,
        TRIM(REPLACE(LOWER(city) , 'city' , '') ) AS city
    FROM {{ ref('dbusa_with_county') }}
    WHERE county IS NOT NULL AND state IS NOT NULL
),states_and_counties AS (
    SELECT states.name AS state_name , states.id AS state_id,
    counties.name AS county_name , counties.id AS county_id
    FROM {{ ref('County') }} AS counties
    LEFT JOIN {{ ref("State") }} AS states
    ON counties.state_id = states.id
)

SELECT source_data.city AS name , snc.state_id AS state_id ,
 snc.county_id AS county_id , ROW_NUMBER() OVER (ORDER BY source_data.city) AS id
 FROM sources_state_county_city AS source_data
 LEFT JOIN states_and_counties AS snc
 ON source_data.county = snc.county_name AND source_data.state = snc.state_name
