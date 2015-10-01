



EXECUTE AS LOGIN='QueryFileUser'
GO

	SELECT
		*		
		
	FROM
		--OPENROWSET (
		--	'Microsoft.ACE.OLEDB.12.0', 
		--	'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
		--	'SELECT * from ELL_SPED_Counts_and_Detail_EOY_2015.csv' 
		--)AS [FILE]
		
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from SPED_and_ELL_Students_091015.csv' 
		)AS [FILE]
		
		
	
REVERT
GO