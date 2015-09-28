

EXECUTE AS LOGIN='QueryFileUser'
GO



SELECT 
	CAREER.*, CASE WHEN PRIM.STUDENT_GU IS NOT NULL THEN 'X' ELSE '' END AS ENROLLED


 FROM
             OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT * from EXITYEARENROLLED.csv'
                ) AS [CAREER]

INNER JOIN 
rev.EPC_STU AS STU

ON
[CAREER].SIS_NUMBER = STU.SIS_NUMBER


INNER JOIN
APS.PrimaryEnrollmentsAsOf(GETDATE())AS PRIM
ON
PRIM.STUDENT_GU = STU.STUDENT_GU



      REVERT
GO