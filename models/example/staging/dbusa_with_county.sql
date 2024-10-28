--- add county to dbusa_propery source
SELECT dbusa.* , LOWER(uszips.county) AS county
FROM {{ source('main_Sources' , 'dbusa_property') }} AS dbusa
LEFT JOIN {{ ref('uszips') }} AS uszips
ON dbusa.zip_code = uszips.zip