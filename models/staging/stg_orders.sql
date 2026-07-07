with source as (

    select * from {{ source('raw', 'orders') }}

),

renamed as (

    select
        order_id,
        customer_id,
        product_id,
        campaign_id,
        try_to_date(order_date, 'YYYY-MM-DD')  as order_date,
        lower(status)                          as status,
        try_to_number(quantity)                as quantity,
        try_to_decimal(unit_price, 10, 2)      as unit_price,
        try_to_decimal(discount, 5, 2)         as discount,
        shipping_country,
        round(
            try_to_number(quantity) * try_to_decimal(unit_price, 10, 2)
            * (1 - try_to_decimal(discount, 5, 2)), 2
        ) as net_amount

    from source
    where order_id is not null

)

select * from renamed