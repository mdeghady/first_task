SELECT
    reonomy.property_id,
    states.name AS state,
    counties.name AS county,
    cities.name AS city,
    addresses.address AS address,
    zips.zip_code AS zip_code
FROM
    {{ ref("reonomy_after_processing") }} AS reonomy
LEFT JOIN
    {{ ref("State") }} AS states
        ON reonomy.state_id = states.id
LEFT JOIN
    {{ ref("County") }} AS counties
        ON reonomy.county_id = counties.id
LEFT JOIN
    {{ ref("City") }} AS cities
        ON reonomy.city_id = cities.id
LEFT JOIN
    {{ ref("zip_code") }} AS zips
        ON reonomy.zip_code_id = zips.id
LEFT JOIN
    {{ ref("Address") }} AS addresses
        ON reonomy.address_id = addresses.id