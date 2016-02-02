


EXECUTE AS LOGIN='QueryFileUser'
GO
	SELECT
		*
		
		
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from Suspension_Details_B.csv where [SIS_NUMBER] is not null'
		)AS [FILEA]
		-- SIS_NUMBER
		-- Perm ID
		
		LEFT OUTER JOIN
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
			'SELECT * from Suspension_A2.csv where [Perm ID] is not null' 			
		)AS [FILEB]
		ON
		[FILEA].[SIS_NUMBER] = [FILEB].[Perm ID]
		AND [FILEA].[INCIDENT_DATE] = [FILEB].[Incident Date]
		
	WHERE
		[FILEB].[Perm ID] IS NULL
	
REVERT
GO