/*
JoAnn, please work on this new data pull request right away next.  Using the attached file of State ID numbers (StudentID column),
please match to Synergy and provide a file with the data requested in item 1) below.  

1)	Removing students:
(Some of the data being requested is pulled by report CHS-1401 if you’d like to use it for reference) 
1.	Credits Earned, 
2.	Last SY Primary enrollment (SY, School Name, Enter Date, Grade Level)
3.	Last SY  W/D Code (last enrollment with a Leave Date, include SY, School Name Leave Date, Leave Code and Description)
4.	Expected Grad Year (K12.Student_ExpectedGraduationYear)
5.	Ninth Grade Entry Year (Other Info tab: K12.Student_InitialNinthGradeYear)

*/

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
		'SELECT * from FourYearConsolidatedOutcome.csv')               
)
--select distinct studentID from Students
,StudentsPlus
as
(
select
	ROW_NUMBER() OVER(PARTITION BY STUDENTID ORDER BY STUDENTID) AS rn,
	S.*,
	st.STUDENT_GU,
	st.EXPECTED_GRADUATION_YEAR,
	st.INIT_NINTH_GRADE_YEAR
from
	Students S
left join
	rev.epc_stu st
on
	S.StudentID = st.STATE_STUDENT_NUMBER
)
,StudentsPlusResults
as
(
select
	 *
from
	 StudentsPlus
where
	RN = 1
)
--SELECT * FROM StudentsPlusResults
,CreditsEarned
as
(
select
	 bs.STUDENT_GU,
	 S.STUDENTID as STATE_STUDENT_NUMBER,
	 CREDIT_COMPLETED,
	 COURSE_ID,
	 COURSE_HISTORY_TYPE,
	 TERM_CODE,
	 SCHOOL_YEAR, 
	 REPEAT_TAG_GU

from StudentsPlus S
LEFT join
	aps.BasicStudent bs
on
	bs.STATE_STUDENT_NUMBER = s.STUDENTID
full outer JOIN
	REV.EPC_STU_CRS_HIS CRS
ON
	CRS.STUDENT_GU = BS.STUDENT_GU
WHERE
	COURSE_HISTORY_TYPE = 'HIGH'
AND
	REPEAT_TAG_GU IS NULL OR REPEAT_TAG_GU != '92E81AF7-962A-4D66-ADF9-5FD3FD88FA7D'
AND
	SCHOOL_YEAR IN ('2013', '2014', '2015', '2016')
GROUP BY 
	BS.STUDENT_GU,
	S.STUDENTID,
	crs.COURSE_HISTORY_TYPE,
	CREDIT_COMPLETED,
	COURSE_ID,
	TERM_CODE,
	SCHOOL_YEAR,
	REPEAT_TAG_GU

)
,TotalCreditsEarned
as
(
SELECT
	STUDENT_GU,
	STATE_STUDENT_NUMBER,
	sum(CREDIT_COMPLETED) as TOTAL_CREDITS_EARNED
from
	 CreditsEarned
GROUP BY
	STUDENT_GU,
	STATE_STUDENT_NUMBER
)

--SELECT * FROM TotalCreditsEarned 
--ORDER BY STATE_STUDENT_NUMBER
,LastPrimaryEnrollment
as
(
select
	row_number() over(partition by bs.student_gu order by bs.student_gu, e.enter_date desc) as RN,
	bs.STUDENT_GU,
	bs.STATE_STUDENT_NUMBER,
	ssy.STUDENT_SCHOOL_YEAR_GU,
	o.ORGANIZATION_NAME,
	o.ORGANIZATION_GU,
	e.enter_date,
	e.GRADE,
	y.SCHOOL_YEAR,
	ssy.EXCLUDE_ADA_ADM as ssy_excl
from
	StudentsPlusResults s
left join
	aps.BasicStudent bs
on
	s.STUDENTID = bs.STATE_STUDENT_NUMBER
left join
	rev.epc_stu_sch_yr ssy
on
	bs.student_gu = ssy.student_gu
left join
	rev.epc_stu_enroll e
on
	ssy.STUDENT_SCHOOL_YEAR_GU = e.STUDENT_SCHOOL_YEAR_GU
inner join
	rev.REV_ORGANIZATION_YEAR oy
on
	oy.ORGANIZATION_YEAR_GU = ssy.orgANIZATION_YEAR_GU
inner join
	rev.rev_organization o
on
	o.ORGANIZATION_GU = oy.ORGANIZATION_GU
inner join
	rev.REV_YEAR y
on
	oy.YEAR_GU = y.YEAR_GU
where 
	ssy.EXCLUDE_ADA_ADM is null
and
	y.SCHOOL_YEAR in ('2013', '2014', '2015', '2016')
and
	e.enter_date is not null
and
-- no summer school as primary
	o.organization_gu != 'F9ED2CBB-D65B-4A59-A4D2-36FCFDC56946'
)
,
LastPrimaryEnrollmentResults
as
(
select
	*
from
	LastPrimaryEnrollment
where
	rn = 1
)
--select * from LastPrimaryEnrollmentResults
--order by STATE_STUDENT_NUMBER
,LastSchoolYearWithdrawal
as
(
select
	row_number() over(partition by bs.student_gu order by bs.student_gu, e.enter_date desc) as RN,
	bs.STUDENT_GU,
	bs.STATE_STUDENT_NUMBER,
	ssy.STUDENT_SCHOOL_YEAR_GU,
	o.ORGANIZATION_NAME,
	o.ORGANIZATION_GU,
	e.enter_date,
	e.leave_date,
	e.LEAVE_CODE,
	LU.VALUE_DESCRIPTION AS DESCRIPTION,
	y.SCHOOL_YEAR,
	ssy.EXCLUDE_ADA_ADM as ssy_excl
from
	StudentsPlus s
left join
	aps.BasicStudent bs
on
	s.STUDENTID = bs.STATE_STUDENT_NUMBER
left join
	rev.epc_stu_sch_yr ssy
on
	bs.student_gu = ssy.student_gu
left join
	rev.epc_stu_enroll e
on
	ssy.STUDENT_SCHOOL_YEAR_GU = e.STUDENT_SCHOOL_YEAR_GU
inner join
	rev.REV_ORGANIZATION_YEAR oy
on
	oy.ORGANIZATION_YEAR_GU = ssy.orgANIZATION_YEAR_GU
inner join
	rev.rev_organization o
on
	o.ORGANIZATION_GU = oy.ORGANIZATION_GU
inner join
	rev.REV_YEAR y
on
	oy.YEAR_GU = y.YEAR_GU
left join
	aps.LookupTable('K12.Enrollment', 'LEAVE_CODE') LU
ON
	E.LEAVE_CODE = LU.VALUE_CODE
where 
	ssy.EXCLUDE_ADA_ADM is null
and
	y.SCHOOL_YEAR in ('2013', '2014', '2015', '2016')
and
	e.leave_date is not null
)
--select * from LastSchoolYearWithdrawal	
,LastSchoolYearWithdrawalResults
as
(
select
	*
from
	LastSchoolYearWithdrawal
where
	rn = 1
)

--select * FROM LastSchoolYearWithdrawalResults
select
	sr.DistrictCode,
	sr.LocationID,
	sr.StudentID,
	sr.LastName,
	sr.FirstName,
	sr.DOB,
	sr.Gender,
	sr.Ethnicity,
	sr.EverELL,
	sr.EverIEP,
	sr.FRL,
	sr.Migrant,
	sr.SPED_ReasonCode,
	sr.SPED_Reason,
	sr.NumSnapshots,
	sr.TotalSnapshots,
	sr.Outcome,
	sr.[Outcome SchoolYear],
	sr.[Outcome Unknown],
	sr.[Outcome Desc],
	sr.Entry9thGrade,
	sr.Entry10thGrade,
	sr.Entry11thGrade,
	sr.Entry12thGrade,
	sr.LastLocation,
	sr.DualCredit,
	sr.ID,
	sr.EXPECTED_GRADUATION_YEAR,
	sr.INIT_NINTH_GRADE_YEAR,
	tc.TOTAL_CREDITS_EARNED,
	lp.SCHOOL_YEAR AS LAST_PRIMARY_YEAR,
	lp.ORGANIZATION_NAME AS LAST_PRIMARY_SCHOOL,
	lp.ENTER_DATE AS LAST_PRIMARY_ENTER_DATE,
	lu.VALUE_DESCRIPTION as LAST_PRIMARY_GRADE,
	lsy.SCHOOL_YEAR as WITHDRAWAL_SCHOOL_YEAR,
	lsy.ORGANIZATION_NAME as WITHDRAWAL_SCHOOL,
	lsy.LEAVE_DATE AS WITHDRAWAL_DATE,
	lsy.LEAVE_CODE AS WITHDRAWAL_CODE,
	lsy.DESCRIPTION AS WITHDRAWAL_DESCRIPTION
from
	StudentsPlusResults sr
left join
	TotalCreditsEarned tc
on
	sr.student_gu = tc.STUDENT_GU
left hash join
	LastPrimaryEnrollmentResults lp
on
	sr.STUDENT_GU = lp.STUDENT_GU
left hash join
	LastSchoolYearWithdrawalResults lsy
on
	sr.STUDENT_GU = lsy.STUDENT_GU
LEFT JOIN
	APS.LookupTable('K12', 'Grade') LU
on
	lp.grade = lu.VALUE_CODE

