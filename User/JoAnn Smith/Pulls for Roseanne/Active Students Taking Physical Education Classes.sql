/*
 * Revision 1
 * Last Changed By:    JoAnn Smith
 * Last Changed Date:  2/07/17
 * Written by:         JoAnn Smith
 ******************************************************
 Active students taking PE classes (all grades)
 Pull test data for all students taking a physical
 education class in SY 2016
 ******************************************************
 */

;
with PHYSED_CTE
as
(
select
	bs.SIS_NUMBER,
	ped.SCHOOL_NAME,
	sao.COURSE_ID,
	sao.COURSE_TITLE, 
	sao.term_code
from
	aps.PrimaryEnrollmentDetailsAsOf(getdate()) ped
inner join
	aps.ScheduleAsOf(getdate()) sao
	on ped.STUDENT_GU = sao.STUDENT_gu
inner join
	 aps.TermDatesAsOf(getdate()) tda
on 
	tda.ORGANIZATION_GU = sao.ORGANIZATION_GU
	AND sao.TERM_CODE = tda.TermCode
inner join
	aps.BasicStudentWithMoreInfo bs
on	bs.STUDENT_GU = sao.STUDENT_GU
where 
	sao.DEPARTMENT = 'PE'
--SUBJECT_AREA_1 in ('PEMS', 'PE')  or COURSE_ID = 'PE' this works also
and school_code not in ('518', '058', 'TRAN', '188', '591', '022')
)

--select
--	 *
--from
--	 PHYSED_CTE PE
--order by
--	PE.SCHOOL_NAME,
--	pe.SIS_NUMBER

SELECT
	COUNT(PE.SIS_NUMBER) AS [Student Count],
	SCHOOL_NAME as [School Name]
FROM
	PHYSED_CTE pe
GROUP BY
	PE.SCHOOL_NAME



