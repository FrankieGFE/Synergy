



SELECT DISTINCT	
	[SECTIONS].[School_id]
	,CONVERT(VARCHAR,[SECTIONS].[School_id]) + '-' + CONVERT(VARCHAR,[SECTIONS].[Section_id]) AS [Section_id]
	,[SECTIONS].[Teacher_id]
	,'' AS [Teacher_2_id]
	,'' AS [Teacher_3_id]
	,'' AS [Teacher_4_id]
	,[SECTIONS].[Name]
	,MIN([SECTIONS].[Grade]) AS [Grade]
	,[SECTIONS].[COURSE_TITLE] AS [Course_name]
	,[SECTIONS].[COURSE_ID] AS [Course_number]
	,[SECTIONS].[PERIOD_BEGIN] AS [Period]
	,'' AS [Subject]
	,'' AS [Term_name]
	,'' AS [Term_start]
	,'' AS [Term_end]
	
FROM
	(
	SELECT DISTINCT
		[School].[SCHOOL_CODE]  AS [School_id]
		,[SCHEDULE].[SECTION_ID] AS [Section_id]
		,SUBSTRING([STAFF].[BADGE_NUM],2,99) AS [Teacher_id]
		,[SCHEDULE].[COURSE_TITLE] + '-Period-' + CONVERT(VARCHAR,[SCHEDULE].[PERIOD_BEGIN]) + '-' + CONVERT(VARCHAR,[School].[SCHOOL_CODE]) + '-' + CONVERT(VARCHAR,[SCHEDULE].[SECTION_ID]) AS [Name]
		,[Grades].[VALUE_DESCRIPTION] AS [Grade] 
		,[SCHEDULE].[COURSE_TITLE]
		,[SCHEDULE].[COURSE_ID]
		,[SCHEDULE].[PERIOD_BEGIN]
		
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
		[School].[SCHOOL_CODE] BETWEEN '500' AND '599'
		--AND [SCHEDULE].[YEAR_GU] IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
		
	) AS [SECTIONS]
	
GROUP BY
	[SECTIONS].[School_id]
	,[SECTIONS].[Section_id]
	,[SECTIONS].[Teacher_id]
	,[SECTIONS].[Name]
	,[SECTIONS].[COURSE_ID]
	,[SECTIONS].[PERIOD_BEGIN]
	,[SECTIONS].[COURSE_TITLE]