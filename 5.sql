/* 1. �������� ��� ������ ��� ���������, ������� ���� ������ �� ������ � ������ �������� 2016 ����
�������� ������� � ������������ �� ���� ���������� (4 �����)*/

SELECT *
FROM db_laba.dbo.orders ord
WHERE ord.salesman_id in -- IN, �.�. ����� ��������
    (SELECT emp.employee_id
     FROM db_laba.dbo.employees emp
     WHERE emp.hire_date BETWEEN '2016-01-01' AND '2016-03-31')
	 ORDER BY 4,3,5;
	
	/*
	SELECT * --emp.manager_id
	FROM db_laba.dbo.employees emp
	WHERE emp.hire_date BETWEEN '2016-01-01' and '2016-03-31'
	AND emp.job_title like 'Sales%'   -- ����� � �������� ����� �������� ���� ������ � 1-�� ��������

	SELECT *
	FROM db_laba.dbo.orders ord
	WHERE ord.salesman_id in (47,48,50,51,52,54,57,58,60,64,65,66,67,69,70,71,72,73,76,77,80)  -- ����� � �������� ������ �� ��������� ���� ���������. ����� ��� ��� �����, ��� �� �� ���� ���� ������.
	*/ 


/*2. �������� ID � ������ ������, ��� �������� � ��� �������
��� ���� �������, ������� ������ ����� ������ �������� 2016 ���� (������ ������ ����� ������ � �������� �����������)
������������ �� ���� ���������� (5 ������)*/

 SELECT
	ord.order_id ord_id,
	ord.status ord_status ,
	emp.first_name sales_name,
	emp.phone sales_phone
FROM
	db_laba.dbo.orders ord
LEFT JOIN db_laba.dbo.employees emp ON
	ord.salesman_id = emp.employee_id
WHERE   -- ������ ��� ���� �������� ID ������� �������� 2016 ����
	ord.salesman_id = (
	SELECT
		top1.salesman_id
	FROM
		(
		SELECT
			TOP (1) 
			ord.salesman_id , SUM(oi.quantity*oi.unit_price) order_sum
		FROM
			db_laba.dbo.order_items oi
		JOIN db_laba.dbo.orders ord ON
			ord.order_id = oi.order_id
		WHERE
			ord.salesman_id IS NOT NULL -- �� �� ���� ������� ���� ��������. � ��� ���� ���!
			AND ord.order_date BETWEEN '2016-01-01' AND '2016-12-31'
		GROUP BY
			ord.salesman_id
		ORDER BY
			order_sum DESC) top1)
ORDER BY
	1;

	
	/*
	��������
	SELECT  
	TOP (1) SUM(oi.quantity*oi.unit_price) order_sum,
	oi.order_id
			FROM db_laba.dbo.order_items oi
			WHERE oi.order_id in
    (SELECT ord.order_id
     FROM db_laba.dbo.orders ord
     WHERE ord.order_date BETWEEN '2016-01-01' AND '2016-12-31'
	and ord.salesman_id IS NOT NULL) -- ��� ������ ��������
	 GROUP BY oi.order_id
	 ORDER BY
	order_sum DESC;
	
	
	�������� 1
	select *
	FROM db_laba.dbo.orders ord
	WHERE ord.order_id = 68   -- ����� �����, ��� ������ ����� � ���� ������� ��� ��������
	
	�������� 2
	select *
	FROM db_laba.dbo.orders ord
	WHERE ord.order_id = 39   -- ����� �������� salesman_id. �����, ��� ���������� ���. �.�. �� ����� ����� ������ ���� �������� ������. ��� ����� ��� ���������� = ��� In � ������� �������.

	select *
	FROM db_laba.dbo.employees emp
	WHERE emp.employee_id = 62  -- ������� Freya = ��, ��� ����� ���������
	*/



	/*3. �������� ID ������, ��� � ������� �������� ����� ��������,  ������� ��������, � ����� �������� ���������
��� ���� �������, ������� ������ ����� ������ �������� 2015 ���� (������ ������ ����� ������ � �������������� �����������)
��� ���� ������������ �������
������������ �� ���� ���������� (5 ������) */

SELECT
	ord.order_id ord_id,
	emp.first_name + ' ' + emp.last_name as sales_name,
	emp.phone sales_phone,
	cust.name cust_name
FROM
	db_laba.dbo.orders ord
LEFT JOIN db_laba.dbo.employees emp ON
ord.salesman_id = emp.employee_id
JOIN db_laba.dbo.customers cust ON
ord.customer_id = cust.customer_id
	WHERE   -- ������ ��� ���� �������� ID ������� �������� 2015 ����
	ord.salesman_id = (
	SELECT
		worse.salesman_id
	FROM
		(
		SELECT
			TOP (1) 
			ord.salesman_id , SUM(oi.quantity) quantity_sum
		FROM
			db_laba.dbo.order_items oi
		JOIN db_laba.dbo.orders ord ON
			ord.order_id = oi.order_id
		WHERE
			ord.salesman_id IS NOT NULL 
			AND ord.order_date BETWEEN '2015-01-01' AND '2015-12-31'
		GROUP BY
			ord.salesman_id
		ORDER BY
			quantity_sum ASC) worse)
		and ord.status = 'Shipped'
ORDER BY
	1;

   /*������� ��������

	SELECT SUM(oi.quantity) quantity_sum, ord.salesman_id
	FROM db_laba.dbo.order_items oi
	JOIN db_laba.dbo.orders ord on ord.order_id = oi.order_id
	WHERE ord.order_date BETWEEN '2015-01-01' AND '2015-12-31' 
	GROUP BY ord.salesman_id
	ORDER BY
	quantity_sum ASC -- ����� �� ��������, ��� 57-�� �������� ��� ������ � 2015 �� ���-�� ���������� ������ �� ��������� (�� NULL)

	select *
	FROM db_laba.dbo.employees emp
	WHERE emp.employee_id = 57  -- ������� Scarlett = ��, ��� ����� ���������
	*/



	/*4. �������� ����� ����� (���������: sum(quantity * list_price) - sum(quantity * standard_cost) ), ��� ������� � ��� ������
������������ �� ����� ������� � ���� ������
��� �������� �� ������� ����������� ���������� ��������� ����� ��� ������� �������� ���������� ��������� � 2016 ����
������������ �� ���� ���������� (6 ������)*/

SELECT 
(sum(oi.quantity * p.list_price) - sum (oi.quantity * p.standard_cost)) margin,
cust.name cust_name,
YEAR(ord.order_date) order_year
FROM
db_laba.dbo.customers cust 
JOIN db_laba.dbo.orders ord ON
ord.customer_id = cust.customer_id
JOIN db_laba.dbo.order_items oi	ON
ord.order_id = oi.order_id
JOIN db_laba.dbo.products p	ON
p.product_id = oi.product_id -- ������� ���� �������, ��� ������� � ����� ������� ��� join`� ������. �� � ���� ������ ��� ��������� ����� ���������. �����?
WHERE   -- ������ ��� ���� �������� ID ��������, ������� �������� ��� �������
	cust.customer_id in (
	SELECT ord.customer_id
	FROM
		db_laba.dbo.order_items oi
		JOIN db_laba.dbo.orders ord ON
			ord.order_id = oi.order_id
		GROUP BY ord.customer_id
		HAVING
		AVG(oi.quantity)> (
		SELECT
			AVG (oi.quantity) avg_quantity
		FROM
			db_laba.dbo.order_items oi
		JOIN db_laba.dbo.orders ord ON
			ord.order_id = oi.order_id
		WHERE
			YEAR(ord.order_date) = 2016))
GROUP BY
cust.name, YEAR(ord.order_date)
ORDER BY
	2,3,1;

	/* ��������� ��������

			SELECT --oi.quantity
			AVG (oi.quantity) avg_quantity, ord.customer_id
		FROM
			db_laba.dbo.order_items oi
		JOIN db_laba.dbo.orders ord ON
			ord.order_id = oi.order_id
		WHERE
			YEAR(ord.order_date) = 2016
			GROUP BY ord.customer_id

			SELECT
			AVG (oi.quantity) avg_quantity
		FROM
			db_laba.dbo.order_items oi
		JOIN db_laba.dbo.orders ord ON
			ord.order_id = oi.order_id
		WHERE
			YEAR(ord.order_date) = 2016

			SELECT *
			FROM db_laba.dbo.customers cust 
			WHERE customer_id = 7

			-- �������� ����� ��� �������, � ��������� �� ������� customer_id 7 (Alcoa), ��������� �� ������������ ���������

--------------------------------------------------------------------------------------------------------------------------------

���� ��� ������ �������. ��, � �������� � �����, ��� �� ��������.
��-������...����� 42 ������ ������ 50. 
��������� ��������. ������, ���-�� ����������. 
���� � ����������� ������ HAVING, � �� ��������� ������..� �� ������ (� ������� �� WHERE).
��� ������ ����. ��� ���� ������� �����������. � ��� ������� ��� ����, ����� �������� �� ��� �������� ����� ))) ����� �� � �� �����.
		
SELECT
	(sum(oi.quantity*p.list_price)-sum(oi.quantity*p.standard_cost)) margin,
	cust.name cust_name,
	YEAR(ord.order_date) order_year
FROM
	db_laba.dbo.customers cust 
JOIN db_laba.dbo.orders ord ON
ord.customer_id = cust.customer_id
JOIN db_laba.dbo.order_items oi	ON
ord.order_id = oi.order_id
JOIN db_laba.dbo.products p	ON
p.product_id = oi.product_id
GROUP BY
	cust.name,
	YEAR(ord.order_date)
HAVING
	AVG(oi.quantity)> (
	SELECT
		AVG(oi.quantity) avg_quantity
	FROM
		db_laba.dbo.orders ord
	JOIN db_laba.dbo.order_items oi ON
		oi.order_id = ord.order_id
	WHERE
		YEAR(ord.order_date)= 2016)  ---- ����� ������� ���� ������� 87.568027
ORDER BY
	2,3,1;
-------------------------------------------------
	SELECT 
(sum(oi.quantity * p.list_price) - sum (oi.quantity * p.standard_cost)) margin,
cust.name cust_name,
YEAR(ord.order_date) order_year,
AVG (oi.quantity) avg_quantity
FROM
db_laba.dbo.customers cust 
JOIN db_laba.dbo.orders ord ON
ord.customer_id = cust.customer_id
JOIN db_laba.dbo.order_items oi	ON
ord.order_id = oi.order_id
JOIN db_laba.dbo.products p	ON
p.product_id = oi.product_id
GROUP BY
cust.name, YEAR(ord.order_date)
ORDER BY
	2;    -------------- ��� � ��������� �� ������� ������� AbbVie, ��� � 2015 � 2016 ��� ������� ���� ���� ����� ������� (87.568027), �������, ��� ������� ������� ��������� � AbbVie ������� ������ ������ � 2017 �����.
	*/

