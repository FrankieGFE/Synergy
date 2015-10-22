



EXECUTE AS LOGIN='QueryFileUser'
GO

	SELECT
		[STUDENT].*		
		
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from Algebra1UniqueIDs.csv' 
		)AS [FILE]
		
		INNER JOIN
		APS.BasicStudent AS [STUDENT]
		ON
		[FILE].[ID_NBR] = [STUDENT].[SIS_NUMBER]
		
		
	
REVERT
GO