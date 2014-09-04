
/*
 * Debbie Ann Chavez
 * 9/3/2014
 * 
 */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[LCELatestSpanishEvaluationAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.LCELatestSpanishEvaluationAsOf()RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
 * FUNCTION APS.LCELatestSpanishEvaluationAsOf
 * Pulls latest applicable test, proficiency level, and ell eligibilty
 * for LCE determinations
 * Tables Used: EPC_TEST, EPC_STU_TEST, EPC_STU_TEST_PART, UD_ELL_TEST_ELIGIBILITY
 *
 * #param DATETIME @asOfDate Date to pull Test Score data from
 * 
 * #return TABLE per student, test information on the latest applicable test
 */
 
ALTER FUNCTION APS.LCELatestSpanishEvaluationAsOf(@asOfDate DATETIME)
RETURNS TABLE
AS
RETURN
SELECT
	ELLTests.TEST_GU
	,ELLTests.TEST_NAME
	,ELLTests.STUDENT_GU
	,ELLTests.ADMIN_DATE
	,ELLTests.Organization_GU
	,ELLTests.GRADE
	,ELLTests.PERFORMANCE_LEVEL
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
		,ROW_NUMBER() OVER (PARTITION BY STUDENT_GU ORDER BY ADMIN_DATE DESC) AS RN
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
		TestDefinition.TEST_TYPE = 'ALTSP' -- Spanish Assessments
		AND StudentTest.ADMIN_DATE <= @asOfDate
		AND StudentTestPart.PERFORMANCE_LEVEL != 'INCOM'  -- If a test has an incomplete performance level, do not use it
	) AS ELLTests
WHERE
	ELLTests.RN = 1 -- most recent