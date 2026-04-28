
with first_purchase_month as(
select 
       c.customer_unique_id,
       date_trunc(min(date(o.order_purchase_timestamp)), month) as first_month
from `olist.olist_orders_dataset` o
  inner join `olist.olist_customers_dataset` c on o.customer_id = c.customer_id
group by 1
),

purchase_month as(
select
       c.customer_unique_id,
       date_trunc(date(o.order_purchase_timestamp), month) as purchase_month
from `olist.olist_orders_dataset` o
  inner join `olist.olist_customers_dataset` c on o.customer_id = c.customer_id
-- group by 1
),

cohort_base as(
select      
       f.first_month,
       date_diff(purchase_month, first_month, month) as repurchase_month,
       count(f.customer_unique_id) as customer_count
from first_purchase_month f
  inner join purchase_month p on f.customer_unique_id = p.customer_unique_id
group by 1,2
order by 1,2
)

select
    first_month,
    repurchase_month,
    customer_count,
    first_value(customer_count) over (
        partition by first_month
        order by repurchase_month
    ) AS cohort_size,
    round(customer_count * 1.0 / first_value(customer_count) over (
        partition by first_month
        order by repurchase_month
    ), 2) AS retention_rate
FROM cohort_base
order by 1, 2


