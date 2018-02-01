

SELECT SIS_NUMBER, STATE_STUDENT_NUMBER, PARTICIPATION_STATUS FROM 
REV.EPC_STU_PGM_ELL_HIS AS HIS
INNER JOIN 
REV.EPC_STU AS STU
ON
HIS.STUDENT_GU = STU.STUDENT_GU
WHERE
EXIT_DATE IS NULL 
AND PARTICIPATION_STATUS IS NOT NULL
--AND SIS_NUMBER = 104115001