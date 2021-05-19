문제1번)  각 제품 가격을 5 % 줄이면 어떻게 될까요?

select *,
	   retailprice * 0.95 as discountprice
from products p
;

문제2번) orders 테이블을 활용하여, 고객번호가 1001 에 해당하는 사람이 employeeid 가 707인 직원으로부터  산 주문의 id 와 주문 날짜를 알려주세요.  
         * 주문일자가 오름차순으로 정렬하여, 보여주세요.

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

문제3번)  vendors 테이블을 이용하여, 벤더가 위치한 state 주가 어떻게 되는지, 확인해보세요.  중복된 주가 있다면, 중복제거 후에 알려주세요. 

select 
	distinct v.vendstate
	*
from 
	vendors v 
where v.vendemailaddress is not null 
;



문제4번) products 테이블을 활용하여, productdescription에 상품 상세 설명 값이 없는  상품 데이터를 모두 알려주세요.

select 
	*
from
	products p 
where 
	p.productdescription is null 
;


문제5번)  customers 테이블을 이용하여, 고객의 id 별로,  custstate 지역 중 WA 지역에 사는 사람과  WA 가 아닌 지역에 사는 사람을 구분해서  보여주세요.
 - customerid 와,  newstate_flag 컬럼으로 구성해주세요 .
 - newstate_flag 컬럼은 WA 와 OTHERS 로  노출해주시면 됩니다.

select
	c.customerid,
	case when c.custstate  = 'WA' then 'WA'
		   else 'OTHERS'
	end as newstate_flag
from
	customers c 
;