EXECUTE AS LOGIN='QueryFileUser'
GO

;with Students
as
(
SELECT
	*
FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from StudentstoMatch12132017.csv')               
)
--select * from Students
,Matched_Students
as
(
select
	s.[Last Name],
	p.LAST_NAME,
	s.[First Name],
	p.FIRST_NAME,
	s.Birthdate,
	p.BIRTH_DATE,
	s.[Age (Report Date)],
	s.[HOH Full Name],
	s.[Unit Address],
	s.[Mailing CSZ],
	s.Ethnicity,
	s.Gender
from
	Students S
left outer join
	rev.rev_person p
on
	s.[Last Name]= p.LAST_NAME
and
	s.[First Name] = p.FIRST_NAME
and
	s.[Birthdate] = p.BIRTH_DATE
)
--select * from Matched_Students
,Student_Details
as
(
select
	m.[Last Name] as LAST_NAME,
	m.[First Name] AS FIRST_NAME,
	m.[Age (Report Date)] AS AGE,
	m.[HOH Full Name] AS HOH_FULL_NAME,
	m.[Unit Address] AS UNIT_ADDRESS,
	m.[Mailing CSZ] AS MAILING_CSZ,
	convert(varchar(10), m.Birthdate, 101) as BIRTHDATE,
	m.Ethnicity AS ETHNICITY,
	m.Gender AS GENDER,
	bs.STUDENT_GU,
	bs.SIS_NUMBER as SYNERGY_STUDENT_ID,
	bs.LAST_NAME as SYNERGY_LAST_NAME,
	bs.FIRST_NAME as SYNERGY_FIRST_NAME,
	convert(varchar(10), bs.BIRTH_DATE, 101)  as SYNERGY_DOB
	
from
	Matched_Students m
left outer  join
	aps.BasicStudent bs
on
	m.LAST_NAME = bs.LAST_NAME
and	
	m.FIRST_NAME = bs.FIRST_NAME
and
	m.BIRTH_DATE = bs.BIRTH_DATE
)
--select * from Student_Details		
,Enrollments
as
(
select
	row_number() over(partition by d.student_gu order by d.student_gu, enter_date desc, LEAVE_DATE DESC) as rn,
	d.STUDENT_GU,
	E.ORGANIZATION_GU,
	O.ORGANIZATION_NAME AS ENROLLED_SCHOOL,
	E.ENTER_DATE,
	E.LEAVE_DATE
from
	Student_Details d
INNER join
	aps.EnrollmentsForYear('A3F9F1FB-4706-49AA-B3A3-21F153966191') e
on
	d.STUDENT_GU = e.STUDENT_GU
LEFT JOIN
	REV.REV_ORGANIZATION O
ON
	E.ORGANIZATION_GU = O.ORGANIZATION_GU
)
--select * from enrollments 
,Enrollment_Summary
as
(
select
	*
from
	Enrollments
where
	rn = 1
)
,Parents
as
(
select
	d.STUDENT_GU,
	p.LAST_NAME + ', ' + p.FIRST_NAME as PARENT_NAME,
	a.[ADDRESS] as MAILING_ADDRESS
from
	Student_Details d
inner join
	rev.EPC_STU_PARENT sp
on
	d.STUDENT_GU = sp.student_gu
inner join
	rev.epc_parent pa
on
	sp.parent_gu = pa.PARENT_GU
inner join
	rev.rev_person p
on
	pa.PARENT_GU = p.PERSON_GU
inner join
	rev.REV_ADDRESS a
on
	p.MAIL_ADDRESS_GU = a.ADDRESS_GU
)
--SELECT * FROM Parents
,Results1
as
(
SELECT
	d.STUDENT_GU,
	d.LAST_NAME,
	d.FIRST_NAME,
	d.AGE,
	d.HOH_FULL_NAME,
	d.UNIT_ADDRESS,
	d.MAILING_CSZ,
	d.BIRTHDATE,
	d.ETHNICITY,
	d.GENDER,
	d.SYNERGY_STUDENT_ID,
	d.SYNERGY_LAST_NAME,
	d.SYNERGY_FIRST_NAME,
	d.SYNERGY_DOB,
	E.ENROLLED_SCHOOL,
	convert(VARCHAR(10), e.ENTER_DATE, 101) AS ENTER_DATE,
	CONVERT(VARCHAR(10), e.LEAVE_DATE, 101) AS LEAVE_DATE
FROM
	ENROLLMENT_Summary E
full OUTER JOIN
	Student_Details D
ON
	E.STUDENT_GU = D.STUDENT_GU
)
,Results2
as
(
select
	r.*,
	p.PARENT_NAME,
	p.MAILING_ADDRESS
from
	Results1 R
full outer join
	Parents P
on
	r.STUDENT_GU = p.STUDENT_GU
)
select * from Results2 