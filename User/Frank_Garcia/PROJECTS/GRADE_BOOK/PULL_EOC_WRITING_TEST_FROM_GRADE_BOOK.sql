--declare @ASSESSMENT_NAME varchar(100) = '2015-2016 Senior Retakes EOC ELA III Reading 9 12 V006'

SELECT
	
	STUDENTID
	,STUDENT_NAME
	,TESTNAME
	--,'EOC English III Writing 9 12 V006 ' AS STARS_NAME
	,TEST_DATE
	,'04/01/2016' AS ASSESSMENT_TEST_DATE
	,CAST (POINTS AS INT) AS NUMBER_CORRECT
	,PCT_CORRECT
	,'24' AS CUT_SCORE
	--,CASE WHEN POINTS < '24' THEN 'FAIL' ELSE 'PASS' END AS PERFORMANCE_LEVEL
	--,CASE WHEN POINTS < '15' THEN 'FAIL' ELSE 'PASS' --- SPANISH III V001
	--,CASE WHEN POINTS < '26' THEN 'FAIL' ELSE 'PASS' --- ELA IV V003 V001
	,CASE WHEN POINTS < '24' THEN 'FAIL' ELSE 'PASS' --- ELA III V006
	END AS PERFORMANCE_LEVEL
FROM
    (   
select  
	  stu.LASTNAME+', ' +stu.FIRSTNAME STUDENT_NAME
	   , stu.STUDENTID
       , t.TESTNAME
       ,convert(date,convert(varchar(11),min(r.RESPONSEDATE))) TEST_DATE
       , SUM(case when r.CORRECT=1 then 1 else 0 end)  as NUMBER_CORRECT
       , SUM(case when r.CORRECT=0 then 1 else 0 end) as NUMBER_INCORRECT
       , COUNT(r.id) as NUMBER_OF_QUESTIONS
       --,convert(decimal(6,1), SUM(case when r.CORRECT=1 then 1.0 else 0.0 end) / COUNT(r.ID)*100.0,1) PCT_CORRECT
	   ,CONVERT (DECIMAL(6,1), SUM(POINTS)/36*100) AS PCT_CORRECT
	   ,SUM (POINTS) AS POINTS
	   --,sch.ID
from rev.EGB_TEST t
       join rev.EGB_TEST_SCHEDULED sch on sch.TESTID = t.id
       join rev.EGB_TEST_STUDENTRESPONSES r on r.SCHEDULEDTESTID = sch.ID 
       join rev.EGB_TEST_STUDENTS ts on ts.STUDENTID = r.STUDENTID and ts.SCHEDULEDTESTID = sch.ID
       join rev.EGB_PEOPLE stu on stu.ID = r.STUDENTID
where ts.COMPLETEDATE is not null
--and t.TESTNAME LIKE '%EOC%'
--AND T.TESTNAME  LIKE '%SPRING%'
and t.TESTNAME like  '%SUMMER EOC%'
--AND T.TESTNAME = '2015-2016 Spring EOC Spanish III Writing 9 12 V001'
--AND STU.ID = '22058'
--AND CS.ASSESSMENT_ID BETWEEN 1001 AND 1086
--AND STU.STUDENTID = '102795259'
group by stu.LASTNAME+', ' +stu.FIRSTNAME, stu.STUDENTID 
       ,t.TESTNAME ,sch.ID ---,R.POINTS
) T2
--WHERE STUDENTID NOT IN ('103488458','970099538','103430278','970099565','103442828','970029535','103484846','103368890','970062428','103443313','103442778','100502772','103722187','103477543','103453304','102758505','970108766','103391579','102850633','100104561','103386702','103394029','970106284','101749877','104093786','102974250','980024712','970082642','102790045','970104816','102710985','980021033','102709813','100504083','103382602','103609392','970106287','103406302','103527941','103476875','970080824','102893203','103415485','102828514','103370359','103437919','980024842','103383592') --- ELA III
--WHERE STUDENTID NOT IN ('102892882','103475711','100503432','100104447','100061720','102964681','102796463','102717857','980001193','102821105','100104561','101749877','756921698','102789153','102709482','102707932','102708559','102795929','103420378','970106284','970104839','102985165','102723624','102735800','103427316','102984804','102710985','102787231','102817889','102732674','102790045','447257619','100049584','102902764','103481081','100105162','102734720','970095148','102732773','102828514','102904877','102828860','102735222','102564424') --- ELA IV
--order by CS.STARS_NAME
--ORDER BY stu.LASTNAME+', ' +stu.FIRSTNAME
order by STUDENT_NAME


