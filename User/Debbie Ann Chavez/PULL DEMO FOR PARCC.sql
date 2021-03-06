
EXECUTE AS LOGIN='QueryFileUser'
GO


SELECT DISTINCT
 STU.STATE_STUDENT_NUMBER
 ,PRIM.GRADE
 ,BS.RESOLVED_RACE
 ,BS.ELL_STATUS
 ,BS.SPED_STATUS
,PARCC.* 

FROM

            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                  'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
                  'SELECT * from PARCC2.csv'
                ) AS PARCC

LEFT HASH JOIN 
rev.EPC_STU AS STU 

ON
PARCC.StudentID = STU.STATE_STUDENT_NUMBER

LEFT HASH JOIN
(SELECT DISTINCT 
	STUDENT_GU
	,VALUE_DESCRIPTION AS GRADE
FROM
APS.EnrollmentsForYear('26F066A3-ABFC-4EDB-B397-43412EDABC8B') AS ENROLL
INNER JOIN
APS.LookupTable ('K12', 'Grade') AS GRADE
ON
ENROLL.GRADE = GRADE.VALUE_CODE
) AS PRIM

ON
PRIM.STUDENT_GU = STU.STUDENT_GU

LEFT HASH JOIN
APS.BasicStudentWithMoreInfo AS BS
ON
STU.STUDENT_GU = BS.STUDENT_GU

      REVERT
GO