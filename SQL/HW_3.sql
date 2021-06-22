문제1번) 1번 주문 번호에 대해서, 상품명, 주문 금액과 1번 주문 금액에 대한 총 구매금액을 함께 보여주세요. 

select db.productname, sum(db.total_price)
from (
	select p.productname , od.quotedprice , od.quantityordered * od.quotedprice as total_price
	from order_details od 
		join products p on od.productnumber = p.productnumber 
	where ordernumber = 1
) as db
group by rollup (db.productname)


문제2번) 헬멧을 주문한 모든 고객과 자전거를 주문한 모든 고객을 나열하세요. (Union 활용) 
	   헬멧과 자전거는 Products 테이블의 productname 컬럼을 이용해서 확인해주세요.

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


문제3번) 주문일자가 2017/09/01 ~ 2017/09/30 일에 해당하는 주문에 대해서 주문일자와 고객별로 주문 수를 확인해주세요. 
또한 고객별 주문 수도 함께 알려주세요.

select orderdate , customerid , count(ordernumber)
from orders o 
where orderdate between date('2017-09-01') and date('2017-09-30')
group by grouping sets ((orderdate , customerid ), (customerid))


문제4번) 주문일자가 2017/09/01 ~ 2017/09/30일에 해당하는 주문에 대해서, 주문일자와 고객별로 주문 수를 확인해주세요. 
또한 주문일자별 주문 수도 함께 알려주시고, 전체 주문 수도 함께 알려주세요.

select orderdate , customerid , count(ordernumber)
from orders o 
where orderdate between date('2017-09-01') and date('2017-09-30')
group by rollup (orderdate , customerid )



문제5번) 2017년도의 주문일 별 주문 금액과, 월별 주문 총 금액을 함께 보여주세요. 
동시에 일별 주문 금액이 월별 주문 금액에 해당하는 비율을 같이 보여주세요. (analytic function 활용)

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