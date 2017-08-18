USE [ST_Production]
GO

/****** Object:  UserDefinedFunction [APS].[HRTeacherClassDetailsAsOf]    Script Date: 8/4/2017 12:25:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*******************************************************************************************************


FUNCTION TO PULL STUDENTS IN CLASSROOMS FOR HR

*********************************************************************************************************/


CREATE FUNCTION [APS].[HRTeacherClassDetailsAsOf](@AsOfDate DATETIME)
RETURNS TABLE
AS
RETURN


SELECT 
	SCHOOL_CODE, SCHOOL_NAME, LAST_NAME,FIRST_NAME, SIS_NUMBER, GRADE, SPED_STATUS, ELL_STATUS, RESOLVED_RACE, PERIOD_BEGIN, PERIOD_END, COURSE_ID, SECTION_ID, COURSE_TITLE, 
	TEACHER_LAST_NAME, TEACHER_FIRST_NAME, BADGE_NUM, Staff_Responsibility, ADD_STAFF_LAST_NAME, ADD_STAFF_FIRST_NAME, [ADD_STAFF_BADGE_NUM]
	,ORGANIZATION_GU
 FROM (
--STUDENTS IN HOMEROOM PERIOD 1 --DETAILS
SELECT 
	ROW_NUMBER() OVER (PARTITION BY ENROLL.SCHOOL_CODE, STF.BADGE_NUM ,BS.SIS_NUMBER ORDER BY SCH.PERIOD_BEGIN) AS RN
	,ENROLL.SCHOOL_CODE, SCHOOL_NAME, BS.LAST_NAME, BS.FIRST_NAME, BS.SIS_NUMBER, ENROLL.GRADE, BS.SPED_STATUS, BS.ELL_STATUS,  BS.RESOLVED_RACE
	,SCH.PERIOD_BEGIN, PERIOD_END, SCH.COURSE_ID, SCH.SECTION_ID, SCH.COURSE_TITLE
	,PERS.LAST_NAME AS TEACHER_LAST_NAME, PERS.FIRST_NAME AS TEACHER_FIRST_NAME, STF.BADGE_NUM
	,SCH2.VALUE_DESCRIPTION AS Staff_Responsibility
	,ADDSTAFF.[FIRST_NAME] AS ADD_STAFF_LAST_NAME, ADDSTAFF.[LAST_NAME] AS ADD_STAFF_FIRST_NAME
	,REPLACE(STAFF2.[BADGE_NUM],'e','') AS [ADD_STAFF_BADGE_NUM]
	,SCH.ORGANIZATION_GU
FROM 
	APS.ScheduleDetailsAsOf(@AsOfDate) AS SCH
	INNER JOIN 
	APS.BasicStudentWithMoreInfo AS BS
	ON
	SCH.STUDENT_GU = BS.STUDENT_GU
	INNER JOIN 
	APS.PrimaryEnrollmentDetailsAsOf(@AsOfDate) AS ENROLL
	ON
	ENROLL.STUDENT_GU = SCH.STUDENT_GU

	INNER JOIN 
	REV.REV_PERSON AS PERS
	ON
	PERS.PERSON_GU = SCH.STAFF_GU

	INNER JOIN
	REV.EPC_STAFF AS STF
	ON
	SCH.STAFF_GU = STF.STAFF_GU

	--ADDITIONAL STAFF
	LEFT JOIN	
	rev.EPC_SCH_YR_SECT_STF AS AdditionalStaff
	ON
	SCH.SECTION_GU = AdditionalStaff.SECTION_GU

	LEFT JOIN
	rev.EPC_STAFF_SCH_YR AS StaffSchoolYear
	ON
	AdditionalStaff.STAFF_SCHOOL_YEAR_GU = StaffSchoolYear.STAFF_SCHOOL_YEAR_GU

	LEFT JOIN 
	REV.EPC_STAFF AS STAFF2
	ON
	StaffSchoolYear.STAFF_GU = STAFF2.STAFF_GU

	LEFT JOIN 
	REV.REV_PERSON AS ADDSTAFF
	ON
	ADDSTAFF.PERSON_GU = StaffSchoolYear.STAFF_GU

	LEFT JOIN 
	APS.LookupTable('K12.ScheduleInfo','Staff_Responsibility') AS SCH2
	ON
	AdditionalStaFF.STAF_CONTR_RESPON = SCH2.VALUE_CODE

	WHERE
	--SCH.PERIOD_BEGIN = 1
	--AND 
	SCH.ORGANIZATION_NAME LIKE '%ELEMENTARY%'
	) AS T1

	WHERE RN = 1
GO


