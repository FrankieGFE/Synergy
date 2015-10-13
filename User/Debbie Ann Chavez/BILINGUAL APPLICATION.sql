
EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
	ROW_NUMBER() OVER (ORDER BY SCHOOLID) AS ID,
	*
FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT * from BEPSCHOOLID.csv'
                ) AS BEPSCHOOLID

      REVERT
GO

