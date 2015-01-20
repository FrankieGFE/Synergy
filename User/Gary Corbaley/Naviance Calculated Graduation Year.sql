

EXECUTE AS LOGIN='QueryFileUser'
GO

	SELECT 
		[STUDENT_LIST].[Student_ID]
		,2027 - CONVERT(INT,[Grades].[VALUE_DESCRIPTION]) AS [Class_Year]
		,[STUDENT_LIST].[Last Name]	
		,[STUDENT_LIST].[Campus ID]	
		,[STUDENT_LIST].[First Name]	
		,[STUDENT_LIST].[Middle Name]	
		,[STUDENT_LIST].[State Student ID]	
		,[STUDENT_LIST].[Gender]	
		,[STUDENT_LIST].[FC User Name]	
		,[STUDENT_LIST].[FC Password]	
		,[STUDENT_LIST].[Ethnicity]	
		,[STUDENT_LIST].[Date of Birth]	
		,[STUDENT_LIST].[Street Address 1]	
		,[STUDENT_LIST].[Street Address_2]	
		,[STUDENT_LIST].[City]	
		,[STUDENT_LIST].[State]	
		,[STUDENT_LIST].[Zip_Code]	
		,[STUDENT_LIST].[GPA]	
		,[STUDENT_LIST].[Weighted GPA]
		,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
		,2027 - CONVERT(INT,[Grades].[VALUE_DESCRIPTION]) AS [GRAD_YEAR]
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
			'SELECT * from Naviance_Student_List_112014.csv'
		    ) AS [STUDENT_LIST]
		
	INNER JOIN
	rev.EPC_STU AS [STUDENT]
	ON
	[STUDENT_LIST].[Student_ID] = [STUDENT].[SIS_NUMBER]
	
	INNER JOIN
	APS.PrimaryEnrollmentsAsOf(GETDATE()) AS [ENROLLMENTS]
	ON
	[STUDENT].[STUDENT_GU] = [ENROLLMENTS].[STUDENT_GU]
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[ENROLLMENTS].[GRADE] = [Grades].[VALUE_CODE]
		
		    
REVERT
GO