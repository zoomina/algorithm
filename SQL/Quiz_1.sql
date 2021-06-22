-- 1. employees ���̺��� �̿��Ͽ�,
-- 705 ���̵� ���� ������ �̸���, �¾ �ظ� �˷��ּ���.

select 
	e.empfirstname, e.emplastname , e.empbirthdate 
from employees e 
where
	e.employeeid = 705
;

-- 3. 2017-09-02~ 09-03�� ���̿� �ֹ��� ��, �ֹ���ȣ�� ������ �� ��ΰ���?

select 
	count(*)
from orders o 
where 
	o.orderdate between '2017-09-02' AND '2017-09-03'
;

-- 5. vendor�� State ������ NY �Ǵ� WA �� ��ü �� ������ ��� �ǳ���?
-- (vendors ���̺��� �̿� �Ͽ� �˷��ּ���)

select
	count(*)
from vendors v 
where 
	v.vendstate = 'NY'
	or v.vendstate = 'WA'
;