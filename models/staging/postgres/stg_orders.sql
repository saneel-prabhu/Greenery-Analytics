with promos as (
select * from {{ ref('stg_promos') }}
)

select 
    order_id,
    user_id,
    orders.promo_id,
    address_id,
    created_at,
    order_cost,
    promos.discount as promo_discount,
    shipping_cost,
    (order_cost - promos.discount - shipping_cost) as sales_total,
    order_total,
    tracking_id,
    shipping_service,
    estimated_delivery_at,
    delivered_at,
    status
from {{source('postgres', 'orders')}} as orders 
join promos using (promo_id)