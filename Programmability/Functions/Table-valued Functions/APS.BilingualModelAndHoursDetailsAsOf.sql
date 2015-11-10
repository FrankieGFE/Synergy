
/**
 * $Revision: 1 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 2015-10-13 $
 *
 */

 /*********************************************************************************************************************************
	PULLS STUDENTS THAT ARE NOT ELL AND SHOULD NOT BE RECEIVING SERVICES
 **********************************************************************************************************************************/
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[BilingualModelAndHoursDetailsAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.BilingualModelAndHoursDetailsAsOf() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

ALTER FUNCTION APS.BilingualModelAndHoursDetailsAsOf(@AsOfDate DATETIME)
RETURNS TABLE
AS
RETURN


SELECT

	Organization.ORGANIZATION_NAME
	,SCHOOL.SCHOOL_CODE
	,Student.SIS_NUMBER AS StudentID
	,StudentPerson.LAST_NAME AS StudentLastName
	,StudentPerson.FIRST_NAME AS StudentFirstName

	,HomeLanguage.VALUE_DESCRIPTION AS HomeLanguage
	,GradeLevel.VALUE_DESCRIPTION AS EnrollGrade
	,GradeLevel.LIST_ORDER AS EnrollGradeOrder
	,CASE WHEN PHLOTE.STUDENT_GU IS NULL THEN 'N' ELSE 'Y' END AS PHLOTE
	,CASE WHEN ELL.STUDENT_GU IS NULL THEN 'N' ELSE 'Y' END AS ELL
	,CASE WHEN LatestEvaluation.IS_ELL = 0 THEN 'Y' ELSE 'N' END AS FEP
	,BEPProgramCode.VALUE_DESCRIPTION AS BEPProgramDescription
	,BEP.PROGRAM_INTENSITY AS BEPHours

	,LatestEvaluation.ADMIN_DATE AS EnglishEvalDate
	,LatestEvaluation.TEST_NAME AS EnglishEval
	,PerformanceLevel.VALUE_DESCRIPTION AS EnglishEvalPerformanceLevel

	,SpanishEval.ADMIN_DATE AS SpanishEvalDate
	,SpanishEval.TEST_NAME AS SpanishEval
	,SpanishPerformanceLevel.VALUE_DESCRIPTION AS SpanishEvalPerformanceLevel
	
	,Schedule.COURSE_ID AS CourseID
	,Schedule.COURSE_TITLE AS Course
	,Schedule.SECTION_ID AS SectionID

	,Staff.BADGE_NUM
	,StaffPerson.LAST_NAME AS StaffLastName
	,StaffPerson.FIRST_NAME AS StaffFirstName
	,CASE WHEN LCEClass.AdditionalStaff = 1 THEN 'Y' ELSE '' END AS AdditionalStaff

	,CASE WHEN LCEClass.ALSMA IS NULL THEN '' ELSE 'Math' END AS ALSMA
	,CASE WHEN LCEClass.ALSMP IS NULL THEN '' ELSE 'Maintenance' END AS ALSMP
	,CASE WHEN LCEClass.ALS2W IS NULL THEN '' ELSE '2-Way Dual' END AS ALS2W
	,CASE WHEN LCEClass.ALSED IS NULL THEN '' ELSE 'ELD' END AS ALSED
	,CASE WHEN LCEClass.ALSSC IS NULL THEN '' ELSE 'Science' END AS ALSSC
	,CASE WHEN LCEClass.ALSSS IS NULL THEN '' ELSE 'Soc. Studies' END AS ALSSS
	,CASE WHEN LCEClass.ALSSH IS NULL THEN '' ELSE 'Sheltered' END AS ALSSH
	,CASE WHEN LCEClass.ALSLA IS NULL THEN '' ELSE 'Lang. Arts' END AS ALSLA
	,CASE WHEN LCEClass.ALSES IS NULL THEN '' ELSE 'ESL' END AS ALSES
	,CASE WHEN LCEClass.ALSOT IS NULL THEN '' ELSE 'Other' END AS ALSOT
	,CASE WHEN LCEClass.ALSNV IS NULL THEN '' ELSE 'Navajo' END AS ALSNV
	,Schedule.SECTION_GU

FROM
	APS.LCEBilingualAsOf(@AsOfDate) AS BEP
	INNER JOIN
	APS.EnrollmentsAsOf(@AsOfDate) AS Enroll
	ON
	Enroll.STUDENT_GU = BEP.STUDENT_GU

	INNER HASH JOIN 
	APS.ScheduleAsOf(@AsOfDate) AS Schedule
	ON
	Enroll.STUDENT_SCHOOL_YEAR_GU = Schedule.STUDENT_SCHOOL_YEAR_GU

	INNER HASH JOIN
	APS.LCEClassesWithMoreInfoAsOf(@AsOfDate) AS LCEClass
	ON
	Schedule.SECTION_GU = LCEClass.SECTION_GU

	INNER JOIN
	rev.EPC_STU AS Student
	ON
	Enroll.STUDENT_GU = Student.STUDENT_GU

	INNER JOIN
	rev.REV_ORGANIZATION AS Organization
	ON
	Schedule.ORGANIZATION_GU = Organization.ORGANIZATION_GU

	INNER JOIN
	rev.REV_PERSON AS StudentPerson
	ON
	Enroll.STUDENT_GU = StudentPerson.PERSON_GU

	INNER JOIN
	APS.LookupTable('k12','Language') AS HomeLanguage
	ON
	Student.HOME_LANGUAGE = HomeLanguage.VALUE_CODE

	LEFT JOIN
	rev.EPC_STAFF AS Staff
	ON
	LCEClass.STAFF_GU = Staff.STAFF_GU

	LEFT JOIN
	rev.REV_PERSON AS StaffPerson
	ON
	LCEClass.STAFF_GU = StaffPerson.PERSON_GU

	LEFT JOIN
	APS.LookupTable('K12.ProgramInfo', 'Bep_Program_Code') AS BEPProgramCode
	ON
	BEP.PROGRAM_CODE = BEPProgramCode.VALUE_CODE

	LEFT JOIN
	APS.LookupTable('k12','Grade') AS GradeLevel
	ON
	Enroll.GRADE = GradeLevel.VALUE_CODE

	LEFT JOIN
	APS.PHLOTEAsOf(@AsOfDate) AS PHLOTE
	ON
	Enroll.STUDENT_GU = PHLOTE.STUDENT_GU

	LEFT JOIN
	APS.ELLAsOf(@AsOfDate) AS ELL
	ON
	Enroll.STUDENT_GU = ELL.STUDENT_GU

	LEFT JOIN
	APS.LCELatestEvaluationAsOf(@AsOfDate) AS LatestEvaluation
	ON
	Enroll.STUDENT_GU = LatestEvaluation.STUDENT_GU

	LEFT JOIN
	APS.LookupTable('K12.TestInfo','Performance_Levels') AS PerformanceLevel
	ON
	LatestEvaluation.PERFORMANCE_LEVEL = PerformanceLevel.VALUE_CODE

	LEFT JOIN
	APS.LCELatestSpanishEvaluationAsOf(@AsOfDate) AS SpanishEval
	ON
	BEP.STUDENT_GU = SpanishEval.STUDENT_GU

	LEFT JOIN
	APS.LookupTable('K12.TestInfo','Performance_Levels') AS SpanishPerformanceLevel
	ON
	SpanishEval.PERFORMANCE_LEVEL = SpanishPerformanceLevel.VALUE_CODE

	INNER JOIN
	rev.EPC_SCH AS SCHOOL
	ON
	SCHOOL.ORGANIZATION_GU = Organization.ORGANIZATION_GU