--1. Выведите содержимое таблицы сотрудников двумя способами (2 балла)
select * from db_laba.dbo.employees;
-- перечисляя колонки
select employee_id, first_name, last_name, email, phone, hire_date, manager_id, job_title from db_laba.dbo.employees;
-- перечисляя  колонки - 2й способ с форматированием (использовал https://sqlformat.org/)
select employee_id,
       first_name,
       last_name,
       email,
       phone,
       hire_date,
       manager_id,
       job_title
from db_laba.dbo.employees;
-- перечисляя  колонки - 2й способ с форматированием (с алиасом)
select e.employee_id
       ,e.first_name
       ,e.last_name
       ,e.email
       ,e.phone
       ,e.hire_date
       ,e.manager_id
       ,e.job_title
from db_laba.dbo.employees e;


/*2. Выведите имя, фамилию и номер телефона таблицы контактов где номер телефона начинается на +1
   (прим.: для USA номер телефона начинается на +1) (3 балла)*/

 select c.first_name
	   ,c.last_name
	   ,c.phone
 from db_laba.dbo.contacts c
 where  c.phone like '+1%';

 /*3. Выведите уникальный список идентификаторов продавцов используя таблицу заказов и колонку salesman_id.
   Не включать пустые идентификаторы. Отсортировать по возрастанию (3 балла)*/

  select distinct o.salesman_id 
  from db_laba.dbo.orders o
  where o.salesman_id  is not NULL
  order by o.salesman_id asc;


  /*4. Выведите имя, фамилию, номер телефона и страну (новая колонка с именем country логика согласно номера телефона)
   из таблицы контактов
   - варианты колонки страны: USA или Other для всех других стран (примечание: необходимо использовать
     оператор CASE (для USA номер телефона начинается на +1)
   Результат отсортируйте по колонке страны, имени и фамилии (3 балла)*/

 select first_name,
	   last_name,
	   phone,
	   Case 
	   when phone like '+1%' then 'USA'
	   Else 'Other'
	   End as 'country'
 from db_laba.dbo.contacts
 order by country, first_name, last_name;

  /*5. Выведите имя продукта, описание и стандартную стоимость по продуктам
   со стандартной стоимостью НЕ в промежутке 500 до 4000
   Результат отсортировать по убыванию стандартной стоимости (3 балла)*/

 select p.product_name
	   ,p.description
	   ,p.standard_cost
 from db_laba.dbo.products p
 where p.standard_cost not between 500 and 4000
 order by p.standard_cost desc;

 /*6. Выведите имя продукта, описание и стандартную стоимость по продуктам
   со стандартной стоимостью в промежутке от 500 до 800  для 3-й категории
   Результат отсортируйте по убыванию стандартной стоимости (3 балла)*/

   
 select p.product_name
	   ,p.description
	   ,p.standard_cost
	   --,p.category_id - исп. для проверки наличия продуктов соответствующей категории
 from db_laba.dbo.products p
 where p.standard_cost  between 500 and 800
 --where p.category_id = 3 - исп. для проверки наличия продуктов соответствующей категории
 and p.category_id = 3
 --and p.category_id in (3) - второй вариант фильтра по категории
 order by p.standard_cost desc;

 --второй вариант проверки уникальных значений категорий
select 
distinct p.category_id
  from db_laba.dbo.products p;
 --результатом выполнения первого запроса будет пустая таблица, т.к. при проверке выяснилось, что в таблице отсутствуют продукты 3-ей категории

 /*7. Выведите имя продукта, описание и стандартную стоимость по продуктам со следующими фильтрами:
   - для продуктов имена которых НЕ начинаются на букву K (буква латинского алфавита, не чувствительна к регистру) 
   - кроме стоимости от 50 до 5000 (включительно)
   - для 1-й, 2-й, 3-й и 4-й категорий
   Результат отсортируйте по стандартной стоимости (3 балла)*/

 select p.product_name
	   ,p.description
	   ,p.standard_cost
	   --,p.category_id
 from db_laba.dbo.products p
 where p.product_name not like 'K%' 
 and (p.standard_cost <= 50 or p.standard_cost >= 5000) 
 and p.category_id in (1,2,3,4)
 order by p.standard_cost;

 
/*результатом выполнения  запроса будет пустая таблица, т.к. продуктов под выбранные фильтры в таблице продуктов не оказалось. 
Если убрать фильтр по категориям, то будет видно, что под первые два фильтра попадают продукты исключительно 5-ой категории. 
Продукты 3-ей категории вовсе нет в таблице продуктов (см.задание 6)*/
 