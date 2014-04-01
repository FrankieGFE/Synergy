/**
 * $Revision: 1 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 2014-04-01 $
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

--********************************************************************************************************************************
--*                                  THIS IS SQL CREATED BY EDUPOINT - MOHAN MELARCODE                                           *
--*                                                                                                                              *
--********************************************************************************************************************************


--<APS - Student Active Directory Feed>
--SQL View Technology runs 
DECLARE  @vDistrict_Number VARCHAR(20)
DECLARE  @vSchYr VARCHAR(4)
DECLARE  @vRunDate smalldatetime
SET @vDistrict_Number = (SELECT CONVERT(xml,[VALUE]).value('(/ROOT/SIS/@DISTRICT_NUMBER)[1]','varchar(20)') AS DISTRICT_NUMBER
                         FROM rev.REV_APPLICATION  WHERE [KEY] = 'REV_INSTALL_CONSTANT')
SET @vSchYr = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
set @vRunDate = GETDATE()
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
-- Only primary active enrollment
SELECT 
   @vDistrict_Number                        AS [DistrictNumber]
, @vSchYr                                  AS [SchoolYear]
, stu.SIS_NUMBER                           AS [StudentIDNumber]
, sch.SCHOOL_CODE                          AS [SORSchoolNumber]
, org.ORGANIZATION_NAME                    AS [SchoolName]
, grd.VALUE_DESCRIPTION                    AS [Grade]
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
FROM rev.EPC_STU               stu
JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
                                       and ssy.STATUS is NULL
                                       and ssy.EXCLUDE_ADA_ADM is null --exclude concurrent enrollment
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                       and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') grd on grd.VALUE_CODE = ssy.GRADE 

-- Only concurrent active enrollment if no primary active enrollment is there

UNION
SELECT 
   @vDistrict_Number                        AS [DistrictNumber]
, @vSchYr                                  AS [SchoolYear]
, stu.SIS_NUMBER                           AS [StudentIDNumber]
, sch.SCHOOL_CODE                          AS [SORSchoolNumber]
, org.ORGANIZATION_NAME                    AS [SchoolName]
, grd.VALUE_DESCRIPTION                    AS [Grade]
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
                                       and ssy.EXCLUDE_ADA_ADM is not null --only concurrent enrollment
JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
                                       and oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
JOIN rev.REV_ORGANIZATION      org  ON org.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.REV_PERSON            per  ON per.PERSON_GU = stu.STUDENT_GU
LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') grd on grd.VALUE_CODE = ssy.GRADE 
--where we have no active primary enrollment
WHERE not exists(select s.STUDENT_GU from AllEnrollments s where s.STUDENT_GU = stu.STUDENT_GU and s.STATUS is null and s.EXCLUDE_ADA_ADM is null)

END --END STORED PROCEDURE
GO