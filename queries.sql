/*Задание 4. Ниже представлен запрос, который считает общее количество покупателей.*/
select
	COUNT(customer_id) as customers_count
from customers;

/*Задание 5.1 Первый отчет о десятке лучших продавцов. 
Таблица состоит из трех колонок - данных о продавце, 
суммарной выручке с проданных товаров и количестве проведенных сделок, 
и отсортирована по убыванию выручки*/
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

/*Задание 5.2 Второй отчет содержит информацию о продавцах, 
чья средняя выручка за сделку меньше средней выручки за сделку по всем продавцам. 
Таблица отсортирована по выручке по возрастанию*/
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
where total_avg.average_income < average.average
order by total_avg.average_income;

/*Задание 5.3 Третий отчет содержит информацию о выручке по дням недели. 
Каждая запись содержит имя и фамилию продавца, день недели и суммарную выручку*/
with total_result as(
select
	concat(e.first_name, ' ',e.last_name) as name,
	TO_CHAR(s.sale_date, 'ID-day') as weekday,
	round(sum(p.price * s.quantity),0) as income
from sales s
	inner join employees e 
 	on e.employee_id = s.sales_person_id
 	inner join products p 
 	on p.product_id = s.product_id
group by concat(e.first_name, ' ',e.last_name), TO_CHAR(s.sale_date, 'ID-day')
order by TO_CHAR(s.sale_date, 'ID-day'), concat(e.first_name, ' ',e.last_name)
)
select 
	total_result.name,
	SPLIT_PART(total_result.weekday, '-', 2) as weekday,
	total_result.income
from total_result;

/*Задание 6.1 Первый отчет - количество покупателей в разных возрастных группах: 16-25, 26-40 и 40+.*/
select 
case
	when c.age >= 16 and c.age <= 25 then '16-25'
	when c.age >= 26 and c.age <= 40 then '26-40'
	when c.age > 40 then '40+'
end as age_category,
count(c.age) as count
from customers c
group by age_category
order by age_category;

/*Задание 6.2 Во втором отчете предоставьте данные по количеству уникальных покупателей и выручке, 
которую они принесли. Сгруппируйте данные по дате, которая представлена в числовом виде ГОД-МЕСЯЦ. 
Итоговая таблица должна быть отсортирована по дате по возрастанию.*/
select 
	TO_CHAR(s.sale_date, 'YYYY-MM') as date,
	count(distinct s.customer_id) as total_customers,
	sum(p.price * s.quantity) as income
from sales s
	inner join products p 
	on p.product_id = s.product_id
group by TO_CHAR(s.sale_date, 'YYYY-MM')
order by TO_CHAR(s.sale_date, 'YYYY-MM');

/*Задание 6.3 Третий отчет следует составить о покупателях, первая покупка 
которых была в ходе проведения акций (акционные товары отпускали со стоимостью равной 0). 
Итоговая таблица должна быть отсортирована по id покупателя.*/
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
order by final_report.customer;