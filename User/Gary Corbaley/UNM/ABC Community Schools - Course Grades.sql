



; WITH 
 ASOF_ENROLLMENTS AS
(
SELECT
	[StudentSchoolYear].[STUDENT_GU]
	,[StudentSchoolYear].[ORGANIZATION_YEAR_GU]
	,[StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	,[Organization].[ORGANIZATION_GU]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	,[Grades].[LIST_ORDER]
	,[School].[SCHOOL_CODE]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,[StudentSchoolYear].[ENTER_DATE]
	,[StudentSchoolYear].[LEAVE_DATE]
	,[StudentSchoolYear].[EXCLUDE_ADA_ADM]
	,[StudentSchoolYear].[ACCESS_504]
	,[StudentSchoolYear].[LEAVE_CODE]
	,CASE WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 2 THEN 'CONCURRENT'
		WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 1 THEN 'NO ADA/ADM'
		ELSE '' END AS [CONCURRENT]
	,[RevYear].[SCHOOL_YEAR]
	,[RevYear].[EXTENSION]
FROM
	APS.PrimaryEnrollmentsAsOf('12/19/2014') AS [Enrollments]
	
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
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
	
	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]

WHERE
	-- GET ONLY 1ST SEMESTER ENROLLMENTS
	[RevYear].[SCHOOL_YEAR] = 2014
	AND [RevYear].[EXTENSION] = 'R'
	AND [Enrollments].[ENTER_DATE] <= '12/19/2014'
	AND '12/19/2014' >= COALESCE([Enrollments].[LEAVE_DATE],'12/19/2014')
	--AND [Enrollments].[CONCURRENT] = ''	

)


SELECT --TOP 1000
	[ENROLLMENTS].[SCHOOL_YEAR]
	,'FALL' AS [SEMESTER]
	,[STUDENT].[SIS_NUMBER]
	,[STUDENT].[STATE_STUDENT_NUMBER]
	,[ENROLLMENTS].[SCHOOL_CODE]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,'S1' AS [TERM_CODE]
	
	,[GRADES].[COURSE_ID]
	,[GRADES].[SECTION_ID]
	,[GRADES].[COURSE_TITLE]
	,[GRADES].[DEPARTMENT]
	
	,[COURSE].[SUBJECT_AREA_1]
	,[COURSE].[SUBJECT_AREA_2]
	,[COURSE].[SUBJECT_AREA_3]
	
	,[GRADES].[MARK]
	,[GRADES].[GRADE_PERIOD]
	
FROM
	ASOF_ENROLLMENTS AS [ENROLLMENTS]
	
	--INNER JOIN
	--APS.ScheduleAsOf('12/19/2014') AS [SCHEDULE]
	--ON
	--[ENROLLMENTS].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
	
	--INNER JOIN
	--rev.EPC_STU_CRS_HIS AS [HISTORY]
	--ON
	--[ENROLLMENTS].[STUDENT_GU] = [HISTORY].[STUDENT_GU]
	--AND [ENROLLMENTS].[ORGANIZATION_GU] = [HISTORY].[SCHOOL_IN_DISTRICT_GU]
	--AND [HISTORY].[SCHOOL_YEAR] = '2014'
	--AND [HISTORY].[TERM_CODE] = 'S1'	
	
	INNER JOIN
	rev.EPC_STU AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	APS.StudentGrades AS [GRADES]
	ON
	[ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU] = [GRADES].[STUDENT_SCHOOL_YEAR_GU]
	AND [GRADES].[GRADE_PERIOD] = 'S1 Grade'
	
	INNER JOIN
	rev.EPC_CRS AS [COURSE]
	ON
	[GRADES].[COURSE_ID] = [COURSE].[COURSE_ID]
	
WHERE
	[GRADES].[DEPARTMENT] IN ('Math','Eng','Sci','Soc')
	AND [ENROLLMENTS].[SCHOOL_CODE] IN ('413', '460', '470', '520', '570', '576')
	
ORDER BY
	[ENROLLMENTS].[STUDENT_GU]
	
	