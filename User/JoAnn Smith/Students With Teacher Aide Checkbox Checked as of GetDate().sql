/*
Andy, Patti and I need a list of students who have “Teacher Aide” checkbox on their schedule of classes.
BO: K12-ScheduleInfo-ClassStudent-TeacherAide.

*/
;WITH TEACHER_AIDES
AS
(
select
	ROW_NUMBER() OVER (PARTITION BY S.SIS_NUMBER ORDER BY S.ORGANIZATION_NAME, S.SIS_NUMBER) AS RN,
	s.STUDENT_GU,
	s.STUDENT_SCHOOL_YEAR_GU,
	s.STUDENT_CLASS_GU,
	bs.SIS_NUMBER,
	bs.LAST_NAME,
	bs.FIRST_NAME,
	s.ORGANIZATION_NAME AS SCHOOL_NAME,
	s.COURSE_ID,
	s.COURSE_TITLE,
	s.SECTION_ID,
	c.TEACHER_AIDE
from
	aps.ScheduleAsOf(getdate()) s
LEFT join
	aps.BasicStudent bs
on
	s.STUDENT_GU = bs.STUDENT_GU
left join
	rev.epc_stu_class c
on
	s.STUDENT_SCHOOL_YEAR_GU = c.STUDENT_SCHOOL_YEAR_GU
and
	c.STUDENT_CLASS_GU = s.STUDENT_CLASS_GU
where
	c.TEACHER_AIDE = 'Y'

)
SELECT * FROM TEACHER_AIDES WHERE RN = 1
order by
	SCHOOL_NAME, SIS_NUMBER