



EXECUTE AS LOGIN='QueryFileUser'
GO

	SELECT DISTINCT
		[FILE].*
		,[STUDENT].[LAST_NAME]
		,[STUDENT].[FIRST_NAME]
		,[STUDENT].[MIDDLE_NAME]
		,[ENROLLMENT].[GRADE]
		,[ENROLLMENT].[SCHOOL_CODE]
		,[ENROLLMENT].[SCHOOL_NAME]
		
		,CASE WHEN [STUDENT].[MAIL_ADDRESS_GU] IS NULL THEN [STUDENT].[HOME_ADDRESS] ELSE [STUDENT].[MAIL_ADDRESS] END AS [ADDRESS]
		,CASE WHEN [STUDENT].[MAIL_ADDRESS_GU] IS NULL THEN [STUDENT].[HOME_ADDRESS_2] ELSE [STUDENT].[MAIL_ADDRESS_2] END AS [ADDRESS_2]
		,CASE WHEN [STUDENT].[MAIL_ADDRESS_GU] IS NULL THEN [STUDENT].[HOME_CITY] ELSE [STUDENT].[MAIL_CITY] END AS [CITY]
		,CASE WHEN [STUDENT].[MAIL_ADDRESS_GU] IS NULL THEN [STUDENT].[HOME_STATE] ELSE [STUDENT].[MAIL_STATE] END AS [STATE]
		,CASE WHEN [STUDENT].[MAIL_ADDRESS_GU] IS NULL THEN [STUDENT].[HOME_ZIP] ELSE [STUDENT].[MAIL_ZIP] END AS [ZIP]
		
		
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from 2015_META_SUMMER_SCHOOL_LIST.csv' 
		)AS [FILE]
		
	LEFT OUTER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[FILE].[ID_NBR] = [STUDENT].[SIS_NUMBER]
	
	LEFT OUTER JOIN
	(
	SELECT
		[StudentSchoolYear].[STUDENT_GU]
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
	WHERE
		[RevYear].[SCHOOL_YEAR] = '2014'	
	) AS [ENROLLMENT]
	ON
	[STUDENT].[STUDENT_GU] = [ENROLLMENT].[STUDENT_GU]
	AND [ENROLLMENT].[RN] = 1
	
ORDER BY
	[ENROLLMENT].[SCHOOL_CODE]
	,[ENROLLMENT].[GRADE]
	
REVERT
GO