
EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT * FROM 
(
SELECT 
 DISTINCT ID_NBR, STATE_STUDENT_NUMBER, SCH_YR
FROM
  	
			OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT* FROM COMBOESL.csv'
                ) AS [T1]
INNER JOIN 
rev.EPC_STU AS STU
ON
STU.SIS_NUMBER = T1.ID_NBR

WHERE COURSE != 'NULL'

) AS T2

PIVOT 
(
MAX(SCH_YR)
FOR SCH_YR IN ([2014-2015], [2013-2014], [2012-2013], [2011-2012])
)AS PIVOTME

REVERT 
GO