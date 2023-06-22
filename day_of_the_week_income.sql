select
	concat(e.first_name, ' ',e.last_name) as name,
	sum(p.price * s.quantity) as income,
	TO_CHAR(s.sale_date, 'day')
from sales s
	inner join employees e 
 	on e.employee_id = s.sales_person_id
 	inner join products p 
 	on p.product_id = s.product_id
 group by concat(e.first_name, ' ',e.last_name), TO_CHAR(s.sale_date, 'day')
order by TO_CHAR(s.sale_date, 'day');