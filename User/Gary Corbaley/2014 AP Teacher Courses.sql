

SELECT DISTINCT	
	[School].[SCHOOL_CODE]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]	
	,[COURSE].[COURSE_ID]
	,[COURSE].[COURSE_TITLE]
	,[BASIC_SCHEDULE].[SECTION_ID]
	,[BASIC_SCHEDULE].[TERM_CODE]
	,[TEACHER_PERSON].[FIRST_NAME]
	,[TEACHER_PERSON].[LAST_NAME]	
	,[STAFF].[STATE_ID]
	
FROM
	APS.BasicSchedule AS [BASIC_SCHEDULE]
	
	INNER JOIN
	rev.EPC_CRS AS [COURSE]
	ON
	[BASIC_SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
	
	INNER JOIN	 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[BASIC_SCHEDULE].[YEAR_GU] = [RevYear].[YEAR_GU]
	
	INNER JOIN
	rev.EPC_STU AS [STUDENT]
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
	
WHERE
	[RevYear].[SCHOOL_YEAR] = '2014'
	AND [RevYear].[EXTENSION] = 'R'
--	COURSE_ID = '110131'
	AND [COURSE].[COURSE_TITLE] LIKE '%ROTC%'
	
	--AND [COURSE].[AP_INDICATOR] = 'Y'
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
