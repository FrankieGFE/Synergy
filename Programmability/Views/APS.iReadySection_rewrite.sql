
--CREATE VIEW APS.iReadySection AS

 WITH

-- From School of Record [EPC_STU_YR]
ASOF_ENROLLMENTS AS
(
SELECT
	[StudentSchoolYear].[STUDENT_GU]
	,[StudentSchoolYear].[ORGANIZATION_YEAR_GU]
	,[Organization].[ORGANIZATION_GU]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	,[Grades].[LIST_ORDER]
	,[School].[SCHOOL_CODE]
	,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	--,[StudentSchoolYear].[ENTER_DATE]
	--,[StudentSchoolYear].[LEAVE_DATE]
	--,[StudentSchoolYear].[EXCLUDE_ADA_ADM]
	--,[StudentSchoolYear].[ACCESS_504]
	--,CASE WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 2 THEN 'CONCURRENT'
	--	WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 1 THEN 'NO ADA/ADM'
	--	ELSE '' END AS [CONCURRENT]
	,[OrgYear].[YEAR_GU]
	,[RevYear].[SCHOOL_YEAR]
	,[RevYear].[EXTENSION]
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
)


, SCHEDULE AS
(
	SELECT
		[SCHEDULE].*
		,[STAFF_PERSON].[FIRST_NAME] +' '+ [STAFF_PERSON].[LAST_NAME] AS [TEACHER NAME]	
		,REPLACE([STAFF].[BADGE_NUM],'e','') AS [BADGE_NUM]
		,[ALL_STAFF_SCH_YR].[PRIMARY_STAFF]
		
	FROM
		--APS.BasicSchedule AS [SCHEDULE]
		APS.ScheduleAsOf(CASE WHEN MONTH(GETDATE()) = 8 THEN '10/1/' + CONVERT(VARCHAR(4),YEAR(GETDATE())) ELSE GETDATE() END) AS [SCHEDULE]
		
		INNER JOIN
		rev.[EPC_STU_CLASS] AS [CLASS]
		ON
		[SCHEDULE].[STUDENT_SCHOOL_YEAR_GU] = [CLASS].[STUDENT_SCHOOL_YEAR_GU]
		AND [SCHEDULE].[SECTION_GU] = [CLASS].[SECTION_GU]
		AND [CLASS].[TEACHER_AIDE] = 'N'
		
		-- Get both primary and secodary staff
		INNER JOIN
		(
		SELECT
			[STAFF_SCHOOL_YEAR_GU]
			,[STAFF_GU]
			,[ORGANIZATION_YEAR_GU]
			,1 AS [PRIMARY_STAFF]
		FROM
			rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
			
		UNION ALL
			
		SELECT
			[STAFF_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU]
			,[STAFF_SCHOOL_YEAR].[STAFF_GU]
			,[STAFF_SCHOOL_YEAR].[ORGANIZATION_YEAR_GU]
			,0 AS [PRIMARY_STAFF]
		FROM
			rev.[EPC_SCH_YR_SECT_STF] AS [SECONDARY_STAFF]
			
			INNER JOIN
			rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
			ON
			[SECONDARY_STAFF].[STAFF_SCHOOL_YEAR_GU] = [STAFF_SCHOOL_YEAR].[STAFF_SCHOOL_YEAR_GU]
		) AS [ALL_STAFF_SCH_YR]
		ON
	   [SCHEDULE].[STAFF_SCHOOL_YEAR_GU] = [ALL_STAFF_SCH_YR].[STAFF_SCHOOL_YEAR_GU]
	   
		INNER JOIN
		rev.[EPC_STAFF] AS [STAFF]
		ON
		[ALL_STAFF_SCH_YR].[STAFF_GU] = [STAFF].[STAFF_GU]

		INNER JOIN
		rev.[REV_PERSON] AS [STAFF_PERSON]
		ON
		[STAFF].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]

		inner join
		[ST_Production].[rev].[EPC_SCH_YR_SECT] as sect
		on sect.ORGANIZATION_YEAR_GU = SCHEDULE.ORGANIZATION_YEAR_GU
		and sect.SECTION_GU = SCHEDULE.SECTION_GU
)

--------------------------------------------------------------------------------------------------------------------

SELECT
	[Client ID]
	,STUDENT_GU
	,[School ID]
	,[Section ID]
	,[Name]
	,[Grade Level]
	,[Term]
	,[Code]
	,[Location]
	,[Partner ID]
	,[Action]
	,[Course Name]
	,[Subject]
	,[Reserved1]
	,[Reserved2]
	,[Reserved3]
	,[Reserved4]
	,[Reserved5]
	,[Reserved6]
	,[Reserved7]
	,[Reserved8]
	--,[Reserved9]
	--,[Reserved10]
	
FROM
(
SELECT DISTINCT
    schedule.STUDENT_GU
	,'nm-albuq87774' AS [Client ID]
	,[School].[SCHOOL_CODE] AS [School ID]
	,ENROLLMENTS.grade as grades
	,CONVERT(VARCHAR,[School].[SCHOOL_CODE]) + '-' + CONVERT(VARCHAR,[SCHEDULE].[SECTION_ID]) AS [Section ID]
	,CONVERT(VARCHAR,[SCHEDULE].[COURSE_ID]) + '-' + [SCHEDULE].[COURSE_TITLE] + '-' + CONVERT(VARCHAR,[SCHEDULE].[SECTION_ID]) AS [Name]
	,CASE WHEN [Course Grades].[VALUE_DESCRIPTION] = 'K' THEN '0' ELSE [Course Grades].[VALUE_DESCRIPTION] END AS [Grade Level]
	,[SCHEDULE].[TERM_CODE] AS [Term]
	,'' AS [Code]
	,[SCHEDULE].[ORGANIZATION_NAME] AS [Location]
	,'' AS [Partner ID]
	,'' AS [Action]
	,[SCHEDULE].[COURSE_TITLE] AS [Course Name]
	,[SCHEDULE].[SUBJECT_AREA_1] AS [Subject]
	
	,'' AS [Reserved1]
	,'' AS [Reserved2]
	,'' AS [Reserved3]
	,'' AS [Reserved4]
	,'' AS [Reserved5]
	,'' AS [Reserved6]
	,'' AS [Reserved7]
	,'' AS [Reserved8]
	,'' AS [Reserved9]
	,'' AS [Reserved10]
	
	,ROW_NUMBER() OVER (PARTITION BY [School].[SCHOOL_CODE], [SCHEDULE].[SECTION_ID] ORDER BY [SCHEDULE].[SECTION_ID] DESC) AS RN
	
FROM
	ASOF_ENROLLMENTS AS [ENROLLMENTS]
	
	INNER JOIN
	SCHEDULE AS [SCHEDULE]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
	AND [ENROLLMENTS].[YEAR_GU] = [SCHEDULE].[YEAR_GU]
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [Course Grades]
	ON
	[SCHEDULE].[GRADE_RANGE_LOW] = [Course Grades].[VALUE_CODE]

	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[SCHEDULE].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	
	
	
WHERE
	(
	[ENROLLMENTS].[GRADE] IN ('K','01','02','03','04','05','06','07','08')
	OR
	[SCHEDULE].[COURSE_ID] LIKE '064%'
	)
	AND [SCHEDULE].[PRIMARY_STAFF] = 1
	

) [STUFF]

WHERE
    1 = 1
	AND [RN] = 1
	--AND [Section ID] IN ('450-E829','465-E519','475-E216')
	AND [Course Name] = 'ALGEBRA I BILINGUAL'