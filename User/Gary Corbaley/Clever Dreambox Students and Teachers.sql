

/*
SELECT DISTINCT	
	[SECTIONS].[School_id]
	,CONVERT(VARCHAR,[SECTIONS].[School_id]) + '-' + CONVERT(VARCHAR,[SECTIONS].[Section_id]) AS [Section_id]
	,[SECTIONS].[Teacher_id]
	,[SECTIONS].[Name]
	,MIN([SECTIONS].[Grade]) AS [Grade]
	
FROM
	(
	SELECT DISTINCT
		[School].[SCHOOL_CODE]  AS [School_id]
		,[SCHEDULE].[SECTION_ID] AS [Section_id]
		,SUBSTRING([STAFF].[BADGE_NUM],2,99) AS [Teacher_id]
		,[SCHEDULE].[COURSE_TITLE] + '-Period' + CONVERT(VARCHAR,[SCHEDULE].[PERIOD_BEGIN]) AS [Name]
		,[Grades].[VALUE_DESCRIPTION] AS [Grade] 
		
	FROM
		APS.ScheduleAsOf(GETDATE()) AS [SCHEDULE]
		
		INNER JOIN 
		rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		[SCHEDULE].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		
		INNER JOIN 
		rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON 
		[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
		
		INNER JOIN
		rev.[EPC_STAFF] AS [STAFF]
		ON
		[SCHEDULE].[STAFF_GU] = [STAFF].[STAFF_GU]
		
		LEFT OUTER JOIN
		APS.LookupTable('K12','Grade') AS [Grades]
		ON
		[SCHEDULE].[ENROLLMENT_GRADE_LEVEL] = [Grades].[VALUE_CODE]
		

	WHERE
		[School].[SCHOOL_CODE] IN ('250','339','268','303','309','333','230','252','264','395','265','217','470','492','418')
		--AND [STAFF].[BADGE_NUM] = 'e205641'
		
	) AS [SECTIONS]
	
GROUP BY
	[SECTIONS].[School_id]
	,[SECTIONS].[Section_id]
	,[SECTIONS].[Teacher_id]
	,[SECTIONS].[Name]		

--*/	

----------------------------------------------------------------------------------

/*	
SELECT DISTINCT
	[School].[SCHOOL_CODE]  AS [School_id]
	,CONVERT(VARCHAR,[School].[SCHOOL_CODE]) + '-' + CONVERT(VARCHAR,[SCHEDULE].[SECTION_ID]) AS [Section_id]
	,[STUDENT].[SIS_NUMBER] AS [Student_id]
	
FROM
	APS.ScheduleAsOf(GETDATE()) AS [SCHEDULE]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[SCHEDULE].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[SCHEDULE].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
--*/	
---------------------------------------------------------------------------------------

--/*
SELECT DISTINCT
	[School].[SCHOOL_CODE] AS [school_id]
	,[STUDENT].[SIS_NUMBER] AS [student_id]
	,[STUDENT].[STATE_STUDENT_NUMBER] AS [student_number]
	,[STUDENT].[LAST_NAME] AS [Last_name]
	,[STUDENT].[FIRST_NAME] AS [First_name]
	,[STUDENT].[MIDDLE_NAME] AS [Middle_name]
	,[STUDENT].[GENDER] AS [Gender]
	,[Grades].[VALUE_DESCRIPTION] AS [Grade]
	
FROM
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS [Enrollments]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[Enrollments].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
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
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
	
WHERE
	[School].[SCHOOL_CODE] IN ('225','250','339','268','303','309','333','230','252','264','395','265','217','470','492','418')
--*/
	
----------------------------------------------------------------------------------------------------

SELECT
	[School].[SCHOOL_CODE] AS [School_id]
	,REPLACE([STAFF].[BADGE_NUM],'e','') AS [Teacher_id]
	,[STAFF_PERSON].[LAST_NAME] AS [Last_Name]
	,[STAFF_PERSON].[MIDDLE_NAME] AS [Middle_name]
	,[STAFF_PERSON].[FIRST_NAME] AS [First_name]
	,[STAFF_PERSON].[EMAIL] AS [Teacher_email]
	
FROM
	rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
	
	INNER JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[STAFF_SCHOOL_YEAR].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	
	INNER JOIN
	rev.[EPC_STAFF] AS [STAFF]
	ON
	[STAFF_SCHOOL_YEAR].[STAFF_GU] = [STAFF].[STAFF_GU]
	
	INNER JOIN
	rev.[REV_PERSON] AS [STAFF_PERSON]
	ON
	[STAFF].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]
	
WHERE
	[RevYear].[SCHOOL_YEAR] = '2014'
	AND [RevYear].[EXTENSION] = 'R'

	AND	[School].[SCHOOL_CODE] IN ('225','250','339','268','303','309','333','230','252','264','395','265','217','470','492','418')