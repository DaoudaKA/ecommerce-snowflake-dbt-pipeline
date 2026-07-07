with source as (

    select * from {{ source('raw', 'events') }}

),

renamed as (

    select
        event_id,
        session_id,
        customer_id,
        event_type,
        page,
        device,
        country,
        try_to_timestamp(event_timestamp, 'YYYY-MM-DD HH24:MI:SS') as event_timestamp,
        properties

    from source
    where event_id is not null

)

select * from renamed