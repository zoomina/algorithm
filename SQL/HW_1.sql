����1��)  �� ��ǰ ������ 5 % ���̸� ��� �ɱ��?

select *,
	   retailprice * 0.95 as discountprice
from products p
;

����2��) orders ���̺��� Ȱ���Ͽ�, ����ȣ�� 1001 �� �ش��ϴ� ����� employeeid �� 707�� �������κ���  �� �ֹ��� id �� �ֹ� ��¥�� �˷��ּ���.  
         * �ֹ����ڰ� ������������ �����Ͽ�, �����ּ���.

select 
	o.ordernumber,
	o.orderdate 
from 
	orders o 
where
	o.customerid = 1001 and employeeid = 707
order by
	orderdate asc
;

����3��)  vendors ���̺��� �̿��Ͽ�, ������ ��ġ�� state �ְ� ��� �Ǵ���, Ȯ���غ�����.  �ߺ��� �ְ� �ִٸ�, �ߺ����� �Ŀ� �˷��ּ���. 

select 
	distinct v.vendstate
	*
from 
	vendors v 
where v.vendemailaddress is not null 
;



����4��) products ���̺��� Ȱ���Ͽ�, productdescription�� ��ǰ �� ���� ���� ����  ��ǰ �����͸� ��� �˷��ּ���.

select 
	*
from
	products p 
where 
	p.productdescription is null 
;


����5��)  customers ���̺��� �̿��Ͽ�, ���� id ����,  custstate ���� �� WA ������ ��� �����  WA �� �ƴ� ������ ��� ����� �����ؼ�  �����ּ���.
 - customerid ��,  newstate_flag �÷����� �������ּ��� .
 - newstate_flag �÷��� WA �� OTHERS ��  �������ֽø� �˴ϴ�.

select
	c.customerid,
	case when c.custstate  = 'WA' then 'WA'
		   else 'OTHERS'
	end as newstate_flag
from
	customers c 
;