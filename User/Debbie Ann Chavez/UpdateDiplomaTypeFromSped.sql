

EXECUTE AS LOGIN='QueryFileUser'
GO

BEGIN TRANSACTION 

UPDATE REV.EPC_STU 
	SET DIPLOMA_TYPE = CHANGE_DIP 

FROM
(
SELECT 
	T1.*, STU.DIPLOMA_TYPE
	,CASE WHEN [SE EOY Record] = 'Career Option' THEN '03'
			WHEN [SE EOY Record] = 'Ability Option' THEN '04'
			WHEN [SE EOY Record] = 'Standard Option' THEN '01'
	END AS CHANGE_DIP
	,STU.STUDENT_GU

	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from DiplomaMismatch.csv'
                ) AS [T1]

	LEFT JOIN 
		rev.EPC_STU AS STU
		ON
		T1.[Perm ID] = STU.SIS_NUMBER
) AS T2

WHERE
rev.EPC_STU.STUDENT_GU = T2.STUDENT_GU

COMMIT  
	
REVERT
GO