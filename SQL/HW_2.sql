����1��)  �ֹ����� 2017-09-02 �Ͽ� �ش� �ϴ� �ֹ��ǿ� ���ؼ�,  
		� ����, ��� ��ǰ�� ���ؼ� �󸶸� �����Ͽ�  ��ǰ�� �����ߴ��� Ȯ�����ּ���.

select o.orderdate , o.customerid , od.*, 
		od.quantityordered * od.quotedprice as total_price
from orders o
	join order_details od ON o.ordernumber = od.ordernumber 
where date(o.orderdate) = '2017-09-02'

����2��)  ����� �ֹ��� �� ���� ���� �����ּ���. 
		�����, Products ���̺��� productname �÷��� �̿��ؼ� Ȯ�����ּ���.

select customerid 
from customers c 
except
select o.customerid
from orders o 
	join order_details od on o.ordernumber = od.ordernumber 
	join products p 	  on od.productnumber = p.productnumber 
where p.productname like '%Helmet'


����3��)  ��� ��ǰ �� �ֹ� ���ڸ� �����ϼ���. (�ֹ����� ���� ��ǰ�� �����ؼ� �����ּ���.)

-- �� 4���� �ȳ��ñ�...��
select p.productnumber , p.productname , 
	    case when o.orderdate is null then null
	    else o.orderdate 
	    end as orderdate
from products p 
	left outer join order_details od on p.productnumber = od.productnumber 
	left outer join orders o 		  on o.ordernumber = od.ordernumber 


����5��) Ÿ�̾�� ����� ��� ������ �ִ� ���� ID �� �˷��ּ���.
- Ÿ�̾�� ��信 ���ؼ��� , Products ���̺��� productname �÷��� �̿��ؼ� Ȯ�����ּ���.

-- Tires
select distinct o.customerid--, p.productname, 'Tires' as flag
from orders o 
	join order_details od on o.ordernumber = od.ordernumber 
	join products p 	  on od.productnumber = p.productnumber 
where p.productname like '%Tires'
intersect 
-- Helmet
select distinct o.customerid--, p.productname, 'Helmet' as flag
from orders o 
	join order_details od on o.ordernumber = od.ordernumber 
	join products p 	  on od.productnumber = p.productnumber 
where p.productname like '%Helmet'
