

--고객별 첫 구매월 추출

select 
       c.customer_unique_id,
       date_trunc(min(o.order_purchase_timestamp), month) as first_month,
from `olist.olist_orders_dataset` o
  inner join `olist.olist_customers_dataset` c on o.customer_id = c.customer_id
group by 1