--- Adding counties that exist in both sources
with counties_and_states AS (
    --- rmoving word county if placed in county name and any spaces
    SELECT TRIM(REPLACE(LOWER(county) , 'county' , '') ) AS county, state
    FROM {{ source('main_Sources' , 'reonomy_property') }}
    UNION
    SELECT TRIM(REPLACE(LOWER(county) , 'county' , '') ) AS county, state
    FROM {{ ref('dbusa_with_county') }}
    WHERE county IS NOT NULL AND state IS NOT NULL
)

SELECT cns.county AS name , s.id AS state_id ,
 ROW_NUMBER() OVER (ORDER BY cns.county) AS id
FROM counties_and_states AS cns
LEFT JOIN {{ ref("State") }} AS s
ON cns.state=s.name