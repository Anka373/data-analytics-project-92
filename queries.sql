--4 шаг
select count(customer_id) as customers_count
from customers;
--подсчитывает количество пользователей по полю id в таблице покупателей


--5 шаг
select
    concat(first_name, last_name) as seller,
    count(sales_person_id) as operations,
   floor(sum(quantity*price)) as income
from employees e 
inner join sales s on e.employee_id = s.sales_person_id
inner join products p on s.product_id = p.product_id
group by seller
order by income desc limit 10;
--считает кол-во операций каждого продавца и сумму выручки, сортирует от большего к меньшему, ограничивая кол-во строк 10, получает топ 10


select
    concat(first_name, last_name) as seller,
    floor(avg(quantity*price)) as average_income
  from employees e 
  inner join sales s on e.employee_id = s.sales_person_id
  inner join products p on s.product_id = p.product_id
  group by seller
  having avg(quantity*price) <
  (select avg(quantity*price) from sales s 
  inner join products p on s.product_id = p.product_id)
 order by average_income;
--вычисляет среднюю выручку каждого продавца и сравнивает через оператор HAVING с общей средней выручкой


with tab as(
select
    concat(first_name, last_name) as seller,
    to_char(sale_date, 'day') as day_of_week,
    floor(sum(quantity*price)) as income,
    extract (isodow from s.sale_date) as number_of_week
from employees e
inner join sales s on e.employee_id = s.sales_person_id
inner join products p on s.product_id = p.product_id 
group by seller, day_of_week, number_of_week
order by number_of_week, seller
)

select seller, day_of_week, income
 from tab;
--создается вспомогательный запрос для правильной сортировки по дням недели, подсчитывается прибыль
