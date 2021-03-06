
SELECT * FROM (

SELECT DISTINCT
	SIS_NUMBER
	,STATE_STUDENT_NUMBER
	,'2015-2016' AS SCHOOL_YEAR
	,VALUE_DESCRIPTION AS [DUAL_LANG/BILINGUAL_PROGRAM_ENROLLMENT]
	,ROW_NUMBER() OVER (PARTITION BY BEP.STUDENT_GU ORDER BY BEP.ENTER_DATE DESC) AS RN
 FROM 
rev.EPC_STU_PGM_ELL_BEP AS BEP
INNER JOIN 
rev.EPC_STU AS STU
ON
BEP.STUDENT_GU = STU.STUDENT_GU
INNER JOIN 
APS.LookupTable('K12.ProgramInfo', 'BEP_PROGRAM_CODE') AS LU
ON
BEP.PROGRAM_CODE = LU.VALUE_CODE
WHERE
ENTER_DATE >= '2015-08-13'
AND (EXIT_DATE IS NULL OR EXIT_DATE <='2016-05-25')

) AS T1
WHERE
RN = 1