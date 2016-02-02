



EXECUTE AS LOGIN='QueryFileUser'
GO

	SELECT
		[FILE].*	
		--,[Discipline].*
		--,[Discipline].[STU_INC_DISPOSITION_GU]
		,[Discipline].[DISPOSITION_DATE]
		,[Discipline].[DISPOSITION_ID]
		,[Discipline].[DAYS]
		,[Discipline].[DISP_CODE]
		,[Discipline].[DISPOSITION_DESCRIPTION]
		
		
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from Suspension_Data_2015_16_revisited.csv' 
		)AS [FILE]
		
		INNER JOIN
		APS.BasicStudent AS [STUDENT]
		ON
		[FILE].[Perm ID] = [STUDENT].[SIS_NUMBER]
		
		LEFT OUTER JOIN
		(
		SELECT
			[Discipline].[STUDENT_GU]
			,[Disposition].[DISPOSITION_DATE]
			,[Disposition].[DISPOSITION_ID]
			,[Discipline].[DAYS]
			,[Disposition_Code].[DISP_CODE]
			,[Disposition_Code].[DESCRIPTION] AS [DISPOSITION_DESCRIPTION]
		FROM				
			[rev].[EPC_STU_INC_DISCIPLINE] AS [Discipline]
			
			INNER JOIN
			[rev].[EPC_STU_INC_DISPOSITION] AS [Disposition]
			ON
			[Discipline].[STU_INC_DISPOSITION_GU] = [Disposition].[STU_INC_DISPOSITION_GU]
			
			INNER JOIN
			[rev].[EPC_CODE_DISP] AS [Disposition_Code]
			ON
			[Disposition].[CODE_DISP_GU] = [Disposition_Code].[CODE_DISP_GU]
			
		WHERE
			[Disposition_Code].[DISP_CODE] IN ('S OSS','S ISS', 'S BUS', 'S EXTRA',  'ZH504LTS', 'ZHLTSCON', 'ZHLTSCV', 'ZHLTSNRS', 'ZHLTSOTH', 'ZHLTSVQP', 'ZHSPLTS', 'EXPEL', 'ZH504EXP', 'ZHSPEXP', 'ZHEXP1YR')
			AND [Disposition].[DISPOSITION_DATE] BETWEEN '08/13/2014' AND '05/22/2015'
			--AND [Discipline].[DAYS] IS NOT NULL
		) AS [Discipline]
		ON
		[STUDENT].[STUDENT_GU] = [Discipline].[STUDENT_GU]
		--AND [FILE].[Incident Date] = [Discipline].[DISPOSITION_DATE]
		
	--WHERE
	--	[FILE].[Perm ID] = '970024021'
		
	
REVERT
GO