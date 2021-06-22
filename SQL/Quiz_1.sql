-- 1. employees 테이블을 이용하여,
-- 705 아이디를 갖은 직원의 이름과, 태어난 해를 알려주세요.

select 
	e.empfirstname, e.emplastname , e.empbirthdate 
from employees e 
where
	e.employeeid = 705
;

-- 3. 2017-09-02~ 09-03일 사이에 주문을 한, 주문번호의 갯수는 총 몇개인가요?

select 
	count(*)
from orders o 
where 
	o.orderdate between '2017-09-02' AND '2017-09-03'
;

-- 5. vendor의 State 지역이 NY 또는 WA 인 업체 의 갯수가 어떻게 되나요?
-- (vendors 테이블을 이용 하여 알려주세요)

select
	count(*)
from vendors v 
where 
	v.vendstate = 'NY'
	or v.vendstate = 'WA'
;