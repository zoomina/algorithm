문제1번)  주문일이 2017-09-02 일에 해당 하는 주문건에 대해서,  
		어떤 고객이, 어떠한 상품에 대해서 얼마를 지불하여  상품을 구매했는지 확인해주세요.

select o.orderdate , o.customerid , od.*, 
		od.quantityordered * od.quotedprice as total_price
from orders o
	join order_details od ON o.ordernumber = od.ordernumber 
where date(o.orderdate) = '2017-09-02'

문제2번)  헬멧을 주문한 적 없는 고객을 보여주세요. 
		헬맷은, Products 테이블의 productname 컬럼을 이용해서 확인해주세요.

select customerid 
from customers c 
except
select o.customerid
from orders o 
	join order_details od on o.ordernumber = od.ordernumber 
	join products p 	  on od.productnumber = p.productnumber 
where p.productname like '%Helmet'


문제3번)  모든 제품 과 주문 일자를 나열하세요. (주문되지 않은 제품도 포함해서 보여주세요.)

-- 왜 4번이 안나올까...ㅠ
select p.productnumber , p.productname , 
	    case when o.orderdate is null then null
	    else o.orderdate 
	    end as orderdate
from products p 
	left outer join order_details od on p.productnumber = od.productnumber 
	left outer join orders o 		  on o.ordernumber = od.ordernumber 


문제5번) 타이어과 헬멧을 모두 산적이 있는 고객의 ID 를 알려주세요.
- 타이어와 헬멧에 대해서는 , Products 테이블의 productname 컬럼을 이용해서 확인해주세요.

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
