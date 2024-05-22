WITH rfm_segments AS (
    SELECT *
    FROM {{ ref ('fct_hourly_rfm_segments') }}
),  
current_segments AS (
    SELECT *
    FROM rfm_segments
    WHERE date_hour = (SELECT MAX(date_hour) FROM rfm_segments)
)
select * exclude(date_hour)
from current_segments
order by 2
