
EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT DISTINCT
CSVFILE.*, CSVFILE2.PHLOTE AS [120Day_PHLOTE], CSVFILE2.[ENGLISH PROFICIENCY] AS [120Day_ENGLISH_PROF]
FROM

    OPENROWSET (
            'Microsoft.ACE.OLEDB.12.0', 
            'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
            'SELECT * from 2_80Day.csv'
        ) AS CSVFILE

LEFT JOIN
	
	OPENROWSET (
            'Microsoft.ACE.OLEDB.12.0', 
            'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
            'SELECT * from 2_120Day.csv'
        ) AS CSVFILE2
ON
CSVFILE.ID_NBR = CSVFILE2.ID_NBR


      REVERT
GO