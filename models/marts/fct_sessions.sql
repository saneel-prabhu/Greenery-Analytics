with session_timings as (
    select 
        session_id,
        user_id,
        min(created_at) as session_started_at,
        max(created_at) as session_ended_at, 
        count(distinct event_id) as event_count,
        count(distinct case when event_type = 'checkout' then 1 else null end) as has_conversion,
        count(distinct product_id) as products_per_session,
        count(distinct page_url) as pages_per_session
    from {{ ref('stg_events') }}
    group by 1,2
)

select 
    session_id,
    user_id,
    session_started_at,
    session_ended_at, 
    timestampdiff(min, session_started_at, session_ended_at) as session_duration,
    event_count,
    iff(event_count = 1, true, false) as is_bounced, 
    has_conversion,
    products_per_session,
    pages_per_session
from session_timings
