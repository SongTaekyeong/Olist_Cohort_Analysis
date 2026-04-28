-- 첫 구매월로부터 몇 개월 후에 재구매했는가?

with first_purchase_month as(
select 
       c.customer_unique_id,
       date_trunc(min(o.order_purchase_timestamp), month) as first_month,
from `olist.olist_orders_dataset` o
  inner join `olist.olist_customers_dataset` c on o.customer_id = c.customer_id
group by 1
),

purchase_month as(
select
       c.customer_unique_id,
       date_trunc(o.order_purchase_timestamp, month) as purchase_month
from `olist.olist_orders_dataset` o
  inner join `olist.olist_customers_dataset` c on o.customer_id = c.customer_id
-- group by 1
)


select
       f.customer_unique_id,
       date_diff(date(purchase_month), date(first_month), month) as repurchase_month
from first_purchase_month f
  inner join purchase_month p on f.customer_unique_id = p.customer_unique_id
order by 1 
