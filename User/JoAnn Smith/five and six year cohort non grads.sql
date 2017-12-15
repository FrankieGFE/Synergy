/*
JoAnn, please work on this new data pull request right away next.  Using the attached file of State ID numbers (StudentID column),
please match to Synergy and provide a file with the data requested in item 1) below.  

1)	Removing students:
(Some of the data being requested is pulled by report CHS-1401 if you’d like to use it for reference) 
1.	Credits Earned, 
2.	Last SY Primary enrollment (SY, School Name, Enter Date, Grade Level)
3.	Last SY  W/D Code (last enrollment with a Leave Date, include SY, School Name Leave Date, Leave Code and Description)
4.	Expected Grad Year (K12.Student_ExpectedGraduationYear)
5.

Update: 12-4-2017
JoAnn, for Monday please update your script to add the new fields below.
Graduation Date – EPC_STU; GRADUATION_DATE
Graduation Status – EPC_STU; GRADUATION_STATUS
Diploma Type – EPC_STU; DIPLOMA TYPE

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
		'SELECT * from SixYearConsolidatedNonGrads.csv')               
)
--select distinct studentID from Students
,StudentsPlus
as
(
select
	--ROW_NUMBER() OVER(PARTITION BY STUDENTID ORDER BY STUDENTID) AS rn,
	S.DistrictCode,
	cast(S.LocationID as varchar(10)) as LocationID,
	S.StudentID,
	S.LastName,
	S.FirstName,
	S.DOB,
	S.Gender,
	S.Ethnicity,
	S.EverELL,
	S.EverIEP,
	S.FRL,
	--S.Migrant,
	--S.SPED_ReasonCode,
	--S.SPED_Reason,
	S.NumSnapshots,
	S.TotalSnapshots,
	S.Outcome,
	S.[Outcome SchoolYear],
	S.[Outcome Unknown],
	S.[Outcome Desc],
	S.Enter9Grade,
	S.TransferIN10Grade,
	S.transferIN11Grade,
	S.TransferIN12Grade,
	S.LastLocation,
	--S.DualCredit,
	--S.ID,
	st.STUDENT_GU,
	st.EXPECTED_GRADUATION_YEAR,
	CONVERT(VARCHAR(10), st.GRADUATION_DATE,101) AS GRADUATION_DATE,
	LU.VALUE_DESCRIPTION AS GRADUATION_STATUS,
	LU1.VALUE_DESCRIPTION AS DIPLOMA_TYPE,
	st.INIT_NINTH_GRADE_YEAR,
	o.ORGANIZATION_NAME as PED_SCHOOL
from
	Students S
left join
	rev.epc_stu st
on
	S.StudentID = st.STATE_STUDENT_NUMBER
LEFT JOIN
	APS.LookupTable('K12', 'GRADUATION_STATUS') LU
ON
	ST.GRADUATION_STATUS = LU.VALUE_CODE
LEFT JOIN
	APS.LookupTable('K12', 'DIPLOMA_TYPE') AS LU1
ON
	ST.DIPLOMA_TYPE = LU1.VALUE_CODE
LEFT JOIN
	REV.EPC_SCH SCH
ON
	SCH.SCHOOL_CODE = cast(S.LocationID as nvarchar(10))
left join
	rev.rev_organization o
on
	o.ORGANIZATION_gu = sch.ORGANIZATION_GU
)
,StudentsPlusResults
as
(
select
	 *
from
	 StudentsPlus
--where
--	RN = 1
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
--AND
--	SCHOOL_YEAR IN ('2013', '2014', '2015', '2016')
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
--and
--	y.SCHOOL_YEAR in ('2013', '2014', '2015', '2016')
and
	e.enter_date is not null
--and
---- no summer school as primary
--	o.organization_gu != 'F9ED2CBB-D65B-4A59-A4D2-36FCFDC56946'
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
	e.LEAVE_CODE,
	e.LEAVE_DATE,
	LU.VALUE_DESCRIPTION AS WITHDRAWAL_CODE_DESCRIPTION,
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
left join
	aps.LookupTable('K12', 'GRADUATION_STATUS') LU1
ON
	S.GRADUATION_STATUS = LU1.VALUE_CODE
where 
	--ssy.EXCLUDE_ADA_ADM is null
--and
--	y.SCHOOL_YEAR in ('2013', '2014', '2015', '2016')
--and
	e.leave_date is not null 
or
	ssy.SUMMER_WITHDRAWL_DATE is not null
)
--select * from LastSchoolYearWithdrawal where STATE_STUDENT_NUMBER = '100082841'
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

--select * FROM LastSchoolYearWithdrawalResults where state_student_number = '104129945'

,LastSummerSchoolYearResults
as
(
select
	row_number() over(partition by bs.student_gu order by bs.student_gu, ssy.summer_withdrawl_date desc) as RN,
	bs.STUDENT_GU,
	bs.STATE_STUDENT_NUMBER,
	ssy.STUDENT_SCHOOL_YEAR_GU,
	o.ORGANIZATION_NAME,
	o.ORGANIZATION_GU,
	ssy.SUMMER_WITHDRAWL_CODE,
	ssy.SUMMER_WITHDRAWL_DATE,
	CASE
			WHEN SSY.SUMMER_WITHDRAWL_CODE = '52' THEN 'Withdrawal - No Show. Student was pre-enrolled and expected to attend but never showed up. Never came to APS this year.'
			WHEN SSY.SUMMER_WITHDRAWL_CODE = '50' THEN 'Transferred to another APS School.'
			WHEN SSY.SUMMER_WITHDRAWL_CODE = '51' THEN 'Transfer to Non APS School'
			WHEN SSY.SUMMER_WITHDRAWL_CODE = '62' THEN 'Withdrawal - Death'
			ELSE
			lu2.VALUE_DESCRIPTION
	END AS WITHDRAWAL_CODE_DESCRIPTION,

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
	aps.LookupTable('K12.Demographics', 'SUMMER_WITHDRAWAL_CODE') as LU2
ON
	ssy.SUMMER_WITHDRAWL_CODE = lu2.VALUE_CODE
where 
	--ssy.EXCLUDE_ADA_ADM is null
--and
--	y.SCHOOL_YEAR in ('2013', '2014', '2015', '2016')
	ssy.SUMMER_WITHDRAWL_DATE is not null
)
--select * from LastSummerSchoolYearResults where STATE_STUDENT_NUMBER = 104129945
,LastSummerSchoolWithdrawalFinalResults
as
(
select
	*
from
	LastSummerSchoolYearResults
where
	rn = 1
)
,
StudentWithdrawalTracking
as
(
select
	row_number() over(partition by t.student_gu order by t.student_gu, RELEASE_DATE desc) as RN,
	S.STUDENT_GU,
	s.studentID,
	t.RELEASE_DATE,
	t.SCHOOL_NON_DISTRICT_GU,
	n.NAME as NON_DISTRICT_SCHOOL_NAME,
	t.PERSON_RELEASED_TO,
	lu.[VALUE_DESCRIPTION] as PERSON_TITLE,
	lu1.VALUE_DESCRIPTION as RELEASE_PURPOSE
from
	StudentsPlus S
left join
	rev.EPC_STU_REQUEST_TRACKING T
on
	s.STUDENT_GU = t.STUDENT_GU
inner join
	rev.EPC_SCH_NON_DST N
on
	t.SCHOOL_NON_DISTRICT_GU = n.SCHOOL_NON_DISTRICT_GU
left join
	aps.LookupTable('K12.CourseHistoryInfo', 'PERSON_TITLE') AS lu
ON
	t.PERSON_title = lu.VALUE_CODE
left join
	aps.LookupTable('k12.CourseHistoryInfo', 'RELEASE_PURPOSE') AS LU1
on
	t.RELEASE_PURPOSE = lu1.VALUE_CODE
)
,ReleaseResults
as
(
select
	*
from
	StudentWithdrawalTracking t
where
	rn = 1
)
--select * from ReleaseResults 
	
--select * from LastSummerSchoolWithdrawalFinalResults where STATE_STUDENT_NUMBER = 104129945
select
	sr.DistrictCode,
	sr.LocationID,
	sr.PED_SCHOOL as SCHOOL_NAME,
	sr.StudentID,
	sr.LastName,
	sr.FirstName,
	sr.DOB,
	sr.Gender,
	sr.Ethnicity,
	sr.EverELL,
	sr.EverIEP,
	sr.FRL,
	--sr.Migrant,
	--sr.SPED_ReasonCode,
	--sr.SPED_Reason,
	sr.NumSnapshots,
	sr.TotalSnapshots,
	sr.Outcome,
	sr.[Outcome SchoolYear],
	sr.[Outcome Unknown],
	sr.[Outcome Desc],
	sr.Enter9Grade,
	sr.TransferIN10Grade,
	sr.transferIN11Grade,
	sr.TransferIN12Grade,
	sr.LastLocation,
	--sr.DualCredit,
	--sr.ID,
	sr.EXPECTED_GRADUATION_YEAR,
	convert(varchar(10), sr.GRADUATION_DATE,101) as GRADUATION_DATE,
	sr.GRADUATION_STATUS,
	SR.DIPLOMA_TYPE,
	sr.INIT_NINTH_GRADE_YEAR,
	tc.TOTAL_CREDITS_EARNED,
	lp.SCHOOL_YEAR AS LAST_PRIMARY_YEAR,
	lp.ORGANIZATION_NAME AS LAST_PRIMARY_SCHOOL,
	CONVERT(VARCHAR(10), lp.ENTER_DATE, 101)  AS LAST_PRIMARY_ENTER_DATE,
	lu.VALUE_DESCRIPTION as LAST_PRIMARY_GRADE,
	case
		when lss.SUMMER_WITHDRAWL_DATE > lsy.LEAVE_DATE then lss.SUMMER_WITHDRAWL_DATE
		when lsy.LEAVE_DATE > lss.SUMMER_WITHDRAWL_DATE then lsy.LEAVE_DATE
		when lsy.LEAVE_DATE is null and SUMMER_WITHDRAWL_DATE IS NOT NULL THEN LSS.SUMMER_WITHDRAWL_DATE
		when lsy.LEAVE_DATE = SUMMER_WITHDRAWL_DATE then LSS.SUMMER_WITHDRAWL_DATE
		when lsy.LEAVE_DATE is not null and SUMMER_WITHDRAWL_DATE IS NULL THEN LSY.LEAVE_DATE
	end AS LEAVE_DATE,
		case
		when lss.SUMMER_WITHDRAWL_DATE > lsy.LEAVE_DATE then lss.SUMMER_WITHDRAWL_CODE
		when lsy.LEAVE_DATE > LSS.SUMMER_WITHDRAWL_DATE THEN LSY.LEAVE_CODE
		when lsy.LEAVE_DATE is null and lss.SUMMER_WITHDRAWL_DATE is not null then LSS.SUMMER_WITHDRAWL_CODE
		when lsy.LEAVE_DATE = SUMMER_WITHDRAWL_DATE then LSS.SUMMER_WITHDRAWL_CODE
		when lsy.LEAVE_DATE is not null and SUMMER_WITHDRAWL_DATE IS NULL THEN LSY.LEAVE_CODE
		END AS LEAVE_CODE,
	 case
		when lss.SUMMER_WITHDRAWL_DATE > lsy.LEAVE_DATE then lss.WITHDRAWAL_CODE_DESCRIPTION
		when lsy.LEAVE_DATE > lss.SUMMER_WITHDRAWL_DATE then lsy.WITHDRAWAL_CODE_DESCRIPTION
		when lsy.LEAVE_DATE is null and SUMMER_WITHDRAWL_DATE IS NOT NULL THEN LSS.WITHDRAWAL_CODE_DESCRIPTION
		when lsy.LEAVE_DATE = SUMMER_WITHDRAWL_DATE then lss.WITHDRAWAL_CODE_DESCRIPTION
		when lsy.LEAVE_DATE is not null and SUMMER_WITHDRAWL_DATE IS NULL THEN LSY.WITHDRAWAL_CODE_DESCRIPTION

	end as LEAVE_DESCRIPTION,
	CONVERT(VARCHAR(10), R.RELEASE_DATE, 101) AS RELEASE_DATE,
	R.NON_DISTRICT_SCHOOL_NAME,
	R.PERSON_RELEASED_TO,
	R.PERSON_TITLE,
	R.RELEASE_PURPOSE	
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
left join
	LastSummerSchoolWithdrawalFinalResults LSS
ON
	SR.STUDENT_GU = LSS.STUDENT_GU
left join
	ReleaseResults r
ON
	SR.STUDENT_GU = R.STUDENT_GU
LEFT JOIN
	APS.LookupTable('K12', 'Grade') LU
on
	lp.grade = lu.VALUE_CODE
order by
	sr.LastName, sr.FirstName
--WHERE
--	SR.STUDENTID = 104129945
--	--SR.STUDENTID = 103643714
--	--SR.STUDENTID = 1028080
--SR.STUDENTID = 614454965
--sr.STUDENTID = 725741946