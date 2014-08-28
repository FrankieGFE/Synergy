DECLARE @asOfDate DATE = GETDATE()

SELECT
	ELLTests.TEST_GU
	,ELLTests.TEST_NAME
	,ELLTests.STUDENT_GU
	,ELLTests.ADMIN_DATE
	,ELLTests.Organization_GU
	,ELLTests.GRADE
	,ELLTests.PERFORMANCE_LEVEL
	,ELLTests.IS_ELL
FROM
	(
	SELECT
		TestDefinition.TEST_GU
		,TestDefinition.TEST_NAME
		,StudentTest.STUDENT_GU
		,StudentTest.ADMIN_DATE
		,StudentTest.Organization_GU
		,StudentTest.GRADE
		,StudentTestPart.PERFORMANCE_LEVEL
		,TestLevels.IS_ELL
		,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY ADMIN_DATE DESC) AS RN
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
	
		/* Shouldn't need this part as we only look at performance levels
		INNER JOIN
		rev.EPC_STU_TEST_PART_SCORE AS StudentTestPartScore
		ON
		StudentTestPart.STU_TEST_PART_GU = StudentTestPartScore.STU_TEST_PART_GU
		*/

		INNER JOIN
		rev.UD_ELL_TEST_ELIGIBILITY AS TestLevels
		ON
		StudentTestPart.PERFORMANCE_LEVEL = TestLevels.LEVEL
		AND TestDefinition.TEST_NAME = TestLevels.TEST

	WHERE
		TestDefinition.TEST_TYPE = 'ALTRN' -- ALL ELL tests
		AND StudentTest.ADMIN_DATE <= @asOfDate
	) AS ELLTests
WHERE
	ELLTests.RN = 1 -- most recent