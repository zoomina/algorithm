1. ���� ���� �ݾ��� �� ���� customerid �� �˷��ּ���.

select o.customerid, o.ordernumber , sum(od.quotedprice * od.quantityordered) as total_price
from orders o 
	join order_details od on o.ordernumber = od.ordernumber 
group by o.ordernumber 
order by total_price desc 
;


2. Ÿ�̾�� ������, ����� ���� ���� ���� customerid �� ��� ��� �ּ���.

-- Tires
select distinct o.customerid--, p.productname, 'Tires' as flag
from orders o 
	join order_details od on o.ordernumber = od.ordernumber 
	join products p 	  on od.productnumber = p.productnumber 
where p.productname like '%Tires'
except 
-- Helmet
select distinct o.customerid--, p.productname, 'Helmet' as flag
from orders o 
	join order_details od on o.ordernumber = od.ordernumber 
	join products p 	  on od.productnumber = p.productnumber 
where p.productname like '%Helmet'


3. Ķ�����̳� �ֿ�, Ķ�����Ͼư� �ƴ� �ֿ� ���� �ֹ��� ������ �� ���ΰ���? 
   (�ֹ���ȣ�� �� ��ΰ���) 
-- Ķ�����Ͼ� �ֿ� ��� ��? �ƴϸ� Ķ�����Ͼ� �ֿ� �ִ� ����?

-- Ķ�����Ͼ��ֿ� ��� ��
select db.CAflag, count(db.CAflag)
from (
		select o.ordernumber ,
				case when c.custstate = 'CA' then 'CA'
				else 'N'
				end as CAflag
		from orders o 
			join customers c on o.customerid = c.customerid 
		) as db
group by db.CAflag
   
-- Ķ�����Ͼ��ֿ� �ִ� ����
	

4. � ���� ��ü�� ���� �پ��� ��ǰ�� �ǸŸ� �ϰ� �ֳ���? 
	(= ��ü�� �Ǹ� ��ǰ���� ���� ���� ��ü��?)

select db.vendorid , v.vendname , db.num_product
from (select pv.vendorid, count(pv.productnumber) as num_product
		from product_vendors pv
		group by pv.vendorid 
	  ) as db
	join vendors v on db.vendorid = v.vendorid 


5. 9/2������ �ֹ��� �־��� �ֹ��� ������ , ���� ���� �˷��ּ���. 
	( ex) �Ϸ翡 �� ���� �ֹ��� 2���̻��ߴٰ� ���������� 
		-> �ش��� ���� ������ 1������ ����ؾ��մϴ�.)

select count(ordernumber) as order_num, count(distinct customerid) as customer_num
from orders o 
where date(o.orderdate) = '2017-09-02'
		