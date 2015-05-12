






EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT
	[PREVIOUS_FILE].[Code]
	,[PREVIOUS_FILE].[Cluster]
	,[PREVIOUS_FILE].[School]
	,[CURRENT_FILE].[PQ] AS [Req. 01B Current Year]
	,[PREVIOUS_FILE].[Last Year] AS [Req. 01B Prior Year]
	,[CURRENT_FILE].[Last Year NotElementary Schoolt] AS [Req. 01J Current Year]
	,[PREVIOUS_FILE].[YA] AS [Req. 01J Prior Year]
	,[CURRENT_FILE].[YA2] AS [Req. 01E Current Year]
	,[PREVIOUS_FILE].[PQ2] AS [Req. 01E Prior Year]
FROM
	OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\ALS EOY\;', 
			--'SELECT * from Personal_Needs_Profile_Export_20141125_FULL_DISTRICT.csv'
			'SELECT DISTINCT * from 1_E.csv' 
		)AS [PREVIOUS_FILE]
		
	LEFT OUTER JOIN
	OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\ALS EOY\;', 
			--'SELECT * from Personal_Needs_Profile_Export_20141125_FULL_DISTRICT.csv'
			'SELECT DISTINCT * from 1_E.csv' 
		)AS [CURRENT_FILE]
	ON
	[PREVIOUS_FILE].[School] = [CURRENT_FILE].[School]
		
		
REVERT
GO
		
		