/*
DROP TABLE dbo.STUDENT_ATTENDANCE_2015

CREATE TABLE dbo.STUDENT_ATTENDANCE_2015

( [SIS Number]  VARCHAR (9)
      ,[School Code]  VARCHAR (20)
      ,[Exclude_Ada_Adm]  VARCHAR (1)
      ,[School Name]  VARCHAR (100)
      ,[Grade]  VARCHAR (2)
      ,[Gender]  VARCHAR (2)
      ,[Hispanic Indicator]  VARCHAR (1)
      ,[Race1]  VARCHAR (50)
      ,[Race2]  VARCHAR (50)
      ,[Race3]  VARCHAR (50)
      ,[Race4]  VARCHAR (50)
      ,[Race5]  VARCHAR (50)
      ,[ELL Status]  VARCHAR (1)
      ,[Sped Status]  VARCHAR (1)
      ,[Gifted Status]  VARCHAR (1)
      ,[Lunch Status]  VARCHAR (20)
      ,[Home Address]  VARCHAR (100)
      ,[Home City]  VARCHAR (100)
      ,[Home State]  VARCHAR (10)
      ,[Home Zip]  VARCHAR (10)
      ,[Half-Day Unexcused]  DECIMAL (5,2)
      ,[Full-Day Unexcused] DECIMAL (5,2)
      ,[Total Unexcused]  DECIMAL (5,2)
      ,[Half-Day Excused]  DECIMAL (5,2)
      ,[Full-Day Excused]  DECIMAL (5,2)
      ,[Total Excused]  DECIMAL (5,2)
      ,[Total_Exc_Unex]  DECIMAL (5,2)
      ,[ORGANIZATION_GU]  VARCHAR (300)
         )
  */       

INSERT INTO dbo.STUDENT_ATTENDANCE_2015

SELECT Attendance.*
--, Members.MembershipDays 
FROM (

SELECT
              [SIS Number]
              --,[Last Name]
              --,[First Name]
              ,[School Code]
              ,ISNULL([Exclude_ADA_ADM],'') AS Exclude_Ada_Adm
              ,[School Name]
              ,Grade
              ,Gender
              ,[Hispanic Indicator]
              ,ISNULL(Race1,'') AS [Race1]
              ,ISNULL(Race2,'') AS [Race2]
              ,ISNULL(Race3,'') AS [Race3]
              ,ISNULL(Race4,'') AS [Race4]
              ,ISNULL(Race5,'') AS [Race5]
              ,[ELL Status]
              ,[Sped Status]
              ,[Gifted Status]
              ,[Lunch Status]
              ,[Home Address]
              --,[Homeless]
              ,[Home City]
              ,[Home State] 
              ,[Home Zip]
              ,[Half-Day Unexcused]
              ,[Full-Day Unexcused]
              ,[Total Unexcused]
              ,[Half-Day Excused]
              ,[Full-Day Excused]
              ,[Total Excused]
              --,[Member Days]
       ,SUM([Total Unexcused] + [Total Excused]) AS Total_Exc_Unex
       ,ORGANIZATION_GU
FROM 
(
SELECT 
       ATT.[SIS Number]
       ,ENR.LAST_NAME AS [Last Name]
       ,ENR.FIRST_NAME AS [First Name]
       ,ATT.[School Code]
       ,ATT.[Exclude_ADA_ADM]
       ,ORG.ORGANIZATION_NAME AS [School Name]
       ,ENR.GRADE AS [Grade]
       ,ENR.GENDER AS [Gender]
       , ENR.HISPANIC_INDICATOR AS [Hispanic Indicator]
       , ENR.RACE_1 AS Race1
       , ENR.RACE_2 AS Race2
       , ENR.RACE_3 AS Race3
       , ENR.RACE_4 AS Race4
       , ENR.RACE_5 AS Race5
       ,ENR.ELL_STATUS AS [ELL Status]
       ,ENR.SPED_STATUS AS [Sped Status]
       ,ENR.GIFTED_STATUS AS [Gifted Status]
       ,CASE WHEN ENR.LUNCH_STATUS = 'F' THEN 'Free' 
                WHEN ENR.LUNCH_STATUS = 'R' THEN 'Reduced'
                WHEN ENR.LUNCH_STATUS = 'N' THEN 'Non Participant'
                WHEN ENR.LUNCH_STATUS = '2' THEN 'Priority 2'
       ELSE '' END AS [Lunch Status]
       ,ENR.HOME_LESS AS [Homeless]
       ,HOME_ADDRESS AS [Home Address]
       ,HOME_CITY AS [Home City]
       ,HOME_STATE AS [Home State] 
       ,HOME_ZIP AS [Home Zip]
              
       ,CASE WHEN ATT.[Half-Day Unexcused] IS NULL THEN 0 ELSE ATT.[Half-Day Unexcused] END AS [Half-Day Unexcused]
       ,CASE WHEN ATT.[Full-Day Unexcused] IS NULL THEN 0 ELSE ATT.[Full-Day Unexcused] END AS [Full-Day Unexcused]
       ,CASE WHEN ATT.[Total Unexcused] IS NULL THEN 0 ELSE ATT.[Total Unexcused] END AS [Total Unexcused]
       ,CASE WHEN ATT.[Half-Day Excused] IS NULL THEN 0 ELSE ATT.[Half-Day Excused] END AS [Half-Day Excused]
       ,CASE WHEN ATT.[Full-Day Excused] IS NULL THEN 0 ELSE ATT.[Full-Day Excused] END AS [Full-Day Excused]
       ,CASE WHEN ATT.[Total Excused] IS NULL THEN 0 ELSE ATT.[Total Excused] END AS [Total Excused]

       ,ORG.ORGANIZATION_GU

FROM 
APS.AttendanceExcUnexTotalsAsOf('20160525') AS ATT

LEFT JOIN 
rev.EPC_SCH AS SCH
ON
SCH.SCHOOL_CODE = ATT.[School Code]

LEFT JOIN 
rev.REV_ORGANIZATION AS ORG
ON
ORG.ORGANIZATION_GU = SCH.ORGANIZATION_GU

-- 2014:  26F066A3-ABFC-4EDB-B397-43412EDABC8B
-- 2015:  BCFE2270-A461-4260-BA2B-0087CB8EC26A
-- 2016:  F7D112F7-354D-4630-A4BC-65F586BA42EC

LEFT JOIN 
(
SELECT MAX(VALUE_DESCRIPTION) AS GRADE,STU.SIS_NUMBER, STU.GENDER, STU.HISPANIC_INDICATOR, STU.RACE_1, STU.RACE_2, STU.RACE_3, STU.RACE_4, STU.RACE_5
,ELL_STATUS, SPED_STATUS, GIFTED_STATUS, LUNCH_STATUS
,HOME_ADDRESS, HOME_CITY, HOME_STATE, HOME_ZIP
,STU.LAST_NAME, STU.FIRST_NAME, STU2.HOME_LESS

FROM 
APS.EnrollmentsForYear('BCFE2270-A461-4260-BA2B-0087CB8EC26A') AS ENR
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

GROUP BY STU.SIS_NUMBER, STU.GENDER, STU.HISPANIC_INDICATOR, STU.RACE_1, STU.RACE_2, STU.RACE_3, STU.RACE_4, STU.RACE_5,
ELL_STATUS, SPED_STATUS, GIFTED_STATUS, LUNCH_STATUS
,HOME_ADDRESS, HOME_CITY, HOME_STATE, HOME_ZIP
,STU.LAST_NAME, STU.FIRST_NAME, STU2.HOME_LESS
) AS ENR
ON
ENR.SIS_NUMBER = ATT.[SIS Number]

) AS T1

GROUP BY 
              [SIS Number]
              ,[Last Name]
              ,[First Name]
              ,[School Code]
              ,[Exclude_ADA_ADM]
              ,[School Name]
              ,Grade
              ,Gender
              ,[Hispanic Indicator]
              ,Race1
              ,Race2
              ,Race3
              ,Race4
              ,Race5
              ,[ELL Status]
              ,[Sped Status]
              ,[Gifted Status]
              ,[Lunch Status]
              ,[Homeless]
              ,[Home Address]
              ,[Home City]
              ,[Home State] 
              ,[Home Zip]
              ,[Half-Day Unexcused]
              ,[Full-Day Unexcused]
              ,[Total Unexcused]
              ,[Half-Day Excused]
              ,[Full-Day Excused]
              ,[Total Excused]
              --,[Member Days]
              ,ORGANIZATION_GU

) AS Attendance

----------------------------------------------------------------------------------------------------------------------
/*
LEFT JOIN 
(
select
  stu.SIS_NUMBER                            as SIS_NUMBER
, per.FIRST_NAME                            as FirstName
, per.LAST_NAME                             as LastName
, grd.VALUE_DESCRIPTION                     as GradeLevel
, convert(varchar(10), enr.enter_date, 101) as EnterDate
, case 
     when enr.LEAVE_DATE is not null then convert(varchar(10), enr.LEAVE_DATE, 101) 
     when 20160525 > copt.END_DATE   then convert(varchar(10), copt.END_DATE, 101) 
     else convert(varchar(10), 20160525, 101)
  end 
as LeaveDate
, yr.SCHOOL_YEAR                            as SchoolYear
, sch.SCHOOL_CODE                           as SchoolCode
, MembershipDays.MbDays                     as MembershipDays

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
join rev.REV_ORGANIZATION_YEAR oyr  on oyr.ORGANIZATION_YEAR_GU   = ssy.ORGANIZATION_YEAR_GU
join rev.REV_ORGANIZATION      org  on org.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
join rev.EPC_SCH               sch  on sch.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
join rev.EPC_SCH_ATT_CAL_OPT   copt on copt.ORG_YEAR_GU           = oyr.ORGANIZATION_YEAR_GU
join dbo.CalDayTable           ct   on ct.OrgGU                   = oyr.ORGANIZATION_GU
                                       and ct.OrgYrGu             = oyr.ORGANIZATION_YEAR_GU
where ct.caldate between enr.ENTER_DATE and coalesce(enr.leave_date, 20160525)
--and sch.SCHOOL_CODE = @School
) AS MembershipDays     

on  MembershipDays.OrgGu            = oyr.ORGANIZATION_GU
                                    and MembershipDays.OrgYrGU                 = oyr.ORGANIZATION_YEAR_GU
                                    and MembershipDays.STUDENT_GU              = stu.STUDENT_GU
) AS Members

ON 
       Attendance.[SIS Number] = Members.SIS_NUMBER
       AND Attendance.[School Code] = Members.SchoolCode
       AND Attendance.[Grade] = Members.GradeLevel 
       

*/
