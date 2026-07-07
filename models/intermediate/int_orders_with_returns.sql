with orders as (

    select * from {{ ref('int_orders_enriched') }}

),

returns as (

    select * from {{ ref('stg_returns') }}

),

final as (

    select
        orders.*,
        returns.return_id,
        returns.return_date,
        returns.reason           as return_reason,
        returns.amount           as return_amount,
        (returns.return_id is not null) as is_returned

    from orders
    left join returns on orders.order_id = returns.order_id

)

select * from final