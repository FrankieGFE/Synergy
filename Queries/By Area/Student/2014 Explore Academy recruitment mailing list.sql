



SELECT 
	[Student].[FIRST_NAME]
	,[Student].[LAST_NAME]
	,[Student].[MIDDLE_NAME]
	,CASE WHEN [Student].[MAIL_ADDRESS] IS NULL THEN [Student].[HOME_ADDRESS] ELSE [Student].[MAIL_ADDRESS] END AS [ADDRESS]
    ,CASE WHEN [Student].[MAIL_ADDRESS] IS NULL THEN [Student].[HOME_ADDRESS_2] ELSE [Student].[MAIL_ADDRESS_2] END AS [ADDRESS_2]
    ,CASE WHEN [Student].[MAIL_CITY] IS NULL THEN [Student].[HOME_CITY] ELSE [Student].[MAIL_CITY] END AS [CITY]
    ,CASE WHEN [Student].[MAIL_STATE] IS NULL THEN [Student].[HOME_STATE] ELSE [Student].[MAIL_STATE] END AS [STATE]
    ,CASE WHEN [Student].[MAIL_ZIP] IS NULL THEN [Student].[HOME_ZIP] ELSE [Student].[MAIL_ZIP] END AS [ZIP]
    ,[Grades].[VALUE_DESCRIPTION] AS [GRADE_LEVEL]
    ,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	--,[STUDENT_EXCEPTIONS].*
FROM
	---------------------------------------------
	-- ENROLLMENT INFORMATION
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS [Enrollments]	
	
	INNER JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[Enrollments].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	INNER JOIN
	rev.[EPC_SCH] AS [SCHOOL] -- Contains School Code
	ON
	[OrgYear].[ORGANIZATION_GU] = [SCHOOL].[ORGANIZATION_GU]
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[Enrollments].[GRADE] = [Grades].[VALUE_CODE]
	
	--------------------------------------------------
	-- STUDENT DEMOGRAPHICS
	INNER JOIN
	APS.BasicStudent AS [Student] 
	ON
	[Enrollments].[STUDENT_GU] = [Student].[STUDENT_GU]
	
	INNER JOIN
	rev.[UD_STU] AS [STUDENT_EXCEPTIONS]
	ON
	[Student].[STUDENT_GU] = [STUDENT_EXCEPTIONS].[STUDENT_GU]
	
WHERE
	-- Get Specific Schools and Grades	
	 (
			-- Get High School Students
			([Grades].[VALUE_DESCRIPTION] IN ('09','10')
			AND
			[SCHOOL].[SCHOOL_CODE] IN ('590', '576', '550', '525', '520', '540', '560', '570', '530', '575', '580', '515', '514')) 
		OR 
			-- Get Middle School Students
			([Grades].[VALUE_DESCRIPTION] = '08'
			AND
			[SCHOOL].[SCHOOL_CODE] IN ('410', '413', '415', '416', '418', '420', '490', '425', '445', '405', '427', '485', '425', '440', '448', '452', '455', '457', '492', '475', '460', '465', '470'))
	)
	--- EXCEPTIONS
	AND [STUDENT_EXCEPTIONS].[EXCLUDE_BUSINESS] = 'N'
	AND [STUDENT_EXCEPTIONS].[EXCLUDE_UNIVERSITY] = 'N'

