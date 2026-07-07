with source as (

    select * from {{ source('raw', 'products') }}

),

renamed as (

    select
        product_id,
        name,
        category,
        brand,
        try_to_decimal(unit_price, 10, 2) as unit_price,
        try_to_decimal(cost, 10, 2)       as cost,
        (is_active = 'true')              as is_active

    from source
    where product_id is not null

)

select * from renamed