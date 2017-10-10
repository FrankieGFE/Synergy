begin tran

;with LessThanThree
as
(
select
	s.STUDENT_GU,
	s.SIS_NUMBER,
	s.ENROLL_LESS_THREE_OVR
from
	rev.epc_stu s
where
	s.enroll_less_three_ovr = 'Y'
)

--select * from LessThanThree where SIS_NUMBER = 100001981
,Enrollments
as
(
select
	row_number() over(partition by sed.SIS_NUMBER order by ltt.SIS_NUMBER, sed.school_year desc) as RN,
	sed.STUDENT_GU,
	sed.SIS_NUMBER,
	bs.LAST_NAME,
	bs.FIRST_NAME,
	sed.SCHOOL_NAME,
	sed.SCHOOL_CODE,
	sed.SCHOOL_YEAR,
	ltt.ENROLL_LESS_THREE_OVR
from
	aps.StudentEnrollmentDetails sed
inner join
	LessThanThree ltt
on
	sed.STUDENT_GU = ltt.STUDENT_GU
inner join
	aps.BasicStudentWithMoreInfo bs
on
	ltt.STUDENT_GU = bs.STUDENT_GU
)

--select student_gu from results

update rev.ud_stu
set THREE_YEARS_US_SCHOOLS = 'Y'
WHERE
STUDENT_GU IN
(
select student_gu from Enrollments
where RN = 1)

commit

(110841 row(s) affected)






