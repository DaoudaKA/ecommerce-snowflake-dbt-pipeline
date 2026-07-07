with source as (

    select * from {{ source('raw', 'campaigns') }}

),

renamed as (

    select
        campaign_id,
        name,
        channel,
        try_to_decimal(budget, 10, 2)          as budget,
        try_to_date(start_date, 'YYYY-MM-DD')  as start_date,
        try_to_date(end_date, 'YYYY-MM-DD')    as end_date,
        target_segment

    from source
    where campaign_id is not null

)

select * from renamed