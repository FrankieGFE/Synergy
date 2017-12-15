


--DECLARE '12-01-2017' DATE = GETDATE()


SELECT 
T1.*
FROM (
SELECT 
	MEMDAYS.SIS_NUMBER AS [SIS Number]
	,ENR.STATE_STUDENT_NUMBER AS [State Student Number]
	,MEMDAYS.SCHOOL_CODE AS [School Code]
	,MEMDAYS.STATE_SCHOOL_CODE
	,MEMDAYS.EXCLUDE_ADA_ADM
	
	,MembershipDays - coalesce([Total Unexcused],0) AS DAYS_PRESENT
	,CASE WHEN  MembershipDays IS NULL THEN 0 ELSE MembershipDays END AS DAYS_ATTENDED
	
	,MEMDAYS.EnterDate AS ENTER_DATE
	--,MAX(MEMDAYS.LEAVE_DATE) AS LEAVE_DATE
	,NULL AS LEAVE_DATE
	
	,ENR.GRADE AS [Grade]
	

FROM 

--dbo.STUDENT_SCHOOL_MEMBERDAYS 
(select
  stu.SIS_NUMBER                            as SIS_NUMBER
, per.FIRST_NAME                            as FirstName
, per.LAST_NAME                             as LastName
, grd.VALUE_DESCRIPTION                     as GradeLevel
, MIN(convert(varchar(10), enr.enter_date, 101)) as EnterDate
--, case 
--     when enr.LEAVE_DATE is not null then convert(varchar(10), enr.LEAVE_DATE, 101) 
--     when '12-01-2017' > copt.END_DATE   then convert(varchar(10), copt.END_DATE, 101) 
--     else convert(varchar(10), '12-01-2017', 101)
--  end 
--as LeaveDate
, yr.SCHOOL_YEAR                            as SchoolYear
, sch.SCHOOL_CODE                           as SCHOOL_CODE
,sch.STATE_SCHOOL_CODE
,ENR.EXCLUDE_ADA_ADM						AS EXCLUDE_ADA_ADM
, MembershipDays.MbDays                     as MembershipDays
,MAX(ENR.LEAVE_DATE) AS LEAVE_DATE
from rev.EPC_STU               stu
join rev.REV_PERSON            per  on  per.PERSON_GU              = stu.STUDENT_GU
join rev.EPC_STU_SCH_YR        ssy  on  ssy.STUDENT_GU             = stu.STUDENT_GU
join rev.EPC_STU_ENROLL        enr  on  enr.STUDENT_SCHOOL_YEAR_GU = ssy.STUDENT_SCHOOL_YEAR_GU
join rev.REV_ORGANIZATION_YEAR oyr  on  oyr.ORGANIZATION_YEAR_GU   = ssy.ORGANIZATION_YEAR_GU
join rev.REV_ORGANIZATION      org  on  org.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
join rev.REV_YEAR              yr   on  yr.YEAR_GU                 = oyr.YEAR_GU
join rev.EPC_SCH               sch  on  sch.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
join rev.EPC_SCH_ATT_CAL_OPT   copt on  copt.ORG_YEAR_GU           = oyr.ORGANIZATION_YEAR_GU
left join rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd on grd.VALUE_CODE = ssy.GRADE

join 
(
select distinct
       stu.STUDENT_GU
     , ct.OrgGu
     , ct.OrgYrGu
     , sum(cast(ct.Daytype as int)) over (partition by ct.OrgGu, ct.OrgYrGu, stu.student_gu) MbDays
from rev.EPC_STU               stu
join rev.EPC_STU_SCH_YR        ssy  on ssy.STUDENT_GU             = stu.STUDENT_GU
join rev.EPC_STU_ENROLL        enr  on enr.STUDENT_SCHOOL_YEAR_GU = ssy.STUDENT_SCHOOL_YEAR_GU
									AND (
										ENR.ENTER_DATE<= '10-12-2017' AND ENR.LEAVE_DATE <='12-01-2017'
										OR ENR.ENTER_DATE <= '10-12-2017' AND ENR.LEAVE_DATE IS NULL
										OR ENR.ENTER_DATE >= '10-12-2017' AND ENR.LEAVE_DATE <= '12-01-2017'
										OR ENR.ENTER_DATE >= '10-12-2017' AND ENR.LEAVE_DATE IS NULL 
									)

join rev.REV_ORGANIZATION_YEAR oyr  on oyr.ORGANIZATION_YEAR_GU   = ssy.ORGANIZATION_YEAR_GU
join rev.REV_ORGANIZATION      org  on org.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
join rev.EPC_SCH               sch  on sch.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
join rev.EPC_SCH_ATT_CAL_OPT   copt on copt.ORG_YEAR_GU           = oyr.ORGANIZATION_YEAR_GU
join dbo.CalDayTable			ct   on ct.OrgGU                   = oyr.ORGANIZATION_GU
                                       and ct.OrgYrGu             = oyr.ORGANIZATION_YEAR_GU
where ct.caldate between enr.ENTER_DATE and coalesce(CASE WHEN enr.leave_date > '12-01-2017' THEN '12-01-2017' ELSE enr.leave_date END , '12-01-2017')
AND CT.CalDate >='10-12-2017'

) AS MembershipDays     

on  MembershipDays.OrgGu            = oyr.ORGANIZATION_GU
	and MembershipDays.OrgYrGU                 = oyr.ORGANIZATION_YEAR_GU
	and MembershipDays.STUDENT_GU              = stu.STUDENT_GU
GROUP BY 
SIS_NUMBER, FIRST_NAME, LAST_NAME, VALUE_DESCRIPTION, SCHOOL_YEAR, SCHOOL_CODE, STATE_SCHOOL_CODE, ENR.EXCLUDE_ADA_ADM, MbDays
)
AS MEMDAYS

LEFT HASH JOIN 
( SELECT
 [SIS Number],
	[State Student Number], 
	[School Code], 
	[State School Code], 
	Exclude_ADA_ADM 
	,SUM(CASE 
		WHEN [Unexcused Half Day] = 'UNHD' THEN 0.50 
		WHEN [Unexcused Full Day] = 'UNFD' THEN 1.00 ELSE 0.00 END) AS [Total Unexcused]

	
	  FROM [APS].[STARSAttendanceDetailsAsOf]('2017-10-12', '2017-12-01')

GROUP BY 
 [SIS Number],
	[State Student Number], 
	[School Code], 
	[State School Code], 
	Exclude_ADA_ADM 
)
 AS ATT

ON 
ATT.[SIS NUMBER] = MEMDAYS.SIS_NUMBER
AND ATT.[SCHOOL CODE] = MEMDAYS.SCHOOL_CODE

LEFT HASH JOIN 
rev.EPC_SCH AS SCH
ON
SCH.SCHOOL_CODE = MEMDAYS.SCHOOL_CODE

LEFT HASH JOIN 
rev.REV_ORGANIZATION AS ORG
ON
ORG.ORGANIZATION_GU = SCH.ORGANIZATION_GU

-- 2014:  26F066A3-ABFC-4EDB-B397-43412EDABC8B
-- 2015:  BCFE2270-A461-4260-BA2B-0087CB8EC26A
-- 2016:  F7D112F7-354D-4630-A4BC-65F586BA42EC

LEFT HASH JOIN 
(
SELECT MAX(VALUE_DESCRIPTION) AS GRADE,STU.SIS_NUMBER,
STU.STATE_STUDENT_NUMBER

, LAST_NAME, FIRST_NAME, STU.GENDER, STU.HISPANIC_INDICATOR, STU.RACE_1, STU.RACE_2, STU.RACE_3, STU.RACE_4, STU.RACE_5
,ELL_STATUS, SPED_STATUS, GIFTED_STATUS, LUNCH_STATUS, HOME_LESS
,HOME_ADDRESS, HOME_CITY, HOME_STATE, HOME_ZIP

FROM 
APS.EnrollmentsForYear((SELECT YEAR_GU FROM rev.SIF_22_Common_CurrentYearGU)) AS ENR
INNER JOIN 
APS.LookupTable('K12','GRADE') AS LU
ON
ENR.GRADE = LU.VALUE_CODE
INNER JOIN 
APS.BasicStudentWithMoreInfo AS STU
ON
STU.STUDENT_GU = ENR.STUDENT_GU
INNER JOIN 
rev.EPC_STU AS STU2
ON
STU2.STUDENT_GU = STU.STUDENT_GU
GROUP BY STU.SIS_NUMBER
,STU.STATE_STUDENT_NUMBER
, LAST_NAME, FIRST_NAME, STU.GENDER, STU.HISPANIC_INDICATOR, STU.RACE_1, STU.RACE_2, STU.RACE_3, STU.RACE_4, STU.RACE_5,
ELL_STATUS, SPED_STATUS, GIFTED_STATUS, LUNCH_STATUS, HOME_LESS
,HOME_ADDRESS, HOME_CITY, HOME_STATE, HOME_ZIP 
) AS ENR
ON
ENR.SIS_NUMBER = MEMDAYS.SIS_NUMBER

) AS T1
INNER JOIN 
REV.EPC_STU AS STU
ON
T1.[SIS Number] = STU.SIS_NUMBER

INNER JOIN 
APS.PrimaryEnrollmentDetailsAsOf('12-01-2017') AS PRIM
ON
PRIM.STUDENT_GU = STU.STUDENT_GU
AND PRIM.SCHOOL_CODE = T1.[School Code]

