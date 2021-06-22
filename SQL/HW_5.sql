문제1번) 주문일자가 2017/09/01 ~ 2017/12/31 일에 해당하는 주문 중에서 , 
           주문 월별로 , 가장 판매가 많았던 상품 (productname) Top 5 개를 보여주세요. 

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

문제2번) 주문일자가 2017/09/01 ~ 2017/12/31 일에 해당하는 주문 중에서 , 주문 월별로 , 결제 금액이 높은 고객 Top 3명을 보여주세요. 
		주문 월별로, 고객 3명을 알려주시고 / 고객의 Full name 을 함께 보여주세요. 

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

문제3번) 주문일자가 2017/09/01 ~ 2017/12/31 일에 해당하는 주문 중에서 , 주문 월별로 , 
		결제 금액이 높은 고객 Top 3에 2번 이상 포함된 적이 있는 고객의 이름과 Top3에 포함된 횟수를 알려주세요. 
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


문제4번) 상품 번호를 기준으로, 범위를 지정하여, 상품번호 그룹을 만들려고합니다. 각 상품 번호 그룹 별로, 주문 수를 알려주세요.


상품번호번호에 그룹은 아래와 같습니다. 
 - 상품번호가 1~ 10에 해당하면 between1_10  
 - 상품번호가 11~20에 해당하면 between11_20  
 - 상품번호가 21~30에 해당하면 between21_30 
 - 상품번호가 31~40에 해당하면 between31_40

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

문제5번) 타이어(Tires)  카테고리에 해당하는 2017/09/01 ~ 2017/09/10일에 주문 중, 주문 일자별 타이어 카테고리별 주문 수를 확인하고. 
		추가로 타이어 카테고리가 이전 주문일자의 주문 수를 노출하고, 이전 주문일자와 현 주문일자를 비교해주세요.  (with 절 활용)


주문 수 비교에 대한 컬럼의 구성은 아래와 같습니다. 
 - 이전 주문일자보다 주문 수가 늘었다면 plus 
 - 이전 주문일자와 주문 수가 동일하다면 same 
 - 이전 주문일자보다 주문 수가 줄었다면 minus

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
