with zero_p as(
select * from products
where price = 0
), zero_ss as(
select
	sales.customer_id,
	sales.sale_date,
	sales.sales_person_id
from sales
	inner join zero_p
	on zero_p.product_id = sales.product_id
	order by sales.sale_date
), zero_s as(
	select 
	distinct on (zero_ss.customer_id) customer_id,
	zero_ss.sale_date,
	zero_ss.sales_person_id
	from zero_ss
	order by zero_ss.customer_id, zero_ss.sale_date, zero_ss.sales_person_id
), final_report as(
select 
	concat(c.first_name, ' ',c.last_name) as customer,
	zero_s.sale_date,
	concat(e.first_name, ' ',e.last_name) as seller
from zero_s
	inner join customers c
	on c.customer_id = zero_s.customer_id
	inner join employees e
	on e.employee_id = zero_s.sales_person_id
)
select 
	final_report.customer,
	final_report.sale_date,
	final_report.seller
from final_report
order by final_report.sale_date;