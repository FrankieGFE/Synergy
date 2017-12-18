; with Ninth_Graders
as
(
select
	row_number() over(partition by d.student_gu order by d.student_gu, d.enter_date desc) as rn,
	d.STUDENT_GU,
	d.SIS_NUMBER,
	bs.FIRST_NAME,
	bs.LAST_NAME,
	ENTER_CODE,
	SCHOOL_NAME as NINTH_GRADE_SCHOOL_NAME,
	SCHOOL_YEAR AS NINTH_GRADE_SCHOOL_YEAR,
	GRADE
from
	aps.StudentEnrollmentDetails d
inner join
	aps.BasicStudent bs
on	
	d.STUDENT_GU = bs.STUDENT_GU
where
	GRADE = '09'
and 
	EXCLUDE_ADA_ADM is null
)
,N_Results
as
(
select
	 *
from
	Ninth_Graders
where
	rn = 1
)

--SELECT * FROM Is_Active where student_gu = '4DADB940-8A51-4D40-9534-0000279F0E6B'
,Course_History
as
(
select
	 row_number() over(partition by h.student_gu order by h.student_gu, h.school_year) as rn,
	 a.STUDENT_GU,
	 a.SIS_NUMBER,
	 H.SCHOOL_YEAR AS CHS_NINTH_GRADE_YEAR,
	 h.SCHOOL_YEAR,
	 h.COURSE_TITLE,
	 h.GRADE as CHS_GRADE
from
	N_Results a
LEFT join
	rev.epc_stu_crs_his h
on
	h.STUDENT_GU = a.STUDENT_GU
where
	h.grade = '190'
)
--select *  from Course_History where student_gu = '04F2B9EA-2083-402F-9103-5E98A945C869'
,Course_History_Results
as
(
select
	*
	
from
	Course_History
WHERE
	RN = 1
)
--SELECT * FROM Course_History_Results where student_gu = 'A2F12E19-4341-415D-AB65-000D80575FE0'
,StudentsAndCourses
as
(
select
	n.STUDENT_GU,	
	n.SIS_NUMBER,
	n.FIRST_NAME,
	n.LAST_NAME,
	n.GRADE,
	c.CHS_NINTH_GRADE_YEAR,
	N.NINTH_GRADE_SCHOOL_NAME,
	N.NINTH_GRADE_SCHOOL_YEAR
from
	N_Results n
left join
	Course_History_Results c
on
	c.STUDENT_GU = n.STUDENT_GU
)
--select * from StudentsAndCourses
,Results
as
(
select
	row_number() over (partition by s.SIS_NUMBER order by s.SIS_NUMBER) as rn,
	s.STUDENT_GU,
	--E.ORGANIZATION_GU,
	case 
		when E.ORGANIZATION_GU is null THEN 'N'
		ELSE
		'Y'
	end as ACTIVE_STUDENT,
	S.SIS_NUMBER,
	S.FIRST_NAME,
	S.LAST_NAME,
	ISNULL(o.ORGANIZATION_NAME, '') AS SCHOOL_NAME,
	ISNULL(lu.VALUE_DESCRIPTION, '') AS GRADE,
	S.CHS_NINTH_GRADE_YEAR,
	NINTH_GRADE_SCHOOL_YEAR,
	NINTH_GRADE_SCHOOL_NAME,
	EXPECTED_GRADUATION_YEAR,
	case
		when s.CHS_NINTH_GRADE_YEAR is null and NINTH_GRADE_SCHOOL_YEAR is not null then 'VERIFY'
		when s.CHS_NINTH_GRADE_YEAR IS NOT NULL AND NINTH_GRADE_SCHOOL_YEAR IS NOT NULL AND s.CHS_NINTH_GRADE_YEAR <> NINTH_GRADE_SCHOOL_YEAR THEN 'VERIFY'
		ELSE
		'OK' 
	END AS [DISCREPANCY?]
from
	StudentsAndCourses s
left join
	aps.EnrollmentsForYear('A3F9F1FB-4706-49AA-B3A3-21F153966191') e
on
	s.STUDENT_GU = e.STUDENT_GU
left join
	rev.rev_organization o
on
	e.ORGANIZATION_GU = o.ORGANIZATION_GU
left join
	rev.epc_stu st
on
	s.STUDENT_GU = st.STUDENT_GU
LEFT JOIN
	APS.LookupTable('K12', 'Grade') as LU
on
	e.GRADE = lu.VALUE_CODE
where 
	e.EXCLUDE_ADA_ADM is null
)
,Actives
as
(
select
	*
from
	Results r
where
	r.ACTIVE_STUDENT = 'Y'
)
,ActivesResults
as
(
select
	*
from
	Actives
where
	rn = 1
)
--select * from Actives
--order by sis
,Inactives
as
(
select
	 *
from
	Results 
where
	 rn = 1
and
	SCHOOL_NAME = ''
)
--select * from Inactives
,InactivesWithSchoolName
as
(
select
	row_number() over(partition by i.student_gu order by i.student_gu, enter_date desc) as rn,
	i.STUDENT_GU,
	I.ACTIVE_STUDENT,
	i.SIS_NUMBER,
	I.FIRST_NAME,
	I.LAST_NAME,
	s.SCHOOL_NAME,
	s.GRADE,
	I.CHS_NINTH_GRADE_YEAR,
	i.NINTH_GRADE_SCHOOL_YEAR,
	I.NINTH_GRADE_SCHOOL_NAME,
	I.EXPECTED_GRADUATION_YEAR,
	case
		when i.CHS_NINTH_GRADE_YEAR is null and NINTH_GRADE_SCHOOL_YEAR is not null then 'VERIFY'
		when i.CHS_NINTH_GRADE_YEAR IS NOT NULL AND NINTH_GRADE_SCHOOL_YEAR IS NOT NULL AND I.CHS_NINTH_GRADE_YEAR <> NINTH_GRADE_SCHOOL_YEAR THEN 'VERIFY'
		ELSE
		'OK' 
	END AS [DISCREPANCY?]
from
	Inactives i
inner join
	aps.StudentEnrollmentDetails s
on
	i.STUDENT_GU = s.STUDENT_GU
where
	EXCLUDE_ADA_ADM is null
)
--select * from InactivesWithSchoolName where SIS_NUMBER = 100136241
,InactivesResults
as
(
select
	*
from
	InactivesWithSchoolName i
where
	rn = 1
)
,FinalResults	
as
(
select	
	*
from
	ActivesResults A
UNION ALL
SELECT
	*
FROM
	InactivesResults i
)
select * from FinalResults 
order by SIS_NUMBER
