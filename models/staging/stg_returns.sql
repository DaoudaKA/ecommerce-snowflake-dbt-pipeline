with source as (

    select * from {{ source('raw', 'returns') }}

),

renamed as (

    select
        return_id,
        order_id,
        try_to_date(return_date, 'YYYY-MM-DD') as return_date,
        reason,
        try_to_decimal(amount, 10, 2)          as amount

    from source
    where return_id is not null

)

select * from renamed