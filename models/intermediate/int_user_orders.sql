with user_orders as (
    select 
        user_id, 
        count(distinct order_id) as total_orders,
        sum(sales_total) as total_sales,
        round(total_sales / total_orders, 2) as average_order_size, 
        min(created_at) as first_order_at,
        max(created_at) as last_order_at
    from {{ ref('stg_orders') }}
    group by 1
    order by 2 desc 
), 

user_products as (
    select 
        user_id, 
        product_id, 
        sum(quantity) as total_quantity, 
        sum(quantity * price) as sales_volume
    from {{ ref('stg_orders') }} as o 
    join {{ ref('stg_order_items') }} using (order_id)
    join {{ ref('stg_products') }} using (product_id)
    group by 1,2
    order by 1, 3 desc
), 

most_ordered_product as (
    select 
        *, 
        row_number () over (partition by user_id order by total_quantity desc, sales_volume desc) as product_rank
    from user_products 
    qualify product_rank = 1 
    order by user_id, product_rank 
) 

select 
    uo.user_id, 
    uo.total_orders,
    uo.total_sales,
    uo.average_order_size, 
    uo.first_order_at,
    uo.last_order_at,
    p.name as most_ordered_product    
from user_orders as uo 
join most_ordered_product using (user_id)
join {{ ref('stg_products') }} as p using (product_id)