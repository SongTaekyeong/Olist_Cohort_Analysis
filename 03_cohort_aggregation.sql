

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
)


select      
       f.first_month,
       date_diff(purchase_month, first_month, month) as repurchase_month,
       count(f.customer_unique_id) as customer_count
from first_purchase_month f
  inner join purchase_month p on f.customer_unique_id = p.customer_unique_id
group by 1,2
order by 1,2