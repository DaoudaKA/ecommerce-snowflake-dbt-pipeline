with orders as (

    select * from {{ ref('int_orders_with_returns') }}

)

select
    order_id,
    order_date,
    status,
    customer_id,
    customer_segment,
    customer_country,
    product_id,
    product_name,
    product_category,
    product_brand,
    campaign_id,
    campaign_name,
    campaign_channel,
    quantity,
    unit_price,
    discount,
    net_amount,
    shipping_country,
    is_returned,
    return_reason,
    return_amount

from orders