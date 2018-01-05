--declare @ASSESSMENT_NAME varchar(100) = '2015-2016 Senior Retakes EOC ELA III Reading 9 12 V006'
       
select  stu.LASTNAME+', ' +stu.FIRSTNAME STUDENT_NAME, stu.STUDENTID
       ,t.TESTNAME
	   ,cs.STARS_NAME
       ,convert(date,convert(varchar(11),min(r.RESPONSEDATE))) TEST_DATE
       , SUM(case when r.CORRECT=1 then 1 else 0 end) as NUMBER_CORRECT
       , SUM(case when r.CORRECT=0 then 1 else 0 end) as NUMBER_INCORRECT
       , COUNT(r.id) as NUMBER_OF_QUESTIONS
       ,convert(decimal(6,1), SUM(case when r.CORRECT=1 then 1.0 else 0.0 end) / COUNT(r.ID)*100.0,1) PCT_CORRECT
from rev.EGB_TEST t
       join rev.EGB_TEST_SCHEDULED sch on sch.TESTID = t.id
       join rev.EGB_TEST_STUDENTRESPONSES r on r.SCHEDULEDTESTID = sch.ID 
       join rev.EGB_TEST_STUDENTS ts on ts.STUDENTID = r.STUDENTID and ts.SCHEDULEDTESTID = sch.ID
       join rev.EGB_PEOPLE stu on stu.ID = r.STUDENTID
LEFT JOIN
[RDAVM.APS.EDU.ACTD].ASSESSMENTS.DBO.EOC_CUT_SCORES AS CS
ON T.TESTNAME = CS.ASSESSMENT_NAME
where ts.COMPLETEDATE is not null
--and t.TESTNAME LIKE '%EOC%'
AND T.TESTNAME LIKE '%SUMMER%'
--AND CS.ASSESSMENT_ID BETWEEN 1001 AND 1086
--AND STU.STUDENTID = '102974896'
group by stu.LASTNAME+', ' +stu.FIRSTNAME, stu.STUDENTID 
       ,t.TESTNAME  ,CS.STARS_NAME
--order by CS.STARS_NAME
--ORDER BY stu.LASTNAME, stu.FIRSTNAME


