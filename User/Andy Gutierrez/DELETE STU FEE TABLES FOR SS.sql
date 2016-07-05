/* the input file for this delete uses STUDENT_FEE_GU's that need to be determined for the students whos fees are to be deleted.
The GU's are included in a text file that gets read by this script.  The script needs to be run for each table below starting with
REFUND, WAIVER then FEE in that order.
*/

EXECUTE AS LOGIN='QueryFileUser'
GO

BEGIN TRANSACTION 
--DELETE rev.EPC_STU_FEE
--DELETE rev.EPC_STU_FEE_WAIVER 
DELETE rev.EPC_STU_FEE_REFUND
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