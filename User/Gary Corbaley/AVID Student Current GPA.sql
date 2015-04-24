





DECLARE @SCHOOL_YEAR INT = 2014

; WITH 
 ASOF_ENROLLMENTS AS
(
SELECT
	[StudentSchoolYear].[STUDENT_GU]
	,[StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
	,[StudentSchoolYear].[ORGANIZATION_YEAR_GU]
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
	,[LEAVE_CODES].[VALUE_DESCRIPTION] AS [LEAVE_DESCRIPTION]
	,CASE WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 2 THEN 'CONCURRENT'
		WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 1 THEN 'NO ADA/ADM'
		ELSE '' END AS [CONCURRENT]
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
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','LEAVE_CODE') AS [LEAVE_CODES]
	ON
	[StudentSchoolYear].[LEAVE_CODE] = [LEAVE_CODES].[VALUE_CODE]
)

SELECT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[AVID_STUDENTS].[GRADE] AS [CURRENT_GRADE]
	,[ENROLLMENTS].[SCHOOL_NAME] AS [PRIMARY_ENROLLMENT_AS_OF]
	,[ENROLLMENTS].[SCHOOL_YEAR]
	, [GPA].[GPA_CODE]
    , [GPA].[GPA]
    , [GPA].[CLASS_RANK]
    , [GPA].[CLASS_SIZE]
    , [GPA].[CLASS_RANK_PCTILE]
    , [GPA].[GPA_TYPE_NAME]

FROM
	(
	SELECT DISTINCT
		[SCHEDULE].[STUDENT_GU]
		,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	FROM
		-- Get full schedule
		APS.BasicSchedule AS [SCHEDULE]
		
		INNER JOIN
		-- Get Course details
		rev.EPC_CRS AS [COURSE]
		ON
		[SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
		
		INNER JOIN 
		rev.REV_YEAR AS [RevYear] -- Contains the School Year
		ON 
		[SCHEDULE].[YEAR_GU] = [RevYear].[YEAR_GU]
		
		INNER JOIN
		rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
		ON
		[SCHEDULE].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
		
		LEFT OUTER JOIN
		APS.LookupTable('K12','Grade') AS [Grades]
		ON
		[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
		
	WHERE
		[COURSE].[COURSE_ID] IN ('55507','555071','555072','55508','555081','555082','555091','555092','555101','555102','555111','555112','555121','555122')
		AND [RevYear].[SCHOOL_YEAR] = @SCHOOL_YEAR
		AND [RevYear].[EXTENSION] = 'R'
		
	) AS [AVID_STUDENTS]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[AVID_STUDENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	LEFT OUTER JOIN
	ASOF_ENROLLMENTS AS [ENROLLMENTS]
	ON
	[AVID_STUDENTS].[STUDENT_GU] = [ENROLLMENTS].[STUDENT_GU]
	
	LEFT OUTER JOIN
	(
	SELECT
		[GPA].[STUDENT_SCHOOL_YEAR_GU]
		, [GPA_DEF].[GPA_CODE]
		, [GPA].[GPA]
		, [GPA].[CLASS_RANK]
		, [GPA_RUN].[CLASS_SIZE]
		, [GPA].[CLASS_RANK_PCTILE]
		, [GPA_DEF_TYPE].[GPA_TYPE_NAME]
		
	FROM
		rev.[EPC_STU_GPA] AS [GPA]
			
		INNER JOIN
		rev.[EPC_SCH_YR_GPA_TYPE_RUN] AS [GPA_RUN]
		ON
		[GPA].[SCHOOL_YEAR_GPA_TYPE_RUN_GU] = [GPA_RUN].[SCHOOL_YEAR_GPA_TYPE_RUN_GU]
		AND [GPA_RUN].[SCHOOL_YEAR_GRD_PRD_GU] IS NULL
		
		INNER JOIN
		rev.[EPC_GPA_DEF_TYPE] AS [GPA_DEF_TYPE]
		ON
		[GPA_RUN].[GPA_DEF_TYPE_GU] = [GPA_DEF_TYPE].[GPA_DEF_TYPE_GU]
		AND 
		(
		[GPA_DEF_TYPE].[GPA_TYPE_NAME] = 'HS Cum Flat' 
		OR 
		[GPA_DEF_TYPE].[GPA_TYPE_NAME] = 'HS Cum Weighted'
		)
		
		INNER JOIN
		rev.[EPC_GPA_DEF] AS [GPA_DEF]
		ON
		[GPA_DEF_TYPE].[GPA_DEF_GU] = [GPA_DEF].[GPA_DEF_GU]
		AND (
		[GPA_DEF].[GPA_CODE] = 'HSCF' 
		OR 
		[GPA_DEF].[GPA_CODE] = 'HSCW'
		)
		WHERE
			[GPA_DEF_TYPE].[GPA_TYPE_NAME] = 'HS Cum Weighted'
	) AS [GPA]
	ON
	[ENROLLMENTS].[STUDENT_SCHOOL_YEAR_GU] = [GPA].[STUDENT_SCHOOL_YEAR_GU]
	
ORDER BY
	[STUDENT].[SIS_NUMBER]