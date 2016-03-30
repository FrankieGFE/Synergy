


EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT DISTINCT
	[Lost].[ModifiedDate]
FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SynTempSSIS.aps.edu.actd\Files\TempQuery\;HDR=YES;', 
		'SELECT * from APSDamagedBooks.csv'
		) AS [Lost]
		
WHERE
	[Lost].[CampusID] IN ('540','550','560','576','580')


REVERT
GO