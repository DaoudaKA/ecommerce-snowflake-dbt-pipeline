with source as (

    select * from {{ source('raw', 'customers') }}

),

renamed as (

    select
        customer_id,
        initcap(first_name)                    as first_name,
        initcap(last_name)                     as last_name,
        lower(trim(email))                     as email,
        country,
        city,
        try_to_date(signup_date, 'YYYY-MM-DD') as signup_date,
        upper(segment)                         as segment

    from source
    where customer_id is not null

)

select * from renamed