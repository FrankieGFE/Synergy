EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT 
		t1.*

		FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from LutheranFamilysERVICESRequest.csv'
                ) AS [T1]
