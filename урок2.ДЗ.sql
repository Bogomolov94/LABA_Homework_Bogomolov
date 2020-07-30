--1. �������� ���������� ������� ����������� ����� ��������� (2 �����)
select * from db_laba.dbo.employees;
-- ���������� �������
select employee_id, first_name, last_name, email, phone, hire_date, manager_id, job_title from db_laba.dbo.employees;
-- ����������  ������� - 2� ������ � ��������������� (����������� https://sqlformat.org/)
select employee_id,
       first_name,
       last_name,
       email,
       phone,
       hire_date,
       manager_id,
       job_title
from db_laba.dbo.employees;
-- ����������  ������� - 2� ������ � ��������������� (� �������)
select e.employee_id
       ,e.first_name
       ,e.last_name
       ,e.email
       ,e.phone
       ,e.hire_date
       ,e.manager_id
       ,e.job_title
from db_laba.dbo.employees e;


/*2. �������� ���, ������� � ����� �������� ������� ��������� ��� ����� �������� ���������� �� +1
   (����.: ��� USA ����� �������� ���������� �� +1) (3 �����)*/

 select c.first_name
	   ,c.last_name
	   ,c.phone
 from db_laba.dbo.contacts c
 where  c.phone like '+1%';

 /*3. �������� ���������� ������ ��������������� ��������� ��������� ������� ������� � ������� salesman_id.
   �� �������� ������ ��������������. ������������� �� ����������� (3 �����)*/

  select distinct o.salesman_id 
  from db_laba.dbo.orders o
  where o.salesman_id  is not NULL
  order by o.salesman_id asc;


  /*4. �������� ���, �������, ����� �������� � ������ (����� ������� � ������ country ������ �������� ������ ��������)
   �� ������� ���������
   - �������� ������� ������: USA ��� Other ��� ���� ������ ����� (����������: ���������� ������������
     �������� CASE (��� USA ����� �������� ���������� �� +1)
   ��������� ������������ �� ������� ������, ����� � ������� (3 �����)*/

 select first_name,
	   last_name,
	   phone,
	   Case 
	   when phone like '+1%' then 'USA'
	   Else 'Other'
	   End as 'country'
 from db_laba.dbo.contacts
 order by country, first_name, last_name;

 �/*5. �������� ��� ��������, �������� � ����������� ��������� �� ���������
   �� ����������� ���������� �� � ���������� 500 �� 4000
   ��������� ������������� �� �������� ����������� ��������� (3 �����)*/

 select p.product_name
	   ,p.description
	   ,p.standard_cost
 from db_laba.dbo.products p
 where p.standard_cost not between 500 and 4000
 order by p.standard_cost desc;

 /*6. �������� ��� ��������, �������� � ����������� ��������� �� ���������
   �� ����������� ���������� � ���������� �� 500 �� 800  ��� 3-� ���������
   ��������� ������������ �� �������� ����������� ��������� (3 �����)*/

   
 select p.product_name
	   ,p.description
	   ,p.standard_cost
	   --,p.category_id - ���. ��� �������� ������� ��������� ��������������� ���������
 from db_laba.dbo.products p
 where p.standard_cost  between 500 and 800
 --where p.category_id = 3 - ���. ��� �������� ������� ��������� ��������������� ���������
 and p.category_id = 3
 --and p.category_id in (3) - ������ ������� ������� �� ���������
 order by p.standard_cost desc;

 --������ ������� �������� ���������� �������� ���������
select 
distinct p.category_id
  from db_laba.dbo.products p;
 --����������� ���������� ������� ������� ����� ������ �������, �.�. ��� �������� ����������, ��� � ������� ����������� �������� 3-�� ���������

 /*7. �������� ��� ��������, �������� � ����������� ��������� �� ��������� �� ���������� ���������:
   - ��� ��������� ����� ������� �� ���������� �� ����� K (����� ���������� ��������, �� ������������� � ��������) 
   - ����� ��������� �� 50 �� 5000 (������������)
   - ��� 1-�, 2-�, 3-� � 4-� ���������
   ��������� ������������ �� ����������� ��������� (3 �����)*/

 select p.product_name
	   ,p.description
	   ,p.standard_cost
	   --,p.category_id
 from db_laba.dbo.products p
 where p.product_name not like 'K%' 
 and (p.standard_cost <= 50 or p.standard_cost >= 5000) 
 and p.category_id in (1,2,3,4)
 order by p.standard_cost;

 
/*����������� ����������  ������� ����� ������ �������, �.�. ��������� ��� ��������� ������� � ������� ��������� �� ���������. 
���� ������ ������ �� ����������, �� ����� �����, ��� ��� ������ ��� ������� �������� �������� ������������� 5-�� ���������. 
�������� 3-�� ��������� ����� ��� � ������� ��������� (��.������� 6)*/
 