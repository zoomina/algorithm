����1��) 1�� �ֹ� ��ȣ�� ���ؼ�, ��ǰ��, �ֹ� �ݾװ� 1�� �ֹ� �ݾ׿� ���� �� ���űݾ��� �Բ� �����ּ���. 

select db.productname, sum(db.total_price)
from (
	select p.productname , od.quotedprice , od.quantityordered * od.quotedprice as total_price
	from order_details od 
		join products p on od.productnumber = p.productnumber 
	where ordernumber = 1
) as db
group by rollup (db.productname)


����2��) ����� �ֹ��� ��� ���� �����Ÿ� �ֹ��� ��� ���� �����ϼ���. (Union Ȱ��) 
	   ���� �����Ŵ� Products ���̺��� productname �÷��� �̿��ؼ� Ȯ�����ּ���.

-- helemt
select o.customerid -- , p.productname 
from order_details od 
	join orders o on od.ordernumber = o.ordernumber 
	join products p on od.productnumber = p.productnumber 
where p.productname like '%Helmet'
union
-- bike
select o.customerid --, p.productname 
from order_details od 
	join orders o on od.ordernumber = o.ordernumber 
	join products p on od.productnumber = p.productnumber 
where p.productname like '%Bike'


����3��) �ֹ����ڰ� 2017/09/01 ~ 2017/09/30 �Ͽ� �ش��ϴ� �ֹ��� ���ؼ� �ֹ����ڿ� ������ �ֹ� ���� Ȯ�����ּ���. 
���� ���� �ֹ� ���� �Բ� �˷��ּ���.

select orderdate , customerid , count(ordernumber)
from orders o 
where orderdate between date('2017-09-01') and date('2017-09-30')
group by grouping sets ((orderdate , customerid ), (customerid))


����4��) �ֹ����ڰ� 2017/09/01 ~ 2017/09/30�Ͽ� �ش��ϴ� �ֹ��� ���ؼ�, �ֹ����ڿ� ������ �ֹ� ���� Ȯ�����ּ���. 
���� �ֹ����ں� �ֹ� ���� �Բ� �˷��ֽð�, ��ü �ֹ� ���� �Բ� �˷��ּ���.

select orderdate , customerid , count(ordernumber)
from orders o 
where orderdate between date('2017-09-01') and date('2017-09-30')
group by rollup (orderdate , customerid )



����5��) 2017�⵵�� �ֹ��� �� �ֹ� �ݾװ�, ���� �ֹ� �� �ݾ��� �Բ� �����ּ���. 
���ÿ� �Ϻ� �ֹ� �ݾ��� ���� �ֹ� �ݾ׿� �ش��ϴ� ������ ���� �����ּ���. (analytic function Ȱ��)

select db.ordermonth, db.orderdate, sum(db.total_price), 
		percent_rank() over (partition by db.ordermonth order by (db.ordermonth, db.orderdate))
from(
	select o.orderdate , extract (month from date(o.orderdate )) as ordermonth,
		   od.quantityordered * od.quotedprice as total_price
	from orders o 
		join order_details od on o.ordernumber = od.ordernumber 
	where o.orderdate between date('2017-01-01') and date('2017-12-31')
) as db
group by grouping sets ((db.ordermonth, db.orderdate), (db.ordermonth))