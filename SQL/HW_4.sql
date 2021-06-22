����1��)  ��ǰ�� �ֹ� �� �� ��ü �ֹ����� �Բ� �����ּ���.

select p.productname , sum(od.quantityordered)
from order_details od 
	join products p on od.productnumber = p.productnumber 
group by rollup(p.productname )
;

����2��)  ��ǰ �̸��� ī�װ��� ��ü ������� �˷��ּ���. ����, ī�װ��� ��ü ����� �� �Բ� �˷��ּ���.

select c.categorydescription , p.productname , 
		sum(od.quantityordered * od.quotedprice) as sales
from order_details od 
	join products p ON od.productnumber = p.productnumber 
	join categories c on p.categoryid = c.categoryid 
group by grouping sets ((p.productname, c.categoryid), (c.categoryid))
;


����3��) ������ ī�װ� �ֹ� ���� �Ŵ� �����ϰ� �ֳ���? (2017�� 1�� ~ 12�� ���� �Ǹŷ��� Ȯ���Ͻø� �˴ϴ�.)
���� �ֹ����� ���� �� �ֹ����� �Բ� ǥ���� ���� ���θ� �˷��ּ���. (analytic function Ȱ��)


Hint �Ʒ��� ǥ�� ������ ���� ���ּ���. 
1) �� �� ���� ���� ũ�ٸ� ? 'PLUS'
2) ���� ���� ���� ���� �� ���� ũ�ٸ� ? 'MINUS'
3) ���� ���� �Ǹ� ���� ���� �� ���� ���ٸ� ? 'SAME'
4) �� ���� Case ? NULL

select *,
		case when sales > prev_sales then 'PLUS'
			 when sales < prev_sales then 'MINUS'
			 when sales = prev_sales then 'SAME'
			 else null
		 end as flag
from (
	select extract (month from date(o.orderdate)) as monthly,
			sum(od.quantityordered * od.quotedprice) as sales,
			lag(sum(od.quantityordered * od.quotedprice)) over (order by extract (month from date(o.orderdate)) ) as prev_sales
	from order_details od 
		join orders o on od.ordernumber = o.ordernumber 
		join products p on od.productnumber = p.productnumber 
	where o.orderdate between date('2017-01-01') and date('2017-12-31')
	group by extract (month from date(o.orderdate)) 
) as db	
;


����4��) ��ǰ ī�װ�, ��(state) �������� ������ ������ �����ְ�, ��(state) ��ü ���������� �Բ� �����ϼ���. (analytic function Ȱ��)

 select v.vendstate , p.categoryid , sum(p.quantityonhand)
 from product_vendors pv 
 	join products p on pv.productnumber = p.productnumber 
 	join vendors v on pv.vendorid = v.vendorid 
 group by grouping sets ((v.vendstate, p.categoryid), (v.vendstate))
 ;



����5��)  �ֹ����ڰ� 2017/09/01 ~ 2017/12/31 �Ͽ� �ش��ϴ� �ֹ� �� ���ؼ�,  ���� ���� ���� �ݾ��� �������� ���� �ݾ׿� ���� flag �� �Բ� �����ּ���. 
flag �� �Ʒ��� �����ϴ�.

- ���� �����ݾ��� 10000 �޷� �Ʒ��� ��� under1000
- ���� �����ݾ��� 10001 ~ 100000 �� �ش��ϴ� ��� under100000 
- ���� �����ݾ��� 100001 ~ 500000�� �ش��ϴ� ��� under500000
- ���� �����ݾ��� 500001 �̻��� ��� over500000

select *,
	   case when db.sales < 10000 then 'under10000'
	   		when db.sales between 10001 and 100000 then 'under100000'
	   		when db.sales between 100001 and 500000 then 'under500000'
	   		when db.sales >= 500001 then 'over500000'
	   	else null
	   	end as flag
from (
	select extract (month from date(o.orderdate)) as monthly,
			o.customerid ,
			sum(od.quantityordered * od.quotedprice) as sales
	from order_details od 
		join orders o on od.ordernumber = o.ordernumber 
	where date(o.orderdate) between date('2017-09-01') and date('2017-12-31')
	group by extract (month from date(o.orderdate)),
			 o.customerid 
	) as db
;