
BEGIN TRAN

DELETE REV.EPC_STU_PGM_ELL_BEP

FROM(
SELECT * FROM (
SELECT 
	ROW_NUMBER() OVER (PARTITION BY STUDENT_GU, PROGRAM_CODE, PROGRAM_INTENSITY ORDER BY PROGRAM_CODE, PROGRAM_INTENSITY ) AS RN
	,STUDENT_GU
	,PROGRAM_CODE
	,PROGRAM_INTENSITY
	,BEP.STU_PGM_ELL_BEP_GU
 FROM 
REV.EPC_STU_PGM_ELL_BEP AS BEP
WHERE
EXIT_DATE IS NULL

) AS COUNTME
WHERE
RN > 1
) AS DELEMET

WHERE
DELEMET.STU_PGM_ELL_BEP_GU = REV.EPC_STU_PGM_ELL_BEP.STU_PGM_ELL_BEP_GU

COMMIT


