문제1번)  상품별 주문 수 와 전체 주문수를 함께 보여주세요.

select p.productname , sum(od.quantityordered)
from order_details od 
	join products p on od.productnumber = p.productnumber 
group by rollup(p.productname )
;

문제2번)  상품 이름과 카테고리별 전체 매출액을 알려주세요. 또한, 카테고리별 전체 매출액 도 함께 알려주세요.

select c.categorydescription , p.productname , 
		sum(od.quantityordered * od.quotedprice) as sales
from order_details od 
	join products p ON od.productnumber = p.productnumber 
	join categories c on p.categoryid = c.categoryid 
group by grouping sets ((p.productname, c.categoryid), (c.categoryid))
;


문제3번) 자전거 카테고리 주문 량이 매달 증가하고 있나요? (2017년 1월 ~ 12월 까지 판매량만 확인하시면 됩니다.)
월별 주문량을 이전 달 주문량과 함께 표기해 증가 여부를 알려주세요. (analytic function 활용)


Hint 아래의 표기 값으로 산출 해주세요. 
1) 전 달 보다 값이 크다면 ? 'PLUS'
2) 이전 달의 값이 현재 값 보다 크다면 ? 'MINUS'
3) 현재 달의 판매 량과 이전 달 값이 같다면 ? 'SAME'
4) 이 외의 Case ? NULL

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


문제4번) 제품 카테고리, 주(state) 기준으로 보유한 물량을 보여주고, 주(state) 전체 보유물량도 함께 나열하세요. (analytic function 활용)

 select v.vendstate , p.categoryid , sum(p.quantityonhand)
 from product_vendors pv 
 	join products p on pv.productnumber = p.productnumber 
 	join vendors v on pv.vendorid = v.vendorid 
 group by grouping sets ((v.vendstate, p.categoryid), (v.vendstate))
 ;



문제5번)  주문일자가 2017/09/01 ~ 2017/12/31 일에 해당하는 주문 에 대해서,  월별 고객별 결제 금액을 기준으로 결제 금액에 대한 flag 를 함께 보여주세요. 
flag 는 아래와 같습니다.

- 고객의 결제금액이 10000 달러 아래에 경우 under1000
- 고객의 결제금액이 10001 ~ 100000 에 해당하는 경우 under100000 
- 고객의 결제금액이 100001 ~ 500000에 해당하는 경우 under500000
- 고객의 결제금액이 500001 이상인 경우 over500000

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