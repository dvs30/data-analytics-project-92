with total_avg as (
select 
  concat(e.first_name, ' ',e.last_name) as name,
  round(avg(p.price * s.quantity), 0)  as average_income
from sales s
  inner join employees e 
  on e.employee_id = s.sales_person_id
  inner join products p 
  on p.product_id = s.product_id
group by concat(e.first_name, ' ',e.last_name)
), average as (
select
	avg(average_income) as average
from total_avg
)
select
	total_avg.name,
	total_avg.average_income
from total_avg
	cross join average
where total_avg.average_income > average.average
order by total_avg.average_income desc;