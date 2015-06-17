






EXECUTE AS LOGIN='QueryFileUser'
GO

DECLARE @Cluster varchar(50) = 'Albuquerque High School Cluster'

SELECT
	[PREVIOUS_FILE].[Code]
	,[PREVIOUS_FILE].[Cluster]
	,[PREVIOUS_FILE].[School]
	,CASE WHEN [CURRENT_FILE].[5B] IS NULL THEN '--' ELSE CONVERT(VARCHAR(2),[CURRENT_FILE].[5B]) END AS [Req. 05B Current Year]
	,CASE WHEN [PREVIOUS_FILE].[Last Year] IS NULL THEN '--' ELSE CONVERT(VARCHAR,[PREVIOUS_FILE].[Last Year]) END AS [Req. 05B Prior Year]
	,CASE WHEN [CURRENT_FILE].[5C] IS NULL THEN '--' ELSE CONVERT(VARCHAR,[CURRENT_FILE].[5C]) END AS [Req. 05C Current Year]
	,CASE WHEN [PREVIOUS_FILE].[YA] IS NULL THEN '--' ELSE CONVERT(VARCHAR,[PREVIOUS_FILE].[YA]) END AS [Req. 05C Prior Year]
	,CASE WHEN [CURRENT_FILE].[5D] IS NULL THEN '--' ELSE CONVERT(VARCHAR,[CURRENT_FILE].[5D]) END AS [Req. 05D Current Year]
	,CASE WHEN [PREVIOUS_FILE].[D_CY] IS NULL THEN '--' ELSE CONVERT(VARCHAR,[PREVIOUS_FILE].[D_CY]) END AS [Req. 05D Prior Year]
FROM
	OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\ALS EOY\;',
			'SELECT * from Section_5.csv' 
		)AS [PREVIOUS_FILE]
		
	LEFT OUTER JOIN
	(
	SELECT
		[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
		,[CURRENT_FILE].*
	FROM
		OPENROWSET (
				'Microsoft.ACE.OLEDB.12.0', 
				'Text;Database=\\SynTempSSIS\Files\TempQuery\ALS EOY\;', 
				'SELECT * FROM FILEB_2.csv'  
			)AS [CURRENT_FILE]
			
		INNER JOIN
		rev.EPC_SCH AS [School]
		ON
		CONVERT(VARCHAR(3),[CURRENT_FILE].[LOC #]) = [School].[SCHOOL_CODE]
		
		INNER JOIN
		rev.REV_ORGANIZATION AS [Organization]
		ON
		[School].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		)AS [CURRENT_FILE]
	ON
	[PREVIOUS_FILE].[School] = [CURRENT_FILE].[SCHOOL_NAME]
	
WHERE
	[PREVIOUS_FILE].[Cluster] = @Cluster
	

--SELECT
--	*
--FROM
--	OPENROWSET (
--			'Microsoft.ACE.OLEDB.12.0', 
--			'Text;Database=\\SynTempSSIS\Files\TempQuery\ALS EOY\;',
--			'SELECT DISTINCT [Cluster] from 1_E.csv' 
--		)AS [PREVIOUS_FILE]
		
		
REVERT
GO
		
		