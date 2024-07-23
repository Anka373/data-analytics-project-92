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


--6 шаг
select
    '16-25' as age_category,
    count(customer_id) as age_count
from customers
where age between 16 and 25
group by age_category
union 
select
    '26-40' as age_category,
    count(customer_id) as age_count
from customers
where age between 26 and 40
group by age_category
union 
select
    '40+' as age_category,
    count(customer_id) as age_count
from customers
where age > 40
group by age_category
order by age_category;
--вычисление кол-ва покупателей в возрастной группе, объединение данных из одной таблицы с помощью UNION


select 
    to_char(sale_date, 'yyyy-mm') as selling_month,
    count(distinct(customer_id)) as total_customer,
    floor(sum(quantity*price)) as income
from sales s
inner join products p on s.product_id = p.product_id 
group by selling_month
order by selling_month;
--подсчет уникальных покупателей и выручки в каждом месяце


with tab as(
select 
    distinct(concat(c.first_name, ' ', c.last_name)) as customer,
    first_value(sale_date) over(partition by c.customer_id) as sale_date,
    first_value((concat(e.first_name, ' ', e.last_name))) over(partition by c.customer_id order by sale_date) as seller,
    c.customer_id
from customers c 
inner join sales s on c.customer_id = s.customer_id 
inner join employees e on s.sales_person_id = e.employee_id
inner join products p on s.product_id = p.product_id 
where price = 0
group by customer, sale_date, c.customer_id, e.first_name, e.last_name
order by c.customer_id
)

select customer, sale_date, seller
from tab;
--нахождение покупателей, попавших в акцию, вспомогательный запрос необходим для сортировки по id покупателей, 
не входящего в итоговую таблицу, также необходимо определить самую первую покупку с помощью оконных функций
