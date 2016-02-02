



EXECUTE AS LOGIN='QueryFileUser'
GO

	SELECT
		[FILE].[Student Name]
		,[FILE].[Perm ID]
		,[STUDENT].[GENDER] AS [Gender]
		,CASE WHEN [STUDENT].[HISPANIC_INDICATOR] = 'Y' THEN 'Hispanic' ELSE [STUDENT].[RACE_1] END AS [Ethnicity]
		,[STUDENT].[SPED_STATUS] AS [SPED]
		,[STUDENT].[ELL_STATUS] AS [ELL]
		,[STUDENT].[LUNCH_STATUS] AS [FRPL]		
		
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from Discipline_2015.csv' 
		)AS [FILE]
		
		LEFT OUTER JOIN
		APS.BasicStudentWithMoreInfo AS [STUDENT]
		ON
		[FILE].[PERM ID] = [STUDENT].[SIS_NUMBER]
		
	WHERE
		[FILE].[PERM ID] IS NOT NULL
		
		
		
		
	
REVERT
GO