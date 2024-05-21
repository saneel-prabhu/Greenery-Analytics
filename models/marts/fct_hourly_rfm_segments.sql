with orders as (
select 
    user_id, 
    created_at as ordered_at,
    order_id,
    order_total,
    total_products_ordered
from {{ ref('fct_orders') }}
), 

hours AS(
    SELECT date_hour, date_day
    FROM {{ ref('int_date_spine') }}
    WHERE 1=1 
        AND date_hour >= '2021-02-10 00:00:00.000'
        AND date_hour <= '2021-02-11 23:00:00.000'
),

orders_with_hours as (
    select 
        user_id, 
        date_hour,
        ordered_at,
        order_id,
        order_total,
        total_products_ordered
    from hours 
        join orders on orders.ordered_at <= hours.date_hour
), 

rfm_values AS (
    SELECT  
        user_id,
        date_hour,
        MAX(ordered_at) AS max_payment_date,
        timestampdiff(minute, MAX(ordered_at), date_hour) as recency,
        COUNT(DISTINCT order_id) AS frequency,
        SUM(order_total) AS monetary
    FROM orders_with_hours
    GROUP BY user_id, date_hour
), 

rfm_percentiles AS (
SELECT  user_id,
        date_hour,
        recency,
        frequency,
        monetary,
        PERCENT_RANK() OVER (PARTITION BY DATE_HOUR ORDER BY recency DESC) AS recency_percentile,
        PERCENT_RANK() OVER (PARTITION BY DATE_HOUR ORDER BY frequency ASC) AS frequency_percentile,
        PERCENT_RANK() OVER (PARTITION BY DATE_HOUR ORDER BY monetary ASC) AS monetary_percentile
FROM rfm_values
), 

rfm_scores AS(
    SELECT  *,
            CASE
                WHEN recency_percentile >= 0.8 THEN 5
                WHEN recency_percentile >= 0.6 THEN 4
                WHEN recency_percentile >= 0.4 THEN 3
                WHEN recency_percentile >= 0.2 THEN 2
                ELSE 1
                END AS recency_score,
            CASE
                WHEN frequency_percentile >= 0.8 THEN 5
                WHEN frequency_percentile >= 0.6 THEN 4
                WHEN frequency_percentile >= 0.4 THEN 3
                WHEN frequency_percentile >= 0.2 THEN 2
                ELSE 1
                END AS frequency_score,
            CASE
                WHEN monetary_percentile >= 0.8 THEN 5
                WHEN monetary_percentile >= 0.6 THEN 4
                WHEN monetary_percentile >= 0.4 THEN 3
                WHEN monetary_percentile >= 0.2 THEN 2
                ELSE 1
                END AS monetary_score
    FROM rfm_percentiles
), 

rfm_segment AS(
SELECT *,
        CASE
            WHEN recency_score <= 2
                AND frequency_score <= 2 THEN 'Hibernating'
            WHEN recency_score <= 2
                AND frequency_score <= 4 THEN 'At Risk'
            WHEN recency_score <= 2
                AND frequency_score <= 5 THEN 'Cannot Lose Them'
            WHEN recency_score <= 3
                AND frequency_score <= 2 THEN 'About to Sleep'
            WHEN recency_score <= 3
                AND frequency_score <= 3 THEN 'Need Attention'
            WHEN recency_score <= 4
                AND frequency_score <= 1 THEN 'Promising'
            WHEN recency_score <= 4
                AND frequency_score <= 3 THEN 'Potential Loyalists'
            WHEN recency_score <= 4
                AND frequency_score <= 5 THEN 'Loyal Customers'
            WHEN recency_score <= 5
                AND frequency_score <= 1 THEN 'New Customers'
            WHEN recency_score <= 5
                AND frequency_score <= 3 THEN 'Potential Loyalists'
            ELSE 'Champions'
        END AS rfm_segment
FROM  rfm_scores
) 

select * 
from rfm_segment 
order by date_hour, recency
