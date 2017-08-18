/*
Delete summer school student enrollments
Written by:	JoAnn Smith
Date:		7/17/2017

--Please proceed with developing a script to delete the 2016.S enrollment for the students in the attached file. 
 Some of these students may already have data in 2016.S (other summer classes, etc.) so we may not be able to delete them,
  but set those aside and we can evaluate how to remove them.  Test this in Training also.
*/


--REV.EPC_STU_ENROLL_ACTIVITY - ENROLLMENT_GU
--rev.EPC_STU_ATT_DAILY -ENROLLMENT_GU 
--REV.EPC_STU_ENROLL - ENROLLMENT_GU
--REV.EPC_STU_YR - STU_SCHOOL_YEAR_GU
--REV.EPC_STU_CLASS - STUDENT_SCHOOL_YEAR_GU
--rev.EPC_STU_SCH_YR - STUDENT_SCHOOL_YEAR_GU


--EXECUTE AS LOGIN='QueryFileUser'
--GO


/*use enrollment_gu to get enrollment_activity_gu to delete records in rev.epc_stu_enroll_activity */
BEGIN TRAN

;with Activity
as
(select 
	r.student_school_year_gu,
	e.enrollment_gu,
	a.ENROLLMENT_ACTIVITY_GU
from dbo.FinalSummerEnrollmentsToDelete r
inner join
	rev.EPC_STU_ENROLL e
on
	e.STUDENT_SCHOOL_YEAR_GU = r.student_school_year_gu
inner join
	rev.epc_stu_enroll_activity a
on
	e.enrollment_gu = a.enrollment_gu
)
--select * from Activity

/* delete enrollment activity records */

DELETE FROM REV.EPC_STU_ENROLL_ACTIVITY
WHERE ENROLLMENT_ACTIVITY_GU IN
(SELECT ENROLLMENT_ACTIVITY_GU
from Activity)


/* use daily_attend_gu to delete record from epc_stu_att_period */

;with Period_Attend
as
(select DISTINCT
	e.ENROLLMENT_GU,
	period_attend_gu,
	p.daily_attend_gu,
	r.STUDENT_SCHOOL_YEAR_GU
from 
	dbo.FinalSummerEnrollmentsToDelete r
inner join
	rev.EPC_STU_ENROLL e
on
	e.STUDENT_SCHOOL_YEAR_GU = r.student_school_year_gu
inner join
	rev.epc_stu_att_daily a
on
	e.enrollment_gu = a.enrollment_gu
inner join
	rev.epc_stu_att_period p
on
	a.daily_attend_gu = p.daily_attend_gu
)

--select * from Period_Attend
DELETE FROM REV.EPC_STU_ATT_PERIOD
WHERE
PERIOD_ATTEND_GU IN
(SELECT PERIOD_ATTEND_GU
FROM Period_Attend)


/* use daily_attend_gu to delete records in rev.epc_att_daily */

;with Activity2
as
(select distinct
	r.student_school_year_gu,
	e.enrollment_gu,
	a.DAILY_ATTEND_GU
from
	dbo.FinalSummerEnrollmentsToDelete r
inner join
	rev.EPC_STU_ENROLL e
on
	e.STUDENT_SCHOOL_YEAR_GU = r.student_school_year_gu
inner join
	rev.epc_stu_att_daily a
on
	e.enrollment_gu = a.enrollment_gu
)
--select * from Activity2

DELETE FROM REV.EPC_STU_ATT_DAILY
WHERE
DAILY_ATTEND_GU IN
(SELECT DAILY_ATTEND_GU
FROM Activity2)
	

/*use student_school_year_gu to get enrollment_gu to delete records in rev.epc_stu_enroll */

;with Enroll
as
(select
	ENROLLMENT_GU
from
	rev.epc_stu_enroll
where student_school_year_gu in
(select distinct
	student_school_year_gu
from 
	dbo.FinalSummerEnrollmentsToDelete r)
)
--select * from Enroll

DELETE FROM REV.EPC_STU_ENROLL
WHERE ENROLLMENT_GU IN
(SELECT ENROLLMENT_GU
from Enroll)


/*use student_school_year_gu to delete records in rev.epc_stu_yr */

;with StudentYear
as
(
	select
		y.STU_YEAR_GU,
		y.STU_SCHOOL_YEAR_GU
from 
	dbo.FinalSummerEnrollmentsToDelete r
inner join
	rev.epc_stu_yr y
on
	y.STU_SCHOOL_YEAR_GU = r.student_school_year_gu
)
--select * from StudentYear
	
DELETE FROM REV.EPC_STU_YR
WHERE STU_YEAR_GU IN
(SELECT STU_YEAR_GU
FROM StudentYear)

-- /* get stu_sch_yr_grd_prd_gu to delete records in rev.stu_sch_yr_grd_prd */
--;with studentYearGradePrd
--as
--(
--	select
--		g.STU_SCHOOL_YEAR_GRD_GU,
--		g.STUDENT_SCHOOL_YEAR_GU,
--		p.STU_SCHOOL_YEAR_GRD_PRD_GU
--		--t1.student_school_year_gu
--from OPENROWSET (
--	'Microsoft.ACE.OLEDB.12.0', 
--		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
--		'SELECT * from FeesToDelete.csv'                ) AS [T1]
--inner join
--	rev.epc_stu_sch_yr_grd g
--on
--	g.STUDENT_SCHOOL_YEAR_GU  = t1.student_school_year_gu
--inner join
--	rev.epc_stu_sch_yr_grd_prd p
--on
--	g.STU_SCHOOL_YEAR_GRD_GU = p.STU_SCHOOL_YEAR_GRD_GU
--) 

--DELETE FROM REV.EPC_STU_SCH_YR_GRD_PRD
--WHERE STU_SCHOOL_YEAR_GRD_GU IN
--(SELECT STU_SCHOOL_YEAR_GRD_PRD_GU
--FROM studentYearGradePrd)  


--/* get stu_school_year_grd_gu to delete records in rev.epc_stu_sch_yr_grd */

--;with studentYearGrade
--as
--(
--	select
--		g.STU_SCHOOL_YEAR_GRD_GU,
--		g.STUDENT_SCHOOL_YEAR_GU,
--		p.STU_SCHOOL_YEAR_GRD_PRD_GU
--		--t1.student_school_year_gu
--from OPENROWSET (
--	'Microsoft.ACE.OLEDB.12.0', 
--		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
--		'SELECT * from FeesToDelete.csv'                ) AS [T1]
--inner join
--	rev.epc_stu_sch_yr_grd g
--on
--	g.STUDENT_SCHOOL_YEAR_GU  = t1.student_school_year_gu
--inner join
--	rev.epc_stu_sch_yr_grd_prd p
--on
--	g.STU_SCHOOL_YEAR_GRD_GU = p.STU_SCHOOL_YEAR_GRD_GU
--)

----select * from studentYearGrade

--DELETE FROM REV.EPC_STU_SCH_YR_GRD
--WHERE STU_SCHOOL_YEAR_GRD_GU IN
--(SELECT STU_SCHOOL_YEAR_GRD_GU
--FROM studentYearGrade)
 
           
--/*get student_school_year_gu from the file to delete records in rev.epc_stu_sch_yr*/

DELETE FROM REV.EPC_STU_SCH_YR 
WHERE STUDENT_SCHOOL_YEAR_GU IN
(SELECT distinct STUDENT_SCHOOL_YEAR_GU 
from dbo.FinalSummerEnrollmentsToDelete)

/*use student_school_year_gu to delete records in rev.epc_stu_class */


DELETE FROM REV.EPC_STU_CLASS
WHERE STUDENT_SCHOOL_YEAR_GU IN
(SELECT distinct STUDENT_SCHOOL_YEAR_GU 
from dbo.FinalSummerEnrollmentsToDelete)
--ROLLBACK

COMMIT













