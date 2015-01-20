

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
	

----------------------------------------------------------------------------------
	
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
