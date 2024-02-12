select * FROM camping_info;
select count(*) from camping_info;

/*
1.캠핑장의 사업장명과 소재지전체주소를 출력(단, 사업장명은 name, 소재지전체주소는 address로 출력)
2. 1번의 데이터에서 정상영업하고 있는 캠핑장만 출력
3.양양에 위치한 캠핑장은 몇개인지 출력
4.3번 데이터에서 폐업한 캠핑장은 몇개인지 출력
5.태안에 위치한 캠핑장의 사업장명 출력
6.5번 데이터에서 2020년에 폐업한 캠핑장만 출력
7.제주도와 서울에 위치한 캠핑장은 몇개인지 출력
*/

select * FROM camping_info;

SELECT 사업장명 AS NAME, 소재지전체주소 AS ADDRESS FROM camping_info;


SELECT 사업장명 AS NAME, 소재지전체주소 AS ADDRESS FROM camping_info
WHERE 영업상태구분코드=1;


SELECT count(*)AS '양양에 위치한 캠핑장' FROM camping_info
WHERE 소재지전체주소 LIKE '%양양%';

SELECT count(*)AS '양양에 위치한 캠핑장 중 폐업한것' FROM camping_info
WHERE 소재지전체주소 LIKE '%양양%'AND 상세영업상태명='폐업';


SELECT 사업장명 FROM camping_info
WHERE 소재지전체주소 LIKE '%태안%';

SELECT 사업장명,소재지전체주소 FROM camping_info
WHERE 소재지전체주소 LIKE '%태안%'AND 폐업일자 LIKE '2020%';

select count(*) fROM camping_info
WHERE 소재지전체주소 LIKE '%서울%' or 소재지전체주소 LIKE '%제주%'

-- 폐업하지 않은 캠핑장
SELECT * FROM camping_info WHERE 영업상태구분코드 <> 3;


/*
1.해수욕장에 위치한 캠핑장의 사업장명과 인허가일자를 출력
2.제주도 해수욕장에 위치한 캠핑장의 소재지천제주소와 사업장명 출력
3.2번데이터에서 인허가 일자가 가장 최근인 곳의 인허가 일자 출력
4.강원도 해수욕장에 위치한 캠핑장 중 영업중인 곳만 출력
5.4번데이터 중에서 인허가일자가 가장 오래된 곳의 인허가일자 출력
6.해수욕장에 위치한 캠핑장 중 시설면적이 가장 넓은 곳의 시설면적 출력
7.해수욕장에 위치한 캠핑장의 평균 시설면적 출력
*/

SELECT * FROM camping_info;

SELECT 사업장명,인허가일자 FROM camping_info WHERE 사업장명 LIKE '%해수욕장%'

SELECT 소재지전체주소,사업장명 FROM camping_info WHERE 사업장명 LIKE '%해수욕장%' AND 소재지전체주소 LIKE '%제주%'

SELECT max(인허가일자)FROM camping_info WHERE 사업장명 LIKE '%해수욕장%' AND 소재지전체주소 LIKE '%제주%';

SELECT * FROM camping_info WHERE 소재지전체주소 LIKE '%강원%' AND 사업장명 LIKE '%해수욕장%' AND 영업상태구분코드=1;


-- 4번데이터가 하나밖에 나오지 않아서 5번 스킵하고 6번
SELECT max(시설면적) FROM camping_info WHERE 사업장명 LIKE '%해수욕장%'

SELECT avg(시설면적) FROM camping_info WHERE 사업장명 LIKE '%해수욕장%'



/*
1.캠핑장의 사업장명과 시설면적을 시설면적이 가장 넓은 순으로 출력
2.1번데이터에서 10위까지만 출력
3.경기도 캠핑장중에 면적이 가장 넓은 순으로 5개 출력
4.3번데이터에서 1위는 제외
5.영업중인 캠핑장 중에서 인허가일자가 가장 오래된 순으로 20개 출력
6.2020년 10월 ~ 2021년 3월 사이에 폐업한 캠핑장의 사업장명과 소재지전체주소 출력
7.폐업한 캠핑장 중에서 시설면적이 가장 컸던 곳의 사업장명과 시설면적 출력
*/

SELECT 사업장명,시설면적 FROM camping_info ORDER BY 시설면적 DESC

SELECT 사업장명,시설면적 FROM camping_info ORDER BY 시설면적 DESC LIMIT 10;

SELECT 사업장명,시설면적 FROM camping_info WHERE 소재지전체주소 LIKE '%경기%' ORDER BY 시설면적 DESC LIMIT 5;

SELECT 사업장명,시설면적 FROM camping_info WHERE 소재지전체주소 LIKE '%경기%' ORDER BY 시설면적 DESC LIMIT 1,4;

SELECT * FROM camping_info WHERE 영업상태구분코드=1 ORDER BY  인허가일자 LIMIT 20;

SELECT 사업장명,소재지전체주소 FROM camping_info WHERE 폐업일자 BETWEEN '2020-10-01' AND '2021-03-31'

SELECT 사업장명,시설면적 FROM camping_info WHERE 영업상태구분코드 = 3 ORDER BY 시설면적 DESC  LIMIT 1;

/*
 1.각 지역별 캠핑장 수 출력(단 , 지역은 location으로 출력)
 2.1번 데이터를 캠핑장 수가 많은 지역부터 출력
 3.각 지역별 영업중인 캠핑장 수 출력
 4.3번데이터에서 캠핑장 수가 300개 이상인 지역만 출력
 5.년도별 폐업한 캠핑장 수 출력(단, 년도는 year로 출력)
 6.5번 데이터를 년도별로 내림차순 하여 출력
 */

SELECT substr(소재지전체주소,1,instr(소재지전체주소,' ')) AS LOCATION, count(*) FROM camping_info
GROUP BY substr(소재지전체주소,1,instr(소재지전체주소,' ')) ORDER BY count(*) DESC;


SELECT substr(소재지전체주소,1,instr(소재지전체주소,' ')) AS LOCATION, count(*) FROM camping_info
WHERE 영업상태구분코드=1
GROUP BY substr(소재지전체주소,1,instr(소재지전체주소,' '))
HAVING count(*) >= 300 ORDER BY count(*) DESC;


SELECT substr(폐업일자,1,4) AS YEAR , count(*) FROM camping_info
WHERE 영업상태구분코드=3
GROUP BY substr(폐업일자,1,4) ORDER BY substr(폐업일자,1,4) desc;
