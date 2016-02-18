

EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT SET2.*

FROM

		(SELECT * FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT DISTINCT SIS_NUMBER, SCHOOL_COURSE_TAKEN from ForChristine.csv'
                ) AS [SET1]
		WHERE
			SCHOOL_COURSE_TAKEN LIKE 'OUT%'
		) AS T1

INNER JOIN 
	

	OPENROWSET ( 
                  'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT * from ForChristine.csv'
                ) AS [SET2]

ON
T1.SIS_NUMBER = SET2.SIS_NUMBER



REVERT 
GO