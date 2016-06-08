


EXECUTE AS LOGIN='QueryFileUser'
GO

BEGIN TRANSACTION 
DELETE rev.EPC_STU_FEE
--DELETE rev.EPC_STU_FEE_WAIVER 
--DELETE rev.EPC_STU_FEE_REFUND
FROM 

(
SELECT 
	STU_FEE.*
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from STUFEE.TXT'
                ) AS [T1]
	
	INNER JOIN 
	rev.EPC_STU_FEE AS STU_FEE
	ON
	STU_FEE.STUDENT_FEE_GU = T1.STUDENT_FEE_GU 

) AS T1

WHERE
T1.STUDENT_FEE_GU = rev.EPC_STU_FEE.STUDENT_FEE_GU

ROLLBACK

REVERT
GO