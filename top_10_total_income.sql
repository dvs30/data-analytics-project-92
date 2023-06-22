select 
  concat(e.first_name, ' ',e.last_name) as name,
  count(s.sales_person_id) as operations,
  sum(p.price * s.quantity) as income
  /*p.price * s.quantity as income*/
from sales s
  inner join employees e 
  on e.employee_id = s.sales_person_id
  inner join products p 
  on p.product_id = s.product_id
group by concat(e.first_name, ' ',e.last_name)
order by income desc
limit 10;