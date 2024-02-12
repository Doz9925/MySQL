/*
1.고속도로 휴게소의 규모와 주차장 현황을 함께 출력(휴게소명,시설구분, 합계,대형,소형,장애인)
2.고속도로 휴게소의 규모와 화장실 현황을 함꼐 출력(휴게소명, 시설구분, 남자_변기수,여자_변기수)
3.고속도로 휴게소의 규모, 주차장, 화장실 현황을 함께 출력(휴게소명, 시설구분,합계, 남자_변기수,여자_변기수)
4.고속도로 휴게소 규모별로 주차장수 합계의 평균, 최소값,최대값 출력
5.고속도로 휴게소 만족도별로 대형 주차장수가 가장많은 휴게소만 출력
*/

SELECT*FROM rest_area_score ras; 
SELECT*FROM rest_area_parking

SELECT ras.휴게소명,ras.시설구분,rap.합계,rap.대형,rap.소형,rap.장애인 
	FROM rest_area_score ras LEFT outer JOIN rest_area_parking rap 
		ON ras.휴게소명=rap.휴게소명
UNION
SELECT rap.휴게소명,ras.시설구분,rap.합계,rap.대형,rap.소형,rap.장애인
	FROM rest_area_parking rap LEFT OUTER JOIN rest_area_score ras
		ON ras.휴게소명=rap.휴게소명;


SELECT * FROM rest_area_restroom rar 

SELECT ras.휴게소명,ras.시설구분,rar.남자_변기수,rar.여자_변기수 
FROM rest_area_score ras inner JOIN rest_area_restroom rar ON ras.휴게소명=rar.시설명

SELECT ras.휴게소명,ras.시설구분,rar.남자_변기수,rar.여자_변기수 FROM rest_area_score ras
LEFT OUTER JOIN rest_area_parking rap ON ras.휴게소명=rap.휴게소명
LEFT OUTER JOIN rest_area_restroom rar ON rap.휴게소명=rar.시설명

SELECT avg(rap.합계),min(rap.합계),max(rap.합계) FROM rest_area_score ras
LEFT OUTER JOIN rest_area_parking rap ON ras.휴게소명=rap.휴게소명
GROUP BY ras.시설구분;



/*
1.노선별 남자변기수, 여자 변기수 최대값 출력
2.휴게소 중 total 변기수가 가장 많은 휴게소가 어디인지 출력
3.노선별로 남자_변기수, 여자_변기수의 평균값 출력
4.노선별로 total 변기수가 가장 많은 곳만 출력
5.노선별로 남자 변기수가 더 많은 곳, 여자 변기수가 더 많은 곳, 남녀 변기수가 동일한 곳의 count를 각각 구하여 출력
*/

SELECT 시설명 FROM rest_area_restroom rar 

SELECT 노선,max(남자_변기수),max(여자_변기수) FROM rest_area_restroom GROUP BY 노선;

SELECT 시설명,남자_변기수+여자_변기수 AS total FROM rest_area_restroom GROUP BY 시설명 ORDER BY total DESC LIMIT 1;


SELECT 노선,round(avg(남자_변기수),2),round(avg(여자_변기수),2) FROM rest_area_restroom GROUP BY 노선

SELECT t.노선,t.시설명,t.total
	FROM(
		SELECT 노선,시설명,남자_변기수+여자_변기수 AS total,
			RANK() OVER(PARTITION BY 노선 ORDER BY 남자_변기수+여자_변기수 DESC) AS rnk FROM rest_area_restroom
   	) t  WHERE t.rnk=1;
   
SELECT 노선,
	count(CASE WHEN 남자_변기수 > 여자_변기수 THEN 1 end) AS male,
	count(CASE WHEN 여자_변기수 > 남자_변기수 THEN 1 end) AS female,
	count(CASE WHEN 여자_변기수=남자_변기수 THEN 1 end) AS equal,
	count(*) AS total
FROM rest_area_restroom
GROUP BY 노선;


/*
1.평가등급이 최우수인 휴게소의 장애인 주차장수 출력(휴게소명,시설굽ㄴ,장애인 주차장수 내림차순으로 출력)
2.평가등급이 우수인 휴게소의 장애인 주차장수 비율 출력(휴게소명, 시설구분, 장애인 주차장수 비율 내림차순으로 출력)
3.휴게소의 시설구분별 주차장 수 합계의 평균 출력
4.노선별로 대형차를 가장 많이 주차할 수 있는 휴게소 top3
5.본부별로 소형차를 가장 많이 주차할 수 있는 휴게소 top3
*/

SELECT ras.휴게소명, ras.시설구분, rap.장애인
FROM (
	SELECT 휴게소명, 시설구분
	FROM rest_area_score
	WHERE 평가등급='최우수'
	) ras LEFT OUTER JOIN rest_area_parking rap
	ON ras.휴게소명=rap.휴게소명
ORDER BY rap.장애인 DESC;


SELECT ras.휴게소명, ras.시설구분, round(rap.장애인/rap.합계*100,2) AS ratio
FROM (
	SELECT 휴게소명, 시설구분
	FROM rest_area_score
	WHERE 평가등급='우수'
	) ras LEFT OUTER JOIN rest_area_parking rap
	ON ras.휴게소명=rap.휴게소명
ORDER BY rap.장애인/rap.합계*100 DESC; 

SELECT ras.시설구분,round(avg(rap.합계),2) FROM rest_area_score ras, rest_area_parking rap
WHERE ras.휴게소명=rap.휴게소명
GROUP BY ras.시설구분;

SELECT t.노선,t.대형,t.휴게소명 FROM (
	SELECT rar.노선,rap.대형,rap.휴게소명,
			rank() over(PARTITION BY rar.노선 ORDER BY rap.대형 desc) AS rnk
		FROM rest_area_restroom rar,rest_area_parking rap 
		WHERE rar.시설명=rap.휴게소명) t
WHERE t.rnk <4;

SELECT t.본부	,t.소형,t.휴게소명 FROM (
	SELECT raw.본부,rap.소형,rap.휴게소명,
			rank() over(PARTITION BY raw.본부 ORDER BY rap.소형 desc) AS rnk
		FROM rest_area_wifi raw,rest_area_parking rap 
		WHERE raw.휴게소명=rap.휴게소명) t
WHERE t.rnk <4;


/*
1.반려동물 놀이터가 있는 휴게소 중 wifi 사용이 가능한 곳 출력
2.반려동물 놀이터가 있는 휴게소 중 운영시간이 24시간인 곳이 몇 군데인지 출력
3.본부별로 wifi 사용이 가능한 휴게소가 몇 군데인지 출력
4. 3번 데이터를 휴게소가 많은 순서대로 정렬하며 출력
5. 4번 데이터에서 휴게소 수가 25보다 많은 곳만 출력
*/

SELECT * FROM rest_area_animal a
LEFT OUTER JOIN rest_area_wifi b ON a.휴게소명=b.휴게소명
WHERE b.가능여부='O'

SELECT count(*)FROM rest_area_animal WHERE 운영시간='24:00'


SELECT trim(본부),count(*) FROM rest_area_wifi
WHERE 가능여부='O'
GROUP BY trim(본부)
HAVING count(*) >25
ORDER BY count(*) DESC;


