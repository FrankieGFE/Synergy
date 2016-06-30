
EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT * FROM 
(
SELECT 
	T1.StudentID
	,STU.STATE_STUDENT_NUMBER
	,STU.SIS_NUMBER
	,LCE.TEST_NAME
	,LCE.ADMIN_DATE
	,LCE.PERFORMANCE_LEVEL
	,SCORE.TEST_SCORE
	,SCORETDEF.SCORE_DESCRIPTION
	
	FROM
            OPENROWSET (
                  'Microsoft.ACE.OLEDB.12.0', 
                 'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
                  'SELECT * from STATEIDASSESSMENTS.txt'
                ) AS [T1]

	LEFT JOIN 
	rev.EPC_STU AS STU
	ON
	T1.StudentID = STU.STATE_STUDENT_NUMBER

	LEFT JOIN 
	APS.LCELatestEvaluationAsOf(GETDATE()) AS LCE
	ON
	LCE.STUDENT_GU = STU.STUDENT_GU

	LEFT JOIN 
	rev.EPC_STU_TEST_PART AS PART
	ON
	LCE.STUDENT_TEST_GU = PART.STUDENT_TEST_GU

	LEFT JOIN 
	rev.EPC_STU_TEST_PART_SCORE AS SCORE
	ON
	SCORE.STU_TEST_PART_GU = PART.STU_TEST_PART_GU 

	 LEFT JOIN
    rev.EPC_TEST_SCORE_TYPE AS SCORET
    ON
    SCORET.TEST_GU = LCE.TEST_GU
    AND SCORE.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

    LEFT JOIN
    rev.EPC_TEST_DEF_SCORE AS SCORETDEF
    ON
    SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU
	) AS T1
	PIVOT
	(
	MAX(TEST_SCORE)
	FOR SCORE_DESCRIPTION IN ([Language Proficiency], [Scale],[Overall LP])
	) 
	AS PIVOTME 

WHERE STATE_STUDENT_NUMBER IS NOT NULL AND [Overall LP] IS NULL AND TEST_NAME IS NOT NULL


ORDER BY  PERFORMANCE_LEVEL DESC

REVERT
GO