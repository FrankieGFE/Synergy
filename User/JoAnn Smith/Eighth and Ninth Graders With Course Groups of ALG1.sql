;WITH Students
as
(
select
	bs.STUDENT_GU,
	BS.SIS_NUMBER,
	bs.LAST_NAME,
	bs.FIRST_NAME,
	lu.VALUE_DESCRIPTION as GRADE,
	O.ORGANIZATION_NAME AS SCHOOL
from
	aps.PrimaryEnrollmentsAsOf(getdate()) pe
inner join
	aps.BasicStudent bs
on
	pe.STUDENT_GU = bs.STUDENT_GU
inner join
	rev.REV_ORGANIZATION_YEAR oy
on
	pe.ORGANIZATION_YEAR_GU = oy.ORGANIZATION_YEAR_GU
inner join
	rev.rev_organization o
on
	o.ORGANIZATION_GU = oy.ORGANIZATION_GU
LEFT JOIN
	APS.LookupTable('K12', 'Grade') lu
on
	pe.grade = lu.VALUE_CODE
where
	pe.grade in ('180', '190')
)
--select * from Students
,Classes
as
(
select
	s.SIS_NUMBER,
	S.LAST_NAME,
	S.FIRST_NAME,
	S.GRADE,
	S.SCHOOL,
	s.STUDENT_GU,
	sd.COURSE_GU,
	sd.COURSE_ID,
	sd.COURSE_TITLE,
	sd.DEPARTMENT
from
	Students S
left join
	aps.ScheduleDetailsAsOf(getdate()) sd
on
	S.STUDENT_GU = sd.STUDENT_GU
where
	department = 'Math'
)
,Results
as
(
select
	ROW_NUMBER() OVER(PARTITION BY SIS_NUMBER, [GROUP] ORDER BY SIS_NUMBER) AS RN,
	SIS_NUMBER,
	FIRST_NAME,
	LAST_NAME,
	GRADE,
	SCHOOL,
	COURSE_ID,
	COURSE_TITLE,
	[GROUP] AS COURSE_GROUP
from
	Classes C
inner join
	rev.ud_crs_group cg
on
	c.COURSE_GU = cg.COURSE_GU
and
	[group] in ('ALG 1 S1', 'ALG 1 S2')
)
select
	distinct (SIS_NUMBER)
from
	Results
where
--where rn = 1
--and
course_group = 'alg 1 s1'
group by SIS_NUMBER
ORDER BY SIS_NUMBER