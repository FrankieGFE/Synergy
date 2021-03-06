

EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT 
	ROW_NUMBER() OVER (PARTITION BY T2.SIS_NUMBER ORDER BY ENTRY_DATE) AS RN
	,T2.*
	
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from NEWELL.csv'
                ) AS [T1]

RIGHT JOIN 
(
SELECT HIST.*,STU.SIS_NUMBER FROM 
rev.EPC_STU_PGM_ELL_HIS AS HIST
INNER JOIN 
REV.EPC_STU AS STU
ON
HIST.STUDENT_GU = STU.STUDENT_GU
) AS T2
ON
T1.SIS_NUMBER = T2.SIS_NUMBER

WHERE
T1.SIS_NUMBER IS NULL

	
REVERT
GO