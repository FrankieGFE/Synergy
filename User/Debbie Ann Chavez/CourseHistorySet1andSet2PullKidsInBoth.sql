

EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT SET2.*

FROM

            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT DISTINCT SIS_NUMBER from SET1ALL.csv'
                ) AS [SET1]

INNER JOIN 
	

	OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT * from SET2ALL.csv'
                ) AS [SET2]

ON
SET1.SIS_NUMBER = SET2.SIS_NUMBER


REVERT 
GO