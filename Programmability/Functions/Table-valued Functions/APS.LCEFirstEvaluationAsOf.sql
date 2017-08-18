

/****** Object:  UserDefinedFunction [APS].[LCELatestEvaluationAsOf]    Script Date: 6/27/2017 11:04:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/**
 * FUNCTION APS.LCELatestEvaluationAsOf
 * Pulls latest applicable test, proficiency level, and ell eligibilty
 * for LCE determinations
 * Tables Used: EPC_TEST, EPC_STU_TEST, EPC_STU_TEST_PART, UD_ELL_TEST_ELIGIBILITY
 *
 * #param DATETIME @asOfDate Date to pull Test Score data from
 * 
 * #return TABLE per student, test information on the latest applicable test
 */
CREATE FUNCTION [APS].[LCEFirstEvaluationAsOf](@asOfDate DATETIME)
RETURNS TABLE
AS
RETURN
SELECT
	ELLTests.TEST_GU
	,ELLTests.TEST_NAME
	,ELLTests.STUDENT_TEST_GU
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
		,StudentTest.STUDENT_TEST_GU
		,StudentTest.ADMIN_DATE
		,StudentTest.Organization_GU
		,StudentTest.GRADE
		,StudentTestPart.PERFORMANCE_LEVEL
		,COALESCE(TestLevels.IS_ELL,-1) AS IS_ELL
		,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY ADMIN_DATE) AS RN
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

		LEFT JOIN
		rev.UD_ELL_TEST_ELIGIBILITY AS TestLevels
		ON
		StudentTestPart.PERFORMANCE_LEVEL = TestLevels.LEVEL
		AND TestDefinition.TEST_NAME = TestLevels.TEST

	WHERE
		TestDefinition.TEST_TYPE = 'ALTRN' -- ALL ELL tests
		AND StudentTest.ADMIN_DATE <= @asOfDate
		AND StudentTestPart.PERFORMANCE_LEVEL != 'INCOM'  -- If a test has an incomplete performance level, do not use it
	) AS ELLTests
WHERE
	ELLTests.RN = 1 -- most recent
GO


