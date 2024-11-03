WITH all_data_states AS(
    SELECT state
    FROM {{ source('main_Sources' , 'dbusa_property') }}
    UNION
    SELECT state
    FROM {{ source('main_Sources' , 'reonomy_property') }}
)

--- define city table with generated id
SELECT state AS name , md5(state) AS id
FROM all_data_states
WHERE state IS NOT NULL