



EXECUTE AS LOGIN='QueryFileUser'
GO

	SELECT
		[FILE].*
		,[STUDENT].[GENDER]
		
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from AHAHS_RMAX_SY2013_14_Discipline_Data.csv' 
		)AS [FILE]
		
	LEFT OUTER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[FILE].[Student ID] = [STUDENT].[SIS_NUMBER]		
	
REVERT
GO