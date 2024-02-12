/*
1.월별 커피음료 총 판매수
2.1번 데이터에서 가장 많이 팔린 음료는 몇개인지 출력
3.1번데이터에서 커피음료_페트 데이터를 pivot
4.월별 탄산수와 생수의 평균 판매수 출력
5.월별 비타민워터, 에너지음료, 건강음료 최대 판매수
*/

SELECT substring(일자,1,7) AS MONTH,
	sum(커피음료_페트),sum(커피음료_병),sum(커피음료_중캔),sum(커피음료_소캔)
	FROM store_order
GROUP BY substring(일자,1,7);


SELECT substring(일자,1,7) AS MONTH,
	greatest(sum(커피음료_페트),sum(커피음료_병),sum(커피음료_중캔),sum(커피음료_소캔)) AS greatest
	FROM store_order
GROUP BY substring(일자,1,7);

SELECT '커피음료_페트' AS product,
	sum(CASE WHEN substring(일자,1,7)='2020-07' THEN 커피음료_페트 END) AS '2020-07',
	sum(CASE WHEN substring(일자,1,7)='2020-08' THEN 커피음료_페트 END) AS '2020-08',
	sum(CASE WHEN substring(일자,1,7)='2020-09' THEN 커피음료_페트 END) AS '2020-09',
	sum(CASE WHEN substring(일자,1,7)='2020-10' THEN 커피음료_페트 END) AS '2020-10'
FROM store_order;


SELECT substring(일자,1,7) AS MONTH,
	round(avg(탄산수),2) AS 평균탄산수, round(avg(생수),2) AS 평균생수
	FROM store_order
GROUP BY substring(일자,1,7);


SELECT substring(일자,1,7) AS MONTH,
	max(비타민워터),max(에너지음료),max(건강음료)
	FROM store_order
GROUP BY substring(일자,1,7);


/*
1.가장 비싼음료 top5
2.월별 커피음료 매출 구하기
3.10월3일의 주스 매출 구하기
4.8월의 이온음료 매출 구하기
5.9월의 차음료 판매수와 매출 구하기
*/


SELECT * FROM price_info
ORDER BY price DESC
LIMIT 5;

SELECT substring(일자,1,7) AS MONTH,
	sum(커피음료_페트)*(SELECT price FROM price_info WHERE product='커피음료_페트'),
	sum(커피음료_병)*(SELECT price FROM price_info WHERE product='커피음료_병'),
	sum(커피음료_중캔)*(SELECT price FROM price_info WHERE product='커피음료_중캔'),
	sum(커피음료_소캔)*(SELECT price FROM price_info WHERE product='커피음료_소캔')
	FROM store_order 
GROUP BY substring(일자,1,7)


SELECT 주스_대페트*(SELECT price FROM price_info WHERE product='주스_대페트'),
	주스_중페트*(SELECT price FROM price_info WHERE product='주스_중페트'),
	주스_캔*(SELECT price FROM price_info WHERE product='주스_캔') FROM store_order
WHERE 일자='2020-10-03'

SELECT sum(이온음료_대페트)*(SELECT price FROM price_info WHERE product='이온음료_대페트')+
sum(이온음료_중페트)*(SELECT price FROM price_info WHERE product='이온음료_중페트')+
sum(이온음료_캔)*(SELECT price FROM price_info WHERE product='이온음료_캔') AS total
FROM store_order
WHERE 일자 LIKE '2020-08%'

SELECT sum(차음료), sum(차음료)*(SELECT price FROM price_info WHERE product='차음료')
FROM store_order 
WHERE 일자 LIKE '2020-09%'





/*
1.비가 왔던 날만 출력
2.최고기온이 30도 이상이였던 날의 아이스음료 판매수 출력
3.최저기온이 20도 미만이였던 날의 건강음료 판매수 출력
4.비가 왔던 날의 숙취해소 음료 판매수 출력
5.4번 데이터에 매출 데이터 추가
*/

SELECT * FROM weather;

SELECT 일시 FROM weather
WHERE 일강수량 > 0;

SELECT a.일시,a.최고기온 ,b.아이스음료 FROM weather a
LEFT OUTER JOIN store_order b 
ON a.일시=b.일자
WHERE 최고기온 >=30;

SELECT a.일시,a.최저기온 ,b.건강음료 FROM weather a
LEFT OUTER JOIN store_order b 
ON a.일시=b.일자
WHERE 최저기온 <20;

SELECT a.일시,a.일강수량,ifnull(b.숙취해소음료,0),b.숙취해소음료*(SELECT price FROM price_info WHERE product='숙취해소음료') AS "매출액" FROM weather a
LEFT OUTER JOIN store_order b
ON a.일시=b.일자
WHERE 일강수량>0;