


EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT DISTINCT
	[FILE].[ID_NBR] AS [SIS_NUMBER]
	--,[Student].[STUDENT_GU]
	,[Student].[FIRST_NAME]
	,[Student].[LAST_NAME]
	,[Student].[MIDDLE_NAME]
	,[StudentYear].[GRADE]
	,[StudentYear].[SCHOOL_CODE]
	,[StudentYear].[SCHOOL_NAME]
	,[StudentYear].[ENTER_DATE]
	,[StudentYear].[LEAVE_DATE]
	,[StudentYear].[EXCLUDE_ADA_ADM]
	,[StudentYear].[SCHOOL_YEAR]
	,[StudentYear].[EXTENSION]
FROM
	OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
			'SELECT DISTINCT * from META_Students_List2.csv'
		    ) AS [FILE]
	
		    
	LEFT OUTER JOIN
	APS.BasicStudent AS [Student] -- Contains Student ID State ID Language Code Cohort Year
	ON 
	[FILE].[ID_NBR] = [Student].[SIS_NUMBER]
	
	LEFT OUTER JOIN
	(
	SELECT
		[StudentSchoolYear].[STUDENT_GU]
		,[StudentSchoolYear].[ORGANIZATION_YEAR_GU]
		,[Organization].[ORGANIZATION_GU]
		,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
		,[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
		,[StudentSchoolYear].[ENTER_DATE]
		,[StudentSchoolYear].[LEAVE_DATE]
		,[StudentSchoolYear].[EXCLUDE_ADA_ADM]
		,[RevYear].[SCHOOL_YEAR]
		,[RevYear].[EXTENSION]
	FROM
		rev.EPC_STU_YR AS [StudentYear] -- School of record
		
		INNER JOIN
		rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
		ON
		[StudentYear].[STU_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
		
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
		[StudentYear].[YEAR_GU] = [RevYear].[YEAR_GU]
		
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
		AND [RevYear].[EXTENSION] = 'R'
	) AS [StudentYear]
	ON
	[Student].[STUDENT_GU] = [StudentYear].[STUDENT_GU]
	
--WHERE
--	[RevYear].[SCHOOL_YEAR] = '2014'
--	AND [RevYear].[EXTENSION] = 'R'
	
		    
REVERT
GO