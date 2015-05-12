






EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT
	[FILE1].[Code]
	,[FILE1].[Cluster]
	,[FILE1].[School]
	,[FILE2].[PQ] AS [Req. 01B Current Year]
	,[FILE1].[Last Year] AS [Req. 01B Prior Year]
	,[FILE2].[Last Year NotElementary Schoolt] AS [Req. 01J Current Year]
	,[FILE1].[YA] AS [Req. 01J Prior Year]
	,[FILE2].[YA2] AS [Req. 01E Current Year]
	,[FILE1].[PQ2] AS [Req. 01E Prior Year]
FROM
	OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\ALS EOY\;', 
			--'SELECT * from Personal_Needs_Profile_Export_20141125_FULL_DISTRICT.csv'
			'SELECT DISTINCT * from 1_E.csv' 
		)AS [FILE1]
		
	LEFT OUTER JOIN
	OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\ALS EOY\;', 
			--'SELECT * from Personal_Needs_Profile_Export_20141125_FULL_DISTRICT.csv'
			'SELECT DISTINCT * from 1_E.csv' 
		)AS [FILE2]
	ON
	[FILE1].[School] = [FILE2].[School]
		
		
REVERT
GO
		
		