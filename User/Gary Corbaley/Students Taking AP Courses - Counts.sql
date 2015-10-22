

--SELECT
--	[SCHOOL_YEAR]
--	,[SCHOOL_CODE]
--	,[SCHOOL_NAME]
--	,[COURSE_ID]
--	,[COURSE_TITLE]
--	,[SECTION_ID]
--	,[TERM_CODE]
--	,[TEACHER_FIRST_NAME]
--	,[TEACHER_LAST_NAME]
--	,[STATE_ID] AS [TEACHER_ID]
--	,COUNT([SIS_NUMBER]) AS [STUDENT_COUNT]
--FROM
--	(
	SELECT DISTINCT	
		[RevYear].[SCHOOL_YEAR]
		,[STUDENT].[SIS_NUMBER]
		,[PERSON].[FIRST_NAME] AS [STUDENT_FIRST_NAME]
		,[PERSON].[LAST_NAME] AS [STUDENT_LAST_NAME]
		,[PERSON].[MIDDLE_NAME] AS [STUDENT_MIDDLE_NAME]
		,[STUDENT].[HISPANIC_INDICATOR]
		,[STUDENT].[RACE_1]
		,[STUDENT].[RACE_2]
		,[STUDENT].[RACE_3]
		,[STUDENT].[RACE_4]
		,[STUDENT].[RACE_5]
		,[STUDENT].[GENDER]
		,[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
		,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
		,[COURSE].[COURSE_ID]
		,[COURSE].[COURSE_TITLE]
		,[BASIC_SCHEDULE].[SECTION_ID]
		,[BASIC_SCHEDULE].[TERM_CODE]
		,[TEACHER_PERSON].[FIRST_NAME] AS [TEACHER_FIRST_NAME]
		,[TEACHER_PERSON].[LAST_NAME] AS [TEACHER_LAST_NAME]
		,[STAFF].[STATE_ID]
		
		--,[COURSE].*
		
	FROM
		--APS.BasicSchedule AS [BASIC_SCHEDULE]
		APS.ScheduleWithFutureAsOf('10/14/2015') AS [BASIC_SCHEDULE]
		
		INNER JOIN
		rev.EPC_CRS AS [COURSE]
		ON
		[BASIC_SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
		
		INNER JOIN	 
		rev.REV_YEAR AS [RevYear] -- Contains the School Year
		ON 
		[BASIC_SCHEDULE].[YEAR_GU] = [RevYear].[YEAR_GU]
		
		INNER JOIN
		APS.BasicStudentWithMoreInfo AS [STUDENT]
		ON
		[BASIC_SCHEDULE].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
		
		INNER JOIN
		rev.[REV_PERSON] AS [PERSON]
		ON
		[BASIC_SCHEDULE].[STUDENT_GU] = [PERSON].[PERSON_GU]
		
		LEFT JOIN
		rev.[EPC_STAFF] AS [STAFF]
		ON
		[BASIC_SCHEDULE].[STAFF_GU] = [STAFF].[STAFF_GU]
		
		LEFT JOIN
		rev.[REV_PERSON] AS [TEACHER_PERSON]
		ON
		[BASIC_SCHEDULE].[STAFF_GU] = [TEACHER_PERSON].[PERSON_GU]
	    
		-- Get school name
		INNER JOIN 
		rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		[BASIC_SCHEDULE].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	    
		-- Get school number
		LEFT JOIN 
		rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON 
		[BASIC_SCHEDULE].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
		
		INNER JOIN
		rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
		ON
		[BASIC_SCHEDULE].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
		
		LEFT OUTER JOIN
		APS.LookupTable('K12','Grade') AS [Grades]
		ON
		[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
		
	WHERE
		--[RevYear].[SCHOOL_YEAR] IN ('2013','2014')
		--[RevYear].[SCHOOL_YEAR] = '2015'
		--AND [RevYear].[EXTENSION] = 'R'
	--	COURSE_ID = '110131'
		--AND [COURSE].[COURSE_TITLE] LIKE '%ROTC%'
		
		--AND ( [COURSE].[AP_INDICATOR] = 'Y' OR [COURSE].[COURSE_TITLE] LIKE '%hon%')
		[COURSE].[AP_INDICATOR] = 'Y'
		
		--AND COURSE_ID IN
		--('96011'
		--,'96012'
		--,'96021'
		--,'96022'
		--,'96031'
		--,'96032'
		--,'96041'
		--,'96042'
		--,'98011'
		--,'98012'
		--,'98021'
		--,'98022'
		--,'98031'
		--,'98032'
		--,'98041'
		--,'98042'
		--,'99051'
		--,'99052'
		--,'99061'
		--,'99062'
		--,'99111'
		--,'99112')
--	) AS [STUDENT_COURSES]
	
--GROUP BY
--	[SCHOOL_YEAR]
--	,[SCHOOL_CODE]
--	,[SCHOOL_NAME]
--	,[COURSE_ID]
--	,[COURSE_TITLE]
--	,[SECTION_ID]
--	,[TERM_CODE]
--	,[TEACHER_FIRST_NAME]
--	,[TEACHER_LAST_NAME]
--	,[STATE_ID]