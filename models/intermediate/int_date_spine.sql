with date_spine as (
SELECT  '2021-02-01 00:00:00.000'::timestamp AS date_hour UNION ALL 
SELECT TIMESTAMPADD('hour', 1, date_hour) FROM date_spine
WHERE date_hour < '2021-02-28 23:00:00.000'
)

SELECT  date_hour, 
        date_trunc('day', date_hour) AS date_day 
FROM date_spine
ORDER BY 1 
