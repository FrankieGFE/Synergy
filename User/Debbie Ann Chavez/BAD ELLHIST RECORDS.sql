

SELECT 
	*
FROM
(
SELECT
	SIS_NUMBER
	,ONLY1TEST.STUDENT_GU
	,ELLTests.TEST_NAME
	,ELLTests.ADMIN_DATE
	,ELLTests.PERFORMANCE_LEVEL
	,ELLTests.TEST_SCORE
	,ELLTests.IS_ELL
FROM
(
SELECT STUDENT_GU
FROM
(
SELECT 
		COUNT (*) AS THECOUNT, STUDENT_GU
	FROM
		rev.EPC_TEST AS TestDefinition
		INNER JOIN
		rev.EPC_STU_TEST AS StudentTest
		ON
		TestDefinition.TEST_GU = StudentTest.TEST_GU
			INNER JOIN
		rev.EPC_STU_TEST_PART AS StudentTestPart
		ON
		StudentTest.STUDENT_TEST_GU = StudentTestPart.STUDENT_TEST_GU

	WHERE
		TestDefinition.TEST_TYPE = 'ALTRN' -- ALL ELL tests
		AND StudentTest.ADMIN_DATE <= GETDATE()
		AND StudentTestPart.PERFORMANCE_LEVEL != 'INCOM'  -- If a test has an incomplete performance level, do not use it

		GROUP BY STUDENT_GU
) AS T1
WHERE
	THECOUNT = 1
) AS ONLY1TEST

INNER JOIN 
(
	SELECT
		TestDefinition.TEST_GU
		,TestDefinition.TEST_NAME
		,StudentTest.STUDENT_GU
		,StudentTest.STUDENT_TEST_GU
		,StudentTest.ADMIN_DATE
		,StudentTest.Organization_GU
		,StudentTest.GRADE
		,StudentTestPart.PERFORMANCE_LEVEL
		,StudentTestPartScore.TEST_SCORE
		--,COALESCE(TestLevels.IS_ELL,-1) AS IS_ELL
		,IS_ELL
	FROM
		rev.EPC_TEST AS TestDefinition
		INNER JOIN
		rev.EPC_STU_TEST AS StudentTest
		ON
		TestDefinition.TEST_GU = StudentTest.TEST_GU

		--assuming one part per ELL Test only
		INNER JOIN
		rev.EPC_STU_TEST_PART AS StudentTestPart
		ON
		StudentTest.STUDENT_TEST_GU = StudentTestPart.STUDENT_TEST_GU
	
		--Shouldn't need this part as we only look at performance levels
		INNER JOIN
		rev.EPC_STU_TEST_PART_SCORE AS StudentTestPartScore
		ON
		StudentTestPart.STU_TEST_PART_GU = StudentTestPartScore.STU_TEST_PART_GU
		

		LEFT JOIN
		rev.UD_ELL_TEST_ELIGIBILITY AS TestLevels
		ON
		StudentTestPart.PERFORMANCE_LEVEL = TestLevels.LEVEL
		AND TestDefinition.TEST_NAME = TestLevels.TEST
		AND StudentTestPartScore.TEST_SCORE BETWEEN TestLevels.VALUE_FROM AND TestLevels.VALUE_TO
		
	WHERE
		TestDefinition.TEST_TYPE = 'ALTRN' -- ALL ELL tests
		AND StudentTest.ADMIN_DATE <= GETDATE()
		AND StudentTestPart.PERFORMANCE_LEVEL != 'INCOM'  -- If a test has an incomplete performance level, do not use it

	) AS ELLTests

	ON
	ONLY1TEST.STUDENT_GU = ELLTests.STUDENT_GU

	INNER JOIN
	rev.EPC_STU AS STUDENT
	ON
	ONLY1TEST.STUDENT_GU = STUDENT.STUDENT_GU


WHERE IS_ELL = 0 OR
PERFORMANCE_LEVEL = 'FEP'

) AS FEP1RECORD
/*
INNER JOIN
rev.EPC_STU_PGM_ELL_HIS AS HISTORY
ON
FEP1RECORD.STUDENT_GU = HISTORY.STUDENT_GU
*/
ORDER BY SIS_NUMBER