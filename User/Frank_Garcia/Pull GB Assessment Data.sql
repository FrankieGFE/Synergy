select stu.LASTNAME, stu.FIRSTNAME 
	,t.TESTNAME
	, sch.STARTDATE
	--,convert(datetime,convert(varchar(11),min(r.RESPONSEDATE))) TestDate
	, sum(q.points) TOTAL_POSSIBLE
	, sum(r.POINTS) TOTAL_CORRECT
	, sum(r.POINTS)/sum(q.points) PCT_CORRECT
	--,convert(decimal(6,1), SUM(case when r.CORRECT=1 then 1.0 else 0.0 end) / COUNT(r.ID)*100.0,1) 'P-Value'
from REV.EGB_TEST_ITEMBANK ib
	join REV.EGB_TEST_QUESTIONS q on q.ITEMBANKID = ib.id
	join REV.EGB_TEST t on t.ID = q.TESTID
	join REV.EGB_TEST_SCHEDULED sch on sch.TESTID = t.id
	join REV.EGB_TEST_STUDENTRESPONSES r on r.SCHEDULEDTESTID = sch.ID
	join REV.EGB_TEST_ITEMSTANDARDS ist on ist.ITEMBANKID = ib.ID
	join REV.EGB_STANDARDS_NEW st on st.ID = ist.STANDARDID
	join REV.EGB_SUBJECTS subj on subj.ID = st.SUBJECTID	
	join REV.EGB_PEOPLE stu on stu.ID = r.STUDENTID
WHERE T.TESTNAME = 'SS Grade 4 Form 1'
group by stu.LASTNAME, stu.FIRSTNAME, sch.STARTDATE 
	,t.TESTNAME
order by stu.LASTNAME, stu.FIRSTNAME 
	,min(r.RESPONSEDATE)
	,t.TESTNAME


select * from rev.egb_test
