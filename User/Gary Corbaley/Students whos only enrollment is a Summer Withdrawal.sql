



; WITH 
-- From Student School Year [EPC_STU_SCH_YR]
SSY_ENROLLMENTS AS
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
	,[StudentSchoolYear].[LEAVE_CODE]
	,[StudentSchoolYear].[WITHDRAWAL_REASON_CODE]
	,[LEAVE_CODE].[VALUE_DESCRIPTION] AS [LEAVE_DESCRIPTION]
	,[StudentSchoolYear].[SUMMER_WITHDRAWL_CODE]
	,[StudentSchoolYear].[EXCLUDE_ADA_ADM]
	,[StudentSchoolYear].[ACCESS_504]
	,CASE WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 2 THEN 'CONCURRENT'
		WHEN [StudentSchoolYear].[EXCLUDE_ADA_ADM] = 1 THEN 'NO ADA/ADM'
		ELSE '' END AS [CONCURRENT]
	,[OrgYear].[YEAR_GU]
	,[RevYear].[SCHOOL_YEAR]
	,[RevYear].[EXTENSION]	
	,ROW_NUMBER() OVER (PARTITION BY [StudentSchoolYear].[STUDENT_GU] ORDER BY [StudentSchoolYear].[ENTER_DATE] DESC) AS RN
	
FROM
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	
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
	
	LEFT JOIN
	APS.LookupTable('K12','LEAVE_CODE') AS [LEAVE_CODE]
	ON
	[StudentSchoolYear].[LEAVE_CODE] = [LEAVE_CODE].[VALUE_CODE]
	
WHERE
	[RevYear].[SCHOOL_YEAR] >= '2012'
	AND [Grades].[VALUE_DESCRIPTION] BETWEEN '05' AND '11'
	--AND ([StudentSchoolYear].[SUMMER_WITHDRAWL_CODE] IN ('51','52') OR [StudentSchoolYear].[LEAVE_CODE] IN ('NAPS', 'GEI', 'WABS', 'WLTS', 'WEXP', 'WRET', 'WCORR', 'WNONC'))
)



SELECT
	[STUDENT].[SIS_NUMBER]
	,[ENROLLMENT_COUNTS].[COUNT] AS [ENROLLMENT RECORD COUNT]
	,[ENROLLMENTS].[SCHOOL_NAME]
	,[ENROLLMENTS].[SCHOOL_YEAR]
	,[ENROLLMENTS].[ENTER_DATE]
	,[ENROLLMENTS].[LEAVE_DATE]
	,[ENROLLMENTS].[LEAVE_CODE]
	,[ENROLLMENTS].[SUMMER_WITHDRAWL_CODE]
FROM
	SSY_ENROLLMENTS AS [ENROLLMENTS]

	INNER JOIN
	(
	SELECT
		[StudentSchoolYear].[STUDENT_GU]
		,COUNT(*) AS [COUNT]
	FROM
		rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	GROUP BY
		[StudentSchoolYear].[STUDENT_GU]
	) AS [ENROLLMENT_COUNTS]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [ENROLLMENT_COUNTS].[STUDENT_GU]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
WHERE
	[ENROLLMENT_COUNTS].[COUNT] = 1
	--AND [ENROLLMENTS].[SCHOOL_YEAR] >= '2014'
	AND [ENROLLMENTS].[SUMMER_WITHDRAWL_CODE] IS NOT NULL
	
ORDER BY
	[ENROLLMENTS].[SCHOOL_YEAR] DESC