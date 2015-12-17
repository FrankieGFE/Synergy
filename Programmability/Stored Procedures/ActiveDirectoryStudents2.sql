/*
	Created by: Debbie Ann Chavez
	Date:  12/7/2015

	Stored procedure that pulls additional enrollments only, no primary enrollments, for Technology Active Directory



USE ST_Production
GO


-- Remove Procedure if it exists
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[ActiveDirectoryStudents2]') AND type in (N'P', N'PC'))
	EXEC ('CREATE PROCEDURE [APS].ActiveDirectoryStudents2 AS SELECT 0')
GO

ALTER PROC [APS].[ActiveDirectoryStudents2]

AS
BEGIN
*/

DECLARE  @vDistrict_Number VARCHAR(20)
DECLARE  @vSchYr VARCHAR(4)
DECLARE  @vRunDate smalldatetime

SET @vDistrict_Number = (SELECT CONVERT(xml,[VALUE]).value('(/ROOT/SIS/@DISTRICT_NUMBER)[1]','varchar(20)') AS DISTRICT_NUMBER
                         FROM rev.REV_APPLICATION  WHERE [KEY] = 'REV_INSTALL_CONSTANT')
SET @vSchYr = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)

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
                                       and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU 
) 

SELECT 
	--[DistrictNumber]
	--,[SchoolYear]
	[StudentIDNumber]
	, COALESCE(
		CASE 
			WHEN SCH4 IS NOT NULL THEN SCH1 + ',' + SCH2 + ',' + SCH3 + ',' + SCH4
			WHEN SCH3 IS NOT NULL THEN SCH1 + ',' + SCH2 + ',' + SCH3
			WHEN SCH1 IS NOT NULL THEN (SCH1 + CASE WHEN SCH2 IS NOT NULL THEN ',' + SCH2 END) 
		END,SCH1) 
		 AS [AdditionalSchoolEnrollments]

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
	,MAX([1]) AS SCH1
	,MAX([2]) AS SCH2
	,MAX([3]) AS SCH3
	,MAX([4]) AS SCH4
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
                                       and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') grd on grd.VALUE_CODE = ssy.GRADE 

) AS T1

PIVOT
(
MAX([SchoolName])
FOR rn IN ([1], [2], [3], [4])
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

--END --END STORED PROCEDURE
--GO