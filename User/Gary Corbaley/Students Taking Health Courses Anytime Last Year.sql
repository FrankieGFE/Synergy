


SELECT
	[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	,[COURSE].[COURSE_ID]
	,[COURSE].[COURSE_TITLE]
	,[COURSE].[DEPARTMENT]
	,[COURSE].[SUBJECT_AREA_1]
	,[SCHEDULE].[TERM_CODE]
	,[SCHEDULE].[COURSE_ENTER_DATE]
	,[SCHEDULE].[COURSE_LEAVE_DATE]
	
FROM
	APS.BasicSchedule AS [SCHEDULE]
	
	INNER JOIN
	rev.EPC_CRS AS [COURSE]
	ON
	[SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
	
	INNER JOIN 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[SCHEDULE].[YEAR_GU] = [RevYear].[YEAR_GU]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[SCHEDULE].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[SCHEDULE].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	INNER JOIN
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	ON
	[SCHEDULE].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
	
WHERE
	[RevYear].[SCHOOL_YEAR] = '2014'
	AND [RevYear].[EXTENSION] = 'R'
	AND [COURSE].[COURSE_ID] IN (
	'0602a',
	'0612a',
	'0612ade',
	'0622a',
	'063tf',
	'48010',
	'480101',
	'480102',
	'48010de',
	'480151',
	'480152',
	'48016',
	'480b1')