





EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT
	*
FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SynTempSSIS.aps.edu.actd\Files\TempQuery\;HDR=YES;', 
		'SELECT * from Active_Native_American_Students_030916.csv'
		) AS [FILE]

REVERT
GO