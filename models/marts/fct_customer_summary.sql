with orders as (

    select * from {{ ref('int_orders_with_returns') }}
    where status = 'completed'

),

customer_agg as (

    select
        customer_id,
        customer_segment,
        customer_country,

        count(distinct order_id)              as nb_orders,
        sum(net_amount)                       as total_spent,
        avg(net_amount)                       as avg_order_value,
        sum(case when is_returned then 1 else 0 end) as nb_returns,
        min(order_date)                       as first_order_date,
        max(order_date)                       as last_order_date

    from orders
    group by customer_id, customer_segment, customer_country

),

final as (

    select
        *,
        round(nb_returns / nullif(nb_orders, 0) * 100, 1) as return_rate_pct

    from customer_agg

)

select * from final