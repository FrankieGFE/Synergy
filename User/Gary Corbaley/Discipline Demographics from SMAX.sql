



EXECUTE AS LOGIN='QueryFileUser'
GO

	SELECT
		[FILE].[02014-STU_ID_NBR]
		--,[SMAX_STUDENT].*
		,[SMAX_STUDENT].[GENDER] AS [Gender]
		,[SMAX_STUDENT].[Race] AS [Ethnicity]
		,[SMAX_STUDENT].[SPED Status] AS [SPED]
		,[SMAX_STUDENT].[ELL Status] AS [ELL]
		,[SMAX_STUDENT].[FRPL] AS [FRPL]
		
		
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from Discipline_2014.csv' 
		)AS [FILE]
		
		LEFT OUTER JOIN
		OPENQUERY([011-SYNERGYDB.APS.EDU.ACTD],'
			SELECT
				[STUDENT].*
				,CASE WHEN [ELLSTAT].[ID_NBR] IS NOT NULL THEN ''Y'' ELSE ''N'' END AS [ELL Status]
				,CASE WHEN [SPED].[ID_NBR] IS NOT NULL THEN ''Y'' ELSE ''N'' END AS [SPED Status]		 
			FROM
				[PR].APS.BasicStudent AS [STUDENT]
				
				LEFT JOIN
				-- Get Current SPED status
				[PR].APS.SpedAsOf(GETDATE()) AS [SPED]
				
				ON
				[STUDENT].[DST_NBR] = [SPED].[DST_NBR]
				AND [STUDENT].[ID_NBR] = [SPED].[ID_NBR]
				AND [SPED].[SCH_YR] = ''2014''
				AND [SPED].[Primary Disability] != ''GI''
				
				-- Get ELL Stats
				LEFT JOIN
				[PR].APS.ELLStudentsAsOf(GETDATE()) AS [ELLSTAT]
				
				ON
				[STUDENT].[DST_NBR] = [ELLSTAT].[DST_NBR]
				AND [STUDENT].[ID_NBR] = [ELLSTAT].[ID_NBR]
				AND [ELLSTAT].[SCH_YR] = ''2014''
			') AS [SMAX_STUDENT]
		ON
		[FILE].[02014-STU_ID_NBR] = [SMAX_STUDENT].[ID_NBR]
		
	WHERE
		[FILE].[02014-STU_ID_NBR] IS NOT NULL
		
		
		
		
	
REVERT
GO