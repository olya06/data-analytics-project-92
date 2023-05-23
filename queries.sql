select count(*) as customers_count from customers c;

select concat (e.first_name, ' ', e.last_name) as name, count(s.sales_person_id) as operations, sum(s.quantity*p.price) as income from employees e
left join sales s
on e.employee_id = s.sales_person_id
left join products p
on p.product_id = s.product_id
group by 1
order by income desc nulls last
limit 10
;

with average_employee_sales as (
select concat (e.first_name, ' ', e.last_name) as name, round(avg(s.quantity*p.price), 0) as average_income from employees e
left join sales s
on e.employee_id = s.sales_person_id
left join products p
on p.product_id = s.product_id
group by 1
)
select name, average_income from average_employee_sales
where average_income <
(select round(avg(s.quantity*p.price), 0) as average_sale from employees e
left join sales s
on e.employee_id = s.sales_person_id
left join products p
on p.product_id = s.product_id)
order by average_income
;

with sales_dates as (
select concat (e.first_name, ' ', e.last_name) as name,
extract(ISODOW from s.sale_date) as day_week,
to_char(s.sale_date, 'Day') as weekday,
round(sum(s.quantity*p.price)) as income
from employees e
left join sales s
on e.employee_id = s.sales_person_id
left join products p
on p.product_id = s.product_id
group by 1, 2, 3
order by 2
)
select name, weekday, income from sales_dates
; 
