1. 가장 높은 금액은 산 고객의 customerid 를 알려주세요.

select o.customerid, o.ordernumber , sum(od.quotedprice * od.quantityordered) as total_price
from orders o 
	join order_details od on o.ordernumber = od.ordernumber 
group by o.ordernumber 
order by total_price desc 
;


2. 타이어는 샀지만, 헬멧을 사지 않은 고객의 customerid 를 모두 골라 주세요.

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


3. 캘리포이나 주와, 캘리포니아가 아닌 주에 대한 주문의 갯수는 몇 개인가요? 
   (주문번호가 총 몇개인가요) 
-- 캘리포니아 주에 사는 고객? 아니면 캘리포니아 주에 있는 매장?

-- 캘리포니아주에 사는 고객
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
   
-- 캘리포니아주에 있는 매장
	

4. 어떤 벤더 업체가 가장 다양한 상품을 판매를 하고 있나요? 
	(= 업체의 판매 제품수가 가장 많은 업체는?)

select db.vendorid , v.vendname , db.num_product
from (select pv.vendorid, count(pv.productnumber) as num_product
		from product_vendors pv
		group by pv.vendorid 
	  ) as db
	join vendors v on db.vendorid = v.vendorid 


5. 9/2일자의 주문이 있었던 주문의 갯수와 , 고객의 수를 알려주세요. 
	( ex) 하루에 한 고객이 주문을 2번이상했다고 가정했을때 
		-> 해당의 경우는 고객수는 1명으로 계산해야합니다.)

select count(ordernumber) as order_num, count(distinct customerid) as customer_num
from orders o 
where date(o.orderdate) = '2017-09-02'
		