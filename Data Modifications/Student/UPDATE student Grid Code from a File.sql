

/***************************************************************************************

CREATED BY DEBBIE ANN CHAVEZ
DATE 2/1/2018

CHANGE A STUDENT'S GRID CODE FROM A FILE
-- THIS WAS USED FOR NEW ELEMENTARY SCHOOLS AND BOUNDARY CHANGES

*****************************************************************************************/

EXECUTE AS LOGIN='QueryFileUser'
GO


UPDATE rev.EPC_STU 
SET GRID_CODE = T1.[SY1819_GridCode], CHANGE_DATE_TIME_STAMP= GETDATE(), CHANGE_ID_STAMP = '27CDCD0E-BF93-4071-94B2-5DB792BB735F'

FROM(
SELECT 
	T1.APS_STUID, SY1819_GridCode, LASTNAME, FIRSTNAME
	, STU.SIS_NUMBER, STU.GRID_CODE
	,STU.STUDENT_GU
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from OrigFile2018Street.csv'
                ) AS [T1]

INNER JOIN 
REV.EPC_STU AS STU
ON
T1.APS_STUID = STU.SIS_NUMBER
) AS T2

WHERE
T2.STUDENT_GU = rev.EPC_STU.STUDENT_GU

ROLLBACK
	
REVERT
GO