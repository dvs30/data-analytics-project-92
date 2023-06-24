select 
	TO_CHAR(s.sale_date, 'YYYY-MM') as date,
	count(s.customer_id) as total_customers,
	sum(p.price * s.quantity) as income
from sales s
	inner join products p 
	on p.product_id = s.product_id
group by TO_CHAR(s.sale_date, 'YYYY-MM')
order by TO_CHAR(s.sale_date, 'YYYY-MM');

/*Во втором отчете предоставьте данные по количеству уникальных покупателей и выручке,
 которую они принесли. Сгруппируйте данные по дате, 
 которая представлена в числовом виде ГОД-МЕСЯЦ*/