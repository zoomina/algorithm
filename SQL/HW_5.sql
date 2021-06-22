����1��) �ֹ����ڰ� 2017/09/01 ~ 2017/12/31 �Ͽ� �ش��ϴ� �ֹ� �߿��� , 
           �ֹ� ������ , ���� �ǸŰ� ���Ҵ� ��ǰ (productname) Top 5 ���� �����ּ���. 

select *
from (
	select extract (month from date(o.orderdate)) as month, 
			p.productname , sum(od.quotedprice * od.quantityordered) as monthly_sales,
			rank() over(partition by extract (month from date(o.orderdate)) order by sum(od.quotedprice * od.quantityordered) desc)	as product_rank
	from order_details od 
		join orders o on o.ordernumber = od.ordernumber 
		join products p on od.productnumber = p.productnumber 
	where o.orderdate between date('2017-09-01') and date('2017-12-31')
	group by extract (month from date(o.orderdate)), p.productname 
) as db
where db.product_rank <= 5
;

����2��) �ֹ����ڰ� 2017/09/01 ~ 2017/12/31 �Ͽ� �ش��ϴ� �ֹ� �߿��� , �ֹ� ������ , ���� �ݾ��� ���� �� Top 3���� �����ּ���. 
		�ֹ� ������, �� 3���� �˷��ֽð� / ���� Full name �� �Բ� �����ּ���. 

select *
from(
	select extract (month from date(o.orderdate)) as month, 
			c.customerid , concat(c.custfirstname , ' ', c.custlastname ) as customer_fullname,
			sum(od.quotedprice * od.quantityordered) as total_sales,
			rank() over(partition by extract (month from date(o.orderdate)) order by sum(od.quotedprice * od.quantityordered) desc)	as top_rank
	from order_details od 
		join orders o on od.ordernumber = o.ordernumber 
		join customers c on o.customerid = c.customerid 
	where o.orderdate between date('2017-09-01') and date('2017-12-31')
	group by extract (month from date(o.orderdate)), c.customerid 
) as db
where db.top_rank <= 3
;

����3��) �ֹ����ڰ� 2017/09/01 ~ 2017/12/31 �Ͽ� �ش��ϴ� �ֹ� �߿��� , �ֹ� ������ , 
		���� �ݾ��� ���� �� Top 3�� 2�� �̻� ���Ե� ���� �ִ� ���� �̸��� Top3�� ���Ե� Ƚ���� �˷��ּ���. 
with db (monthly, customer_fullname, total_sales, top_rank) as (
	select *
	from(
		select extract (month from date(o.orderdate)) as monthly, 
				c.customerid , concat(c.custfirstname , ' ', c.custlastname ) as customer_fullname,
				sum(od.quotedprice * od.quantityordered) as total_sales,
				rank() over(partition by extract (month from date(o.orderdate)) order by sum(od.quotedprice * od.quantityordered) desc)	as top_rank
		from order_details od 
			join orders o on od.ordernumber = o.ordernumber 
			join customers c on o.customerid = c.customerid 
		where o.orderdate between date('2017-09-01') and date('2017-12-31')
		group by extract (month from date(o.orderdate)), c.customerid 
	) as foo
	where foo.top_rank <= 3
) 
		
select db.customer_fullname, count(db.customer_fullname)
from db
group by db.customer_fullname
having count(db.customer_fullname) >= 2
;


����4��) ��ǰ ��ȣ�� ��������, ������ �����Ͽ�, ��ǰ��ȣ �׷��� ��������մϴ�. �� ��ǰ ��ȣ �׷� ����, �ֹ� ���� �˷��ּ���.


��ǰ��ȣ��ȣ�� �׷��� �Ʒ��� �����ϴ�. 
 - ��ǰ��ȣ�� 1~ 10�� �ش��ϸ� between1_10  
 - ��ǰ��ȣ�� 11~20�� �ش��ϸ� between11_20  
 - ��ǰ��ȣ�� 21~30�� �ش��ϸ� between21_30 
 - ��ǰ��ȣ�� 31~40�� �ش��ϸ� between31_40

with db (p_group, ordernumber) as (
	select case when p.productnumber between 1 and 10 then 'between1_10'
				when p.productnumber between 11 and 20 then 'between11_20'
				when p.productnumber between 21 and 30 then 'between21_30'
				when p.productnumber between 31 and 40 then 'between31_40'
			end as p_group,
			od.ordernumber 
	from products p 
		join order_details od on p.productnumber = od.productnumber 
)

select db.p_group, count(db.ordernumber)
from db
group by db.p_group
;

����5��) Ÿ�̾�(Tires)  ī�װ��� �ش��ϴ� 2017/09/01 ~ 2017/09/10�Ͽ� �ֹ� ��, �ֹ� ���ں� Ÿ�̾� ī�װ��� �ֹ� ���� Ȯ���ϰ�. 
		�߰��� Ÿ�̾� ī�װ��� ���� �ֹ������� �ֹ� ���� �����ϰ�, ���� �ֹ����ڿ� �� �ֹ����ڸ� �����ּ���.  (with �� Ȱ��)


�ֹ� �� �񱳿� ���� �÷��� ������ �Ʒ��� �����ϴ�. 
 - ���� �ֹ����ں��� �ֹ� ���� �þ��ٸ� plus 
 - ���� �ֹ����ڿ� �ֹ� ���� �����ϴٸ� same 
 - ���� �ֹ����ں��� �ֹ� ���� �پ��ٸ� minus

with db (categorydescription, orderdate, cnt, prev_cnt) as (
	select c.categorydescription , o.orderdate , count(o.ordernumber) as cnt,
			lag(count(o.ordernumber)) over(partition by c.categorydescription order by o.orderdate) as prev_cnt
	from order_details od 
		join orders o on od.ordernumber = o.ordernumber 
		join products p on od.productnumber = p.productnumber 
		join categories c on p.categoryid = c.categoryid 
	where o.orderdate between date('2017-09-01') and date('2017-09-10')
			and c.categorydescription like 'Tires'
	group by c.categorydescription , o.orderdate
)

select *,
		case when db.cnt > db.prev_cnt then 'plus'
			 when db.cnt = db.prev_cnt then 'same'
			 when db.cnt < db.prev_cnt then 'minus'
		end as flag
from db
;
