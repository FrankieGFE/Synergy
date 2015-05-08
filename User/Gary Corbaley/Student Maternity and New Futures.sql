



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
	
--WHERE
--	[RevYear].[SCHOOL_YEAR] = '2012'
)

, SSY_CURRENT AS
(
SELECT DISTINCT
	[StudentSchoolYear].[STUDENT_GU]
FROM
	rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
	
	INNER JOIN 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[StudentSchoolYear].[YEAR_GU] = [RevYear].[YEAR_GU]
	
WHERE
	[RevYear].[SCHOOL_YEAR] = '2014'
	AND [StudentSchoolYear].[LEAVE_DATE] IS NULL

)



-------------------------------------------------------------------

SELECT DISTINCT
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[HOME_LANGUAGE]
	,[STUDENT].[MAIL_ADDRESS]
	,[STUDENT].[MAIL_CITY]
	,[STUDENT].[MAIL_STATE]
	,[STUDENT].[MAIL_ZIP]
	,[CURRENT_ENROLL].[GRADE]
	,[CURRENT_ENROLL].[SCHOOL_CODE]
	,[CURRENT_ENROLL].[SCHOOL_NAME]
	,[CURRENT_ENROLL].[SCHOOL_YEAR]
FROM
	(
	SELECT
		*
	FROM
		SSY_ENROLLMENTS AS [ENROLLMENTS]
		
	WHERE
		[ENROLLMENTS].[SCHOOL_YEAR] = '2014'
		AND [ENROLLMENTS].[SCHOOL_NAME] LIKE '%Futures%'
	) AS [CURRENT_ENROLL]
	
	LEFT OUTER JOIN
	(
	SELECT
		*
	FROM
		SSY_ENROLLMENTS AS [ENROLLMENTS]
		
	WHERE
		[ENROLLMENTS].[SCHOOL_YEAR] = '2013'
		AND [ENROLLMENTS].[SCHOOL_NAME] LIKE '%Futures%'
	) AS [PREV_ENROLL]
	ON
	[CURRENT_ENROLL].[STUDENT_GU] = [PREV_ENROLL].[STUDENT_GU]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[CURRENT_ENROLL].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
WHERE
	[PREV_ENROLL].[STUDENT_GU] IS NULL