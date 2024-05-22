with users as (
    select * from {{ ref('stg_users') }}
),

addresses as (
    select * from {{ ref('stg_addresses') }}
), 

user_orders as (
    select * from {{ ref('int_user_orders') }}
)

select 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.created_at,
    u.updated_at,
    u.address_id, 
    a.address, 
    a.country,
    a.state, 
    a.zipcode,
    uo.total_orders,
    uo.total_spend,
    uo.average_order_size,
    uo.first_order_at,
    uo.last_order_at,
    uo.most_ordered_product    
from users as u  
left join addresses as a using (address_id)
left join user_orders as uo using (user_id)