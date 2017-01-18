/**
 * $Revision: 1132 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 2016-06-28 18:04:28 -0600 (Tue, 28 Jun 2016) $
*/ 

USE ST_Production
GO


-- Remove Procedure if it exists
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[ActiveDirectoryStudents]') AND type in (N'P', N'PC'))
	EXEC ('CREATE PROCEDURE [APS].ActiveDirectoryStudents AS SELECT 0')
GO

ALTER PROC [APS].[ActiveDirectoryStudents]

AS
BEGIN

--<APS - Student Active Directory Feed>
--SQL View Technology runs 
DECLARE  @vDistrict_Number VARCHAR(20)
DECLARE  @vSchYr VARCHAR(4)
DECLARE  @vRunDate smalldatetime
SET @vDistrict_Number = (SELECT CONVERT(xml,[VALUE]).value('(/ROOT/SIS/@DISTRICT_NUMBER)[1]','varchar(20)') AS DISTRICT_NUMBER
                         FROM rev.REV_APPLICATION  WHERE [KEY] = 'REV_INSTALL_CONSTANT')
SET @vSchYr = (select SCHOOL_YEAR + 1 from rev.SIF_22_Common_CurrentYear)
set @vRunDate = GETDATE() - 1 -- Previous day
--All Enrollments
; with AllEnrollments AS
(
SELECT
ROW_NUMBER() over (partition by stu.student_gu order by stu.student_gu) rn
, stu.STUDENT_GU
, sch.SCHOOL_CODE
, ssy.STATUS
, ssy.EXCLUDE_ADA_ADM
FROM rev.EPC_STU               stu
JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                       and oyr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU 
)


-- Only Summer Enrollments
, OSumEnr AS
(
SELECT
ROW_NUMBER() over (partition by stu.student_gu order by stu.student_gu) rn
, stu.STUDENT_GU
, sch.SCHOOL_CODE
, ssy.STATUS
, ssy.EXCLUDE_ADA_ADM
FROM rev.EPC_STU               stu
JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                       and oyr.YEAR_GU    = ssy.year_gu
join rev.rev_year               yr   ON yr.year_gu        = oyr.YEAR_GU
                                       and yr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE AND EXTENSION != 'R')
JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU 
)


-- Only primary active enrollment
SELECT 
   @vDistrict_Number                        AS [DistrictNumber]
 , @vSchYr                                  AS [SchoolYear]
 , stu.SIS_NUMBER                           AS [StudentIDNumber]
 , sch.SCHOOL_CODE                          AS [SORSchoolNumber]
 , org.ORGANIZATION_NAME                    AS [SchoolName]
 , CASE 
       WHEN grd.VALUE_DESCRIPTION IN ('P1', 'P2') THEN 'PK'         
       WHEN grd.VALUE_DESCRIPTION IN ('T1', 'T2', 'T3', 'T4', 'C1', 'C2', 'C3', 'C4') THEN '12'
	   ELSE grd.VALUE_DESCRIPTION
   END                                      AS [Grade]
 , CONVERT(VARCHAR(8), ssy.ENTER_DATE, 112) AS [EnterDate]
 , CASE
      WHEN ENTER_DATE = @vRunDate THEN 'A'
	  WHEN LEAVE_DATE = @vRunDate THEN 'D'
	  ELSE ''
   END                                      AS [AddDelStatus]
 , per.LAST_NAME                            AS [LastName]
 , per.FIRST_NAME                           AS [FirstName]
 , per.MIDDLE_NAME                          AS [StudentMiddleName]
 , 'P'                                      AS [SchoolOfRecord]
 	,ALTLOC1
	,ALTLOC2
	,ALTLOC3
	,ALTLOC4
	,ALTLOC5

FROM rev.EPC_STU               stu
JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
                                       and ssy.STATUS is NULL
                                       and ssy.EXCLUDE_ADA_ADM is null --exclude concurrent enrollment
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                       and oyr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') grd on grd.VALUE_CODE = ssy.GRADE 

LEFT JOIN
(
SELECT 
	--[DistrictNumber]
	--,[SchoolYear]
	[StudentIDNumber]
	,ALTLOC1
	,ALTLOC2
	,ALTLOC3
	,ALTLOC4
	,ALTLOC5

FROM (
SELECT 
	[DistrictNumber]
	,[SchoolYear]
	,[StudentIDNumber]
	,MAX([1]) AS ALTLOC1
	,MAX([2]) AS ALTLOC2
	,MAX([3]) AS ALTLOC3
	,MAX([4]) AS ALTLOC4
	,MAX([5]) AS ALTLOC5
	--,[SchoolName]
	,MIN([Grade]) AS Min_Grade
	,MIN([EnterDate]) AS Min_Enter_Date
	,[AddDelStatus]
	,[LastName]
	,[FirstName]
	,[StudentMiddleName]
	,[SchoolOfRecord]
 FROM 

(
SELECT 
   @vDistrict_Number                        AS [DistrictNumber]
 , @vSchYr                                  AS [SchoolYear]
 , stu.SIS_NUMBER                           AS [StudentIDNumber]
 , sch.SCHOOL_CODE                          AS [SORSchoolNumber]
 , org.ORGANIZATION_NAME                    AS [SchoolName]
 , CASE 
       WHEN grd.VALUE_DESCRIPTION IN ('P1', 'P2') THEN 'PK'         
       WHEN grd.VALUE_DESCRIPTION IN ('T1', 'T2', 'T3', 'T4', 'C1', 'C2', 'C3', 'C4') THEN '12'
	   ELSE grd.VALUE_DESCRIPTION
   END                                      AS [Grade]
 , CONVERT(VARCHAR(8), ssy.ENTER_DATE, 112) AS [EnterDate]
 , CASE
      WHEN ENTER_DATE = @vRunDate THEN 'A'
	  WHEN LEAVE_DATE = @vRunDate THEN 'D'
	  ELSE ''
   END                                      AS [AddDelStatus]
 , per.LAST_NAME                            AS [LastName]
 , per.FIRST_NAME                           AS [FirstName]
 , per.MIDDLE_NAME                          AS [StudentMiddleName]
 , 'S'                                      AS [SchoolOfRecord]
 ,ROW_NUMBER() over (partition by stu.student_gu order by stu.student_gu) rn

FROM rev.EPC_STU               stu
JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
                                       and ssy.STATUS is NULL
                                       and ssy.EXCLUDE_ADA_ADM is not null --exclude concurrent enrollment
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                       and oyr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') grd on grd.VALUE_CODE = ssy.GRADE 

) AS T1

PIVOT
(
MAX([SORSchoolNumber])
FOR rn IN ([1], [2], [3], [4], [5])
) AS PIVOTME 

GROUP BY 
	[DistrictNumber]
	,[SchoolYear]
	,[StudentIDNumber]

	--,[SchoolName]
	--,[Grade]
	--,[EnterDate]
	,[AddDelStatus]
	,[LastName]
	,[FirstName]
	,[StudentMiddleName]
	,[SchoolOfRecord]

) AS T2

) AS JOINALLTHIS

ON
JOINALLTHIS.StudentIDNumber = stu.SIS_NUMBER





--where not exists (select s.STUDENT_GU from OSumEnr s where s.STUDENT_GU = stu.STUDENT_GU and s.STATUS is null and s.EXCLUDE_ADA_ADM is null)
-- Only concurrent active enrollment if no primary active enrollment is there

UNION
SELECT 
   @vDistrict_Number                        AS [DistrictNumber]
 , @vSchYr                                  AS [SchoolYear]
 , stu.SIS_NUMBER                           AS [StudentIDNumber]
 , sch.SCHOOL_CODE                          AS [SORSchoolNumber]
 , org.ORGANIZATION_NAME                    AS [SchoolName]
 ,  CASE 
       WHEN grd.VALUE_DESCRIPTION IN ('P1', 'P2') THEN 'PK'         
       WHEN grd.VALUE_DESCRIPTION IN ('T1', 'T2', 'T3', 'T4', 'C1', 'C2', 'C3', 'C4') THEN '12'
	   ELSE grd.VALUE_DESCRIPTION
   END                                      AS [Grade]
 , CONVERT(VARCHAR(8), ssy.ENTER_DATE, 112) AS [EnterDate]
, CASE
      WHEN ENTER_DATE = @vRunDate THEN 'A'
	  WHEN LEAVE_DATE = @vRunDate THEN 'D'
	  ELSE ''
   END                                      AS [AddDelStatus]
 , per.LAST_NAME                            AS [LastName]
 , per.FIRST_NAME                           AS [FirstName]
 , per.MIDDLE_NAME                          AS [StudentMiddleName]
 , 'S'                                      AS [SchoolOfRecord]

 	,ALTLOC1
	,ALTLOC2
	,ALTLOC3
	,ALTLOC4
	,ALTLOC5
FROM rev.EPC_STU               stu
JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
                                       and ssy.STATUS is NULL
                                       and ssy.EXCLUDE_ADA_ADM is not null --only concurrent enrollment
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                       and oyr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') grd on grd.VALUE_CODE = ssy.GRADE 

-- PULL ADDITIONAL ENROLLMENTS FOR THESE KIDS
LEFT JOIN
(
SELECT 
	--[DistrictNumber]
	--,[SchoolYear]
	[StudentIDNumber]
	,ALTLOC1
	,ALTLOC2
	,ALTLOC3
	,ALTLOC4
	,ALTLOC5

	--,Min_Grade
	--,Min_Enter_Date
	--,[AddDelStatus]
	--,[LastName]
	--,[FirstName]
	--,[StudentMiddleName]
	--,[SchoolOfRecord]

FROM (
SELECT 
	[DistrictNumber]
	,[SchoolYear]
	,[StudentIDNumber]
	,MAX([1]) AS ALTLOC1
	,MAX([2]) AS ALTLOC2
	,MAX([3]) AS ALTLOC3
	,MAX([4]) AS ALTLOC4
	,MAX([5]) AS ALTLOC5
	--,[SchoolName]
	,MIN([Grade]) AS Min_Grade
	,MIN([EnterDate]) AS Min_Enter_Date
	,[AddDelStatus]
	,[LastName]
	,[FirstName]
	,[StudentMiddleName]
	,[SchoolOfRecord]
 FROM 

(
SELECT 
   @vDistrict_Number                        AS [DistrictNumber]
 , @vSchYr                                  AS [SchoolYear]
 , stu.SIS_NUMBER                           AS [StudentIDNumber]
 , sch.SCHOOL_CODE                          AS [SORSchoolNumber]
 , org.ORGANIZATION_NAME                    AS [SchoolName]
 , CASE 
       WHEN grd.VALUE_DESCRIPTION IN ('P1', 'P2') THEN 'PK'         
       WHEN grd.VALUE_DESCRIPTION IN ('T1', 'T2', 'T3', 'T4', 'C1', 'C2', 'C3', 'C4') THEN '12'
	   ELSE grd.VALUE_DESCRIPTION
   END                                      AS [Grade]
 , CONVERT(VARCHAR(8), ssy.ENTER_DATE, 112) AS [EnterDate]
 , CASE
      WHEN ENTER_DATE = @vRunDate THEN 'A'
	  WHEN LEAVE_DATE = @vRunDate THEN 'D'
	  ELSE ''
   END                                      AS [AddDelStatus]
 , per.LAST_NAME                            AS [LastName]
 , per.FIRST_NAME                           AS [FirstName]
 , per.MIDDLE_NAME                          AS [StudentMiddleName]
 , 'S'                                      AS [SchoolOfRecord]
 ,ROW_NUMBER() over (partition by stu.student_gu order by stu.student_gu) rn

FROM rev.EPC_STU               stu
JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
                                       and ssy.STATUS is NULL
                                       and ssy.EXCLUDE_ADA_ADM is not null --exclude concurrent enrollment
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                       and oyr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') grd on grd.VALUE_CODE = ssy.GRADE 

) AS T1

PIVOT
(
MAX([SORSchoolNumber])
FOR rn IN ([1], [2], [3], [4], [5])
) AS PIVOTME 

GROUP BY 
	[DistrictNumber]
	,[SchoolYear]
	,[StudentIDNumber]

	--,[SchoolName]
	--,[Grade]
	--,[EnterDate]
	,[AddDelStatus]
	,[LastName]
	,[FirstName]
	,[StudentMiddleName]
	,[SchoolOfRecord]

) AS T2

) AS JOINALLTHIS2

ON
JOINALLTHIS2.StudentIDNumber = stu.SIS_NUMBER



--where we have no active primary enrollment

WHERE not exists(select s.STUDENT_GU from AllEnrollments s where s.STUDENT_GU = stu.STUDENT_GU and s.STATUS is null and s.EXCLUDE_ADA_ADM is null)
      --and not exists (select s.STUDENT_GU from OSumEnr s where s.STUDENT_GU = stu.STUDENT_GU and s.STATUS is null and s.EXCLUDE_ADA_ADM is null)

/*
-- Only Summer Enrollments
UNION
SELECT 
   @vDistrict_Number                        AS [DistrictNumber]
 , @vSchYr                                  AS [SchoolYear]
 , stu.SIS_NUMBER                           AS [StudentIDNumber]
 , sch.SCHOOL_CODE                          AS [SORSchoolNumber]
 , org.ORGANIZATION_NAME                    AS [SchoolName]
 ,  CASE 
       WHEN grd.VALUE_DESCRIPTION IN ('P1', 'P2') THEN 'PK'         
       WHEN grd.VALUE_DESCRIPTION IN ('T1', 'T2', 'T3', 'T4', 'C1', 'C2', 'C3', 'C4') THEN '12'
	   ELSE grd.VALUE_DESCRIPTION
   END                                      AS [Grade]
 , CONVERT(VARCHAR(8), ssy.ENTER_DATE, 112) AS [EnterDate]
, CASE
      WHEN ENTER_DATE = @vRunDate THEN 'A'
	  WHEN LEAVE_DATE = @vRunDate THEN 'D'
	  ELSE ''
   END                                      AS [AddDelStatus]
 , per.LAST_NAME                            AS [LastName]
 , per.FIRST_NAME                           AS [FirstName]
 , per.MIDDLE_NAME                          AS [StudentMiddleName]
 , 'S'                                      AS [SchoolOfRecord]
FROM rev.EPC_STU               stu
JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
                                       and ssy.STATUS is NULL
                                       and ssy.EXCLUDE_ADA_ADM is null --only concurrent enrollment
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU = oyr.YEAR_GU
                                       and yr.SCHOOL_YEAR = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
									   and yr.EXTENSION = 'S'
JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') grd on grd.VALUE_CODE = ssy.GRADE 
*/



END --END STORED PROCEDURE
GO