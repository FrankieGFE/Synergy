/**
 * 
 * $LastChangedBy: Debbie Ann Chavez
 * $LastChangedDate: 2015-01-20
 *
 * 
 * This View pulls all Student Grades in Synergy (posted from Gradebook).  "Student Grade" screen. 
 *
 */
 
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[APS].[StudentGrades]'))
	EXEC ('CREATE VIEW APS.StudentGrades AS SELECT 0 AS DUMMY')
GO

ALTER VIEW APS.StudentGrades AS


SELECT 
	ORG.ORGANIZATION_NAME
	,SIS_NUMBER 
	,GRADES.MARK_NAME AS GRADE_PERIOD
	,STUGRADES.MARK
	,SECPERIOD.CREDIT
	,COURSE.DEPARTMENT
	,COURSE.COURSE_TITLE
	,COURSE_ID
	, SECTION_ID
	,STUDENT.STUDENT_GU
	,SSY.STUDENT_SCHOOL_YEAR_GU
	,SECTION.SECTION_GU

FROM

rev.EPC_SCH_YR_GRD_PRD_MK AS GRADES

--nothing in this table
INNER JOIN
rev.EPC_STU_SCH_YR_GRD_PRD_MK AS STUGRADES
ON
GRADES.SCHOOL_YEAR_GRD_PRD_MK_GU = STUGRADES.SCHOOL_YEAR_GRD_PRD_MK_GU

INNER JOIN
rev.EPC_SCH_YR_GRD_PRD AS GRDPRD
ON
GRADES.SCHOOL_YEAR_GRD_PRD_GU = GRDPRD.SCHOOL_YEAR_GRD_PRD_GU

INNER JOIN
rev.EPC_STU_SCH_YR_GRD_PRD AS SECPERIOD
ON
STUGRADES.STU_SCHOOL_YEAR_GRD_PRD_GU = SECPERIOD.STU_SCHOOL_YEAR_GRD_PRD_GU

INNER JOIN
rev.EPC_SCH_YR_SECT AS SECTION
ON
SECPERIOD.SECTION_GU = SECTION.SECTION_GU

INNER JOIN
rev.EPC_SCH_YR_CRS AS CRSYR
ON
SECTION.SCHOOL_YEAR_COURSE_GU = CRSYR.SCHOOL_YEAR_COURSE_GU

INNER JOIN
rev.EPC_CRS AS COURSE
ON
CRSYR.COURSE_GU = COURSE.COURSE_GU

INNER JOIN
rev.EPC_STU_SCH_YR_GRD AS SSYGRD
ON
SSYGRD.STU_SCHOOL_YEAR_GRD_GU = SECPERIOD.STU_SCHOOL_YEAR_GRD_GU

INNER JOIN
rev.EPC_STU_SCH_YR AS SSY
ON
SSYGRD.STUDENT_SCHOOL_YEAR_GU = SSY.STUDENT_SCHOOL_YEAR_GU

INNER JOIN
rev.REV_YEAR AS YEARS
ON
SSY.YEAR_GU = YEARS.YEAR_GU
AND SCHOOL_YEAR = (SELECT SCHOOL_YEAR FROM rev.SIF_22_Common_CurrentYear) 

INNER JOIN
rev.EPC_STU AS STUDENT
ON
SSY.STUDENT_GU = STUDENT.STUDENT_GU

INNER JOIN
rev.REV_ORGANIZATION_YEAR AS OrgYear
ON Section.[ORGANIZATION_YEAR_GU] = OrgYear.ORGANIZATION_YEAR_GU

INNER JOIN
rev.REV_ORGANIZATION AS ORG
ON
OrgYear.ORGANIZATION_GU = ORG.ORGANIZATION_GU

--ORDER BY 
--SIS_NUMBER, COURSE_ID, SECTION_ID, GRADE_PERIOD


