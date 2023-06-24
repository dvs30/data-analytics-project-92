create temporary table temp_customers
(
age_category VARCHAR(80),
count INTEGER default 0
)
on commit delete rows;

with first_report as(
select 
	'16-25' as age_category,
	count(age) as count
from customers
where age >= 16 and age <= 25
)
insert into temp_customers select * from first_report;

with second_report as(
select 
	'26-40' as age_category,
	count(age) as count
from customers
where age >= 26 and age <= 40
)
insert into temp_customers select * from second_report;

with third_report as(
select 
	'40+' as age_category,
	count(age) as count
from customers
where age >= 40
)
insert into temp_customers select * from third_report;

select age_category, count
from temp_customers;

/*Первый отчет - количество покупателей в разных возрастных группах: 16-25, 26-40 и 40+.*/