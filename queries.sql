--4 шаг
select count(customer_id) as customers_count
from customers;
--подсчитывает количество пользователей по полю id в таблице покупателей


--5 шаг
select
    concat(e.first_name, ' ', e.last_name) as seller,
    count(s.sales_person_id) as operations,
    floor(sum(s.quantity * p.price)) as income
from sales as s
inner join employees as e on s.sales_person_id = e.employee_id
inner join products as p on s.product_id = p.product_id
group by seller
order by income desc limit 10;
/*считает кол-во операций каждого продавца и сумму
выручки, сортирует от большего к меньшему,
ограничивая кол-во строк 10, получает топ 10*/


select
    concat(e.first_name, ' ', e.last_name) as seller,
    floor(avg(s.quantity * p.price)) as average_income
from sales as s
inner join employees as e on s.sales_person_id = e.employee_id
inner join products as p on s.product_id = p.product_id
group by seller
having
    avg(s.quantity * p.price)
    < (
        select avg(s.quantity * p.price) from sales as s
        inner join products as p on s.product_id = p.product_id
    )
order by average_income;
/*вычисляет среднюю выручку каждого продавца и сравнивает
через оператор HAVING с общей средней выручкой*/


select
    concat(e.first_name, ' ', e.last_name) as seller,
    to_char(s.sale_date, 'day') as day_of_week,
    floor(sum(s.quantity * p.price)) as income
from employees as e
inner join sales as s on e.employee_id = s.sales_person_id
inner join products as p on s.product_id = p.product_id
group by seller, day_of_week, extract(isodow from s.sale_date)
order by extract(isodow from s.sale_date), seller;
/*находит день недели и выручку по нему на каждого продавца*/


--6 шаг
select
    case
        when age between 16 and 25 then '16-25'
        when age between 26 and 40 then '26-40'
        when age > 40 then '40+'
    end as age_category,
    count(customer_id) as age_count
from customers
group by age_category
order by age_category;
/*вычисление кол-ва покупателей в возрастной группе
с помощью оператора CASE*/


select
    to_char(s.sale_date, 'yyyy-mm') as selling_month,
    count(distinct s.customer_id) as total_customer,
    floor(sum(s.quantity * p.price)) as income
from sales as s
inner join products as p on s.product_id = p.product_id
group by selling_month
order by selling_month;
--подсчет уникальных покупателей и выручки в каждом месяце


select distinct on
(concat(c.first_name, ' ', c.last_name))
    s.sale_date,
    concat(c.first_name, ' ', c.last_name)
    as customer,
    concat(e.first_name, ' ', e.last_name) as seller
from customers as c
inner join sales as s on c.customer_id = s.customer_id
inner join employees as e on s.sales_person_id = e.employee_id
inner join products as p on s.product_id = p.product_id
where p.price = 0
order by customer, s.sale_date
/*нахождение первых покупок покупателей в ходе акции*/
