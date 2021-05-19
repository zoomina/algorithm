-- 생각대로 SQL 3

1. 고객의 기본 정보인 id, 이름, 성, 메일과 함께
   고객의 주소 address, district, postal_code, phone 번호를 함께
   
select c.customer_id, c.first_name, c.last_name, c.email,
	   a.address, a.district, a.postal_code, a.phone
from customer c 
	join address a on c.address_id = a.address_id 

	
2. 고객의 기본 정보인 고객 id, 이름, 성, 이메일과 함께
   고객의 주소 address, district, postal_code, phone, city를 함께
  
select c.customer_id , c.last_name , c.first_name , c.email ,
	   a.address , a.district , a.postal_code , a.phone , ct.city 
from customer c 
	join address a on c.address_id = a.address_id 
	join city ct on a.city_id = ct.city_id 

	
3. Lima City에 사는 고객의 이름, 성, 이메일, phonenumber

select c.last_name , c.first_name , c.email , a.phone 
from customer c 
	join address a on c.address_id = a.address_id 
	join city ct on ct.city_id = a.city_id 
where ct.city = 'Lima'


4. rental 정보에 추가로 고객의 이름, 직원의 이름
- 고객의 이름, 직원의 이름은 이름과 성을 fullname 컬럼으로 만들어서 2개의 컬럼으로

select
	r.*,
	c.first_name || ' ' || c.last_name as customer_name,
	s.first_name || ' ' || s.last_name as staff_name
from rental r 
	join customer c on r.customer_id = c.customer_id 
	join staff s on r.staff_id = s.staff_id 
		
10. country가 china가 아닌 지역에 사는, 고객의 이름(first_name, last_name),
    email, phonenumber, country, city
  
select 
	c.first_name || ' ' || c.last_name as customer_fullname,
	c.email , a.phone , con.country , ct.city 
from customer c 
	join address a   on c.address_id = a.address_id 
	join city ct     on a.city_id = ct.city_id 
	join country con on ct.country_id = con.country_id 
where con.country not in ('China')


12. Music 장르이면서, 영화길이가 60~180분 사이 영화의 title, description, length

select 
	f.title , f.description , f.length 
from film f 
	join film_category fc on f.film_id = fc.film_id 
	join category c 	  on fc.category_id = c.category_id 
where 
	c."name" in ('Music') and
	f.length between 60 and 180


13. actor 테이블을 이용하여 배우의 ID, 이름, 성 컬럼에
    추가로 Angels Life 영화에 나온 여부를 Y/N으로 컬럼 추가(angelslife_flag)

select a.actor_id , a.first_name , a.last_name ,
	   case when angels_actor.actor_id is null then 'N'
	   		else 'Y'
	   		end as angelslife_flag
from actor a 
	left outer join(
		select f.film_id, f.title, fa.actor_id 
		from film f 
			join film_actor fa on f.film_id = fa.film_id 
		where f.title = 'Angels Life'
	) as angels_actor on a.actor_id = angels_actor.actor_id
    
14. 대여 일자가 2005-06-01~14에 해당하는 주문 중에서 직원의 이름 = Mike Hillyer 이거나
    고객의 이름 = Gloria Cook에 해당하는 rental의 모든 정보
    - 직원 이름과 고객 이름도 fullname으로 구성해서 추가

select r.*,
	   c.first_name || ' ' || c.last_name as customer_name,
	   s.first_name || ' ' || s.last_name as staff_name
from rental r 
	join customer c on r.customer_id = c.customer_id 
	join staff s 	on r.staff_id = s.staff_id 
where date(r.rental_date) between '2005-06-01' and '2005-06-14'
	and (s.first_name || ' ' || s.last_name = 'Mike Hillyer' 
	or c.first_name || ' ' || c.last_name = 'Gloria Cook')
	
	
	
-- 생각대로 SQL 4

2. 영화등급(rating) 별로 영화(film)를 몇 개 가지고 있는지 확인

select  rating,
		count(film_id) as num_film
from film
group by rating
;

4. 영화 배우(actor)들이 출연한 영화는 각 몇 편
   - 배우의 이름, 성, 영화 수

select  a.first_name , a.last_name,
		count(distinct f.film_id) as num_film
from film f 
	join film_actor fa  on f.film_id = fa.film_id 
	join actor a 		on fa.actor_id = a.actor_id 
group by a.actor_id 
;

5. 국가(country)별 고객(customer) 수

select con.country ,
		count(c.customer_id) as num_customer
from customer c 
	join address a   on c.address_id = a.address_id 
	join city ct 	 on a.city_id = ct.city_id 
	join country con on ct.country_id = con.country_id 
group by con.country_id 
order by count(c.customer_id) desc
;

8. rental 기준으로 2005년 5월 26일에 대여한 고객 중, 하루에 2번 이상 대여한 고객의 id

select  c.customer_id,
		count(distinct rental_id) as cnt
from rental r 
	join customer c on r.customer_id = c.customer_id 
where date(r.rental_date) = '2005-05-26'
group by c.customer_id 
having count(distinct rental_id) >= 2
;

9. film_actor 기준으로, 출연한 영화의 수가 많은 배우 5명의 actor_id, 영화 수

select fa.actor_id ,
	   count(film_id) as num_film
from film_actor fa 
	join actor a on fa.actor_id = a.actor_id 
group by fa.actor_id 
order by num_film desc
limit 5
;

13. 고객 등급별 고객 수 확인
    대여 금액별 고객 등급 조건 (소수점은 반올림)
	A >= 151
	101 <= B <= 150
	51 <= c <= 100
	D <= 50
	
select db.customer_rank, count(db.customer_id) as cnt
from (
	select customer_id ,
		case when round(sum(amount)) >= 151 then 'A'
			 when round(sum(amount)) between 101 and 150 then 'B'
			 when round(sum(amount)) between 51  and 100 then 'C'
			 when round(sum(amount)) <= 50 then 'D'
		 else 'Empty'
		 end as customer_rank
	from payment p 
	group by customer_id 
) as db
group by db.customer_rank
order by db.customer_rank
;


-- 생각대로 SQL 5

1. 180분 이상 길이의 영화에 출연하거나 rating이 R인 영화에 출연한 영화 배우에 대해서
   배우 id와 flag 컬럼 출력
   1) film_actor, film 이용
   2) union, unionall, intersect, except 중 상황에 맞게 사용
   3) actor_id가 동일한 flag 여러개 나오지 않도록

   -- 왜 중복제거가 안되지?
select actor_id, 'upper_180min' as flag
	from film_actor fa 
		join film f on fa.film_id = f.film_id 
	where f.length >= 180
union 
select actor_id, 'rating_R' as flag
	from film_actor fa
		join film f on fa.film_id = f.film_id 
	where f.rating = 'R'
;

4. 카테고리가 action, Animation, Horror에 해당하지 않는 필름 아이디
	- category 사용
	
select f.film_id
from film f
except 
select f.film_id
from category c 
	join film_category fc on c.category_id = fc.category_id 
	join film f 		  on fc.film_id = f.film_id 
where name in ('Action', 'Animation', 'Horror')
;
	
5. staff의 id, 이름, 성 / customer의 id, 이름 성 에 대한 데이터를 하나의 데이터셋으로
	- 컬럼 구성 : id, 이름, 성, flag(고객/직원)
	
select staff_id as id, first_name, last_name , 'staff' as flag
from staff s 
union
select customer_id as id, first_name , last_name , 'customer' as flag
from customer c 
;
	
6. 직원과 고객의 이름이 동일한 사람의 이름과 성

select c.first_name , c.last_name 
from (
	select last_name 
	from staff s 
	intersect
	select last_name 
	from customer c 
) as intersected
	join customer c on c.last_name = intersected.last_name
;

8. 국가(country)별 도시(city)별 매출액, 국가 매출액 소계, 전체 매출액

-- 국가별 도시별 매출액
select con.country , ct.city , sum(amount) as sales
from payment p 
	join customer c  on p.customer_id = c.customer_id 
	join address a   on c.address_id = a.address_id 
	join city ct	 on a.city_id = ct.city_id 
	join country con on ct.country_id = con.country_id 
group by con.country , ct.city 

-- 국가 매출액 소계
select con.country, sum(amount) as sales
from payment p 
	join customer c  on p.customer_id = c.customer_id 
	join address a   on c.address_id = a.address_id 
	join city ct	 on a.city_id = ct.city_id 
	join country con on ct.country_id = con.country_id 
group by con.country 

-- 전체 매출액
select sum(amount) as sales
from payment p 