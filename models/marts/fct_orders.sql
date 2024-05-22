with orders as (
select * from {{ ref('stg_orders') }}
), 

addresses as (
select * from {{ ref('stg_addresses') }}
), 

promos as (
select * from {{ ref('stg_promos') }}
),

total_order_items as (
select 
    order_id,
    sum(quantity) as total_products_ordered
from {{ ref('stg_order_items') }}
group by 1 
)

select 
    o.order_id,
    o.user_id,
    o.address_id,
    a.country,
    a.state, 
    a.zipcode,
    o.created_at,
    o.promo_id,
    o.order_cost,
    p.discount as promo_discount,
    o.shipping_cost,
    (o.order_cost - p.discount - o.shipping_cost) as sales_total,
    o.order_total,
    o.tracking_id,
    o.shipping_service,
    o.estimated_delivery_at,
    o.delivered_at,
    o.status,
    toi.total_products_ordered
from orders as o 
left join addresses as a 
    on a.address_id = o.address_id
left join promos as p 
    on p.promo_id = o.promo_id 
left join total_order_items as toi 
    on toi.order_id = o.order_id 
