SELECT
    dbusa.property_id,
    states.name AS state,
    counties.name AS county,
    cities.name AS city,
    addresses.address AS address,
    zips.zip_code AS zip_code
FROM
    {{ ref("dbusa_property_after_processing") }} AS dbusa
LEFT JOIN
    {{ ref("State") }} AS states
        ON dbusa.state_id = states.id
LEFT JOIN
    {{ ref("County") }} AS counties
        ON dbusa.county_id = counties.id
LEFT JOIN
    {{ ref("City") }} AS cities
        ON dbusa.city_id = cities.id
LEFT JOIN
    {{ ref("zip_code") }} AS zips
        ON dbusa.zip_code_id = zips.id
LEFT JOIN
    {{ ref("Address") }} AS addresses
        ON dbusa.address_id = addresses.id