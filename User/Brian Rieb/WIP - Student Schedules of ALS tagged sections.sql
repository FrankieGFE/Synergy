

-- This does not pull in classes outside current term
SELECT
	GETDATE() AS [As of Date]
	,ClassSchool.SCHOOL_CODE AS [Location Number]
	,Schedule.COURSE_ID AS [Course Number]
	,Schedule.SECTION_ID AS [Section Number]
	,Student.SIS_NUMBER AS [Stu_ID]
	,Student.STATE_STUDENT_NUMBER AS [State_ID]
	,Person.LAST_NAME AS [Student_LN]
	,Person.FIRST_NAME AS [Student_FN]
	,Person.MIDDLE_NAME AS [Student_MN]
	,EnrollOrganization.ORGANIZATION_NAME AS [SOR]
	,GradeLevel.VALUE_DESCRIPTION AS [Grde]
	,StudentLanguage.VALUE_DESCRIPTION AS [Home Language]
	,CASE WHEN Student.HOME_LANGUAGE != '00' THEN 'Y' ELSE 'N' END AS PHLOTE
	,Student.HOME_LANGUAGE_DATE AS [PHLOTE_DT]
	,Evaluation.PERFORMANCE_LEVEL AS [ENG_PROF]
	,Evaluation.ADMIN_DATE AS [ENG_PROF_DT]
	,CASE
		WHEN ELL.STUDENT_GU IS NULL OR COALESCE(ELL.PROGRAM_CODE,'0') != '1' THEN 0
		WHEN ELL.PROGRAM_CODE = '1' AND ELL.EXIT_DATE IS NULL THEN 1
		WHEN ELL.EXIT_REASON = 'EY1' THEN 2
		WHEN ELL.EXIT_REASON = 'EY2' THEN 3
		WHEN ELL.EXIT_REASON = 'EY3' THEN 4
	END AS [ELL_STAT]
	,Schedule.COURSE_TITLE AS [DEBUG-- Course Title] -- debug
FROM
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enroll
	INNER JOIN
	APS.ScheduleAsOf(GETDATE()) AS Schedule
	ON
	Enroll.STUDENT_GU = Schedule.STUDENT_GU
	
	-- Narrowing down to only tagged sections
	INNER JOIN
	(
	SELECT
		DISTINCT SECTION_GU
	FROM
		rev.UD_SECTION_TAG
	WHERE
		TAG LIKE 'ALS%'
	)AS TaggedSections
	ON
	Schedule.SECTION_GU = TaggedSections.SECTION_GU

	INNER JOIN
	rev.EPC_SCH AS ClassSchool
	ON
	Schedule.ORGANIZATION_GU = ClassSchool.ORGANIZATION_GU

	INNER JOIN
	rev.EPC_STU AS Student
	ON
	Enroll.STUDENT_GU = Student.STUDENT_GU

	INNER JOIN
	rev.REV_PERSON AS Person
	ON 
	Enroll.STUDENT_GU = Person.PERSON_GU

	INNER JOIN
	rev.REV_ORGANIZATION_YEAR AS OrgYear
	ON
	Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

	INNER JOIN
	rev.REV_ORGANIZATION AS EnrollOrganization
	ON
	OrgYear.ORGANIZATION_GU = EnrollOrganization.ORGANIZATION_GU

	INNER JOIN
	APS.LookupTable('K12','Grade') AS GradeLevel
	ON
	Enroll.GRADE = GradeLevel.VALUE_CODE

	INNER JOIN
	APS.LookupTable('K12','Language') AS StudentLanguage
	ON
	Student.HOME_LANGUAGE = StudentLanguage.VALUE_CODE

	LEFT JOIN
	APS.LCELatestEvaluationAsOf(GETDATE()) AS Evaluation
	ON
	Enroll.STUDENT_GU = Evaluation.STUDENT_GU

	LEFT JOIN
	rev.EPC_STU_PGM_ELL AS ELL
	ON
	Enroll.STUDENT_GU = ELL.STUDENT_GU