






SELECT
	[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[STUDENT].[SIS_NUMBER]
	,[COURSE].[COURSE_ID]
	,[COURSE].[COURSE_TITLE]
	,[SCHEDULE].[SECTION_ID]
	,[SCHEDULE].[PERIOD_BEGIN]
	,[SCHEDULE].[PERIOD_END]
	,[SCHEDULE].[TERM_CODE]
	,[STAFF_PERSON].[FIRST_NAME] +' '+ [STAFF_PERSON].[LAST_NAME] AS [TEACHER NAME]
	,REPLACE([STAFF].[BADGE_NUM],'e','') AS [BADGE_NUM]
	,[Organization].[ORGANIZATION_NAME] AS [HOME_SCHOOL_LOCATION]
	,[Course_Organization].[ORGANIZATION_NAME] AS [COURSE_LOCATION]
	,[Course_StudentSchoolYear].[EXCLUDE_ADA_ADM] AS [ADA/ADM CODE]
	,CASE WHEN [Course_StudentSchoolYear].[EXCLUDE_ADA_ADM] = 2 THEN 'CONCURRENT'
		WHEN [Course_StudentSchoolYear].[EXCLUDE_ADA_ADM] = 1 THEN 'NON ADA/ADM'
		ELSE '' END AS [CONCURRENT]
		
FROM
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS [Enrollments]
	
	INNER JOIN
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	ON
	[Enrollments].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[Enrollments].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	APS.BasicSchedule AS [SCHEDULE]
	ON
	[Enrollments].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
	AND [OrgYear].[YEAR_GU] = [SCHEDULE].[YEAR_GU]
		
	INNER JOIN
	rev.EPC_CRS AS [COURSE]
	ON
	[SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
	
	INNER JOIN
	rev.[EPC_STAFF] AS [STAFF]
	ON
	[SCHEDULE].[STAFF_GU] = [STAFF].[STAFF_GU]

	INNER JOIN
	rev.[REV_PERSON] AS [STAFF_PERSON]
	ON
	[STAFF].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]
	
	INNER JOIN
	rev.EPC_STU_SCH_YR AS [Course_StudentSchoolYear]
	ON
	[SCHEDULE].[STUDENT_SCHOOL_YEAR_GU] = [Course_StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Course_Organization] -- Contains the School Name
	ON 
	[SCHEDULE].[ORGANIZATION_GU] = [Course_Organization].[ORGANIZATION_GU]
	
	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[SCHEDULE].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	
WHERE
	[School].[SCHOOL_CODE] IN ('517','592')
	AND [School].[SCHOOL_CODE] LIKE '517'
	