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
    ifnull(promos.discount, 0) as promo_discount,
    shipping_cost,
    (order_cost - ifnull(promos.discount, 0) - shipping_cost) as sales_total,
    order_total,
    tracking_id,
    shipping_service,
    estimated_delivery_at,
    delivered_at,
    status
from {{source('postgres', 'orders')}} as orders 
left join promos using (promo_id)