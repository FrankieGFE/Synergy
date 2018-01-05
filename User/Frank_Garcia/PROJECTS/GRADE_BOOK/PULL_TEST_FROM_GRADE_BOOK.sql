--declare @ASSESSMENT_NAME varchar(100) = '2015-2016 Senior Retakes EOC ELA III Reading 9 12 V006'
       
select stu.LASTNAME+', ' +stu.FIRSTNAME STUDENT_NAME, stu.STUDENTID
       ,t.TESTNAME
       ,convert(datetime,convert(varchar(11),min(r.RESPONSEDATE))) TEST_DATE
       , SUM(case when r.CORRECT=1 then 1 else 0 end) as NUMBER_CORRECT
       , SUM(case when r.CORRECT=0 then 1 else 0 end) as NUMBER_INCORRECT
       , COUNT(r.id) as NUMBER_OF_QUESTIONS
       ,convert(decimal(6,1), SUM(case when r.CORRECT=1 then 1.0 else 0.0 end) / COUNT(r.ID)*100.0,1) PCT_CORRECT
from rev.EGB_TEST t
       join rev.EGB_TEST_SCHEDULED sch on sch.TESTID = t.id
       join rev.EGB_TEST_STUDENTRESPONSES r on r.SCHEDULEDTESTID = sch.ID 
       join rev.EGB_TEST_STUDENTS ts on ts.STUDENTID = r.STUDENTID and ts.SCHEDULEDTESTID = sch.ID
       join rev.EGB_PEOPLE stu on stu.ID = r.STUDENTID
where ts.COMPLETEDATE is not null
--and t.TESTNAME =  @ASSESSMENT_NAME
--AND STU.STUDENTID = '102974896'
group by stu.LASTNAME+', ' +stu.FIRSTNAME, stu.STUDENTID 
       ,t.TESTNAME
order by stu.LASTNAME+', ' +stu.FIRSTNAME

