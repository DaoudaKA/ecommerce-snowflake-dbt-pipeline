with orders as (

    select * from {{ ref('stg_orders') }}

),

customers as (

    select * from {{ ref('stg_customers') }}

),

products as (

    select * from {{ ref('stg_products') }}

),

campaigns as (

    select * from {{ ref('stg_campaigns') }}

),

final as (

    select
        orders.order_id,
        orders.order_date,
        orders.status,
        orders.quantity,
        orders.unit_price,
        orders.discount,
        orders.net_amount,
        orders.shipping_country,

        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customers.segment           as customer_segment,
        customers.country           as customer_country,

        products.product_id,
        products.name               as product_name,
        products.category           as product_category,
        products.brand              as product_brand,
        products.cost               as product_cost,

        campaigns.campaign_id,
        campaigns.name              as campaign_name,
        campaigns.channel           as campaign_channel

    from orders
    left join customers on orders.customer_id = customers.customer_id
    left join products  on orders.product_id  = products.product_id
    left join campaigns on orders.campaign_id = campaigns.campaign_id

)

select * from final