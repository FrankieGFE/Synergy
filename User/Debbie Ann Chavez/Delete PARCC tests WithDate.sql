

/* Brian Rieb
 * 8/22/2014
 *
 * This removes student tests by test name.  Theoretically you could also add
 * a date component to only remove certain student tests within a test/date range
 */


-- delete the student scores
BEGIN TRANSACTION
DECLARE @TestName NVARCHAR(MAX) = 'SBA HS Reading 2011+'
DECLARE @TestDate DATE = '2015-10-01'

DELETE
	StudentTestPartScore
--SELECT
--	COUNT(*)
FROM
	rev.EPC_STU_TEST AS StudentTest
	INNER JOIN
	rev.EPC_TEST AS Test
	ON
	StudentTest.TEST_GU = Test.TEST_GU
	
	INNER JOIN 
	rev.EPC_STU_TEST_PART AS StudentTestPart
	ON
	StudentTest.STUDENT_TEST_GU = StudentTestPart.STUDENT_TEST_GU

	INNER JOIN
	rev.EPC_STU_TEST_PART_SCORE AS StudentTestPartScore
	ON
	StudentTestPart.STU_TEST_PART_GU = StudentTestPartScore.STU_TEST_PART_GU 

WHERE
	Test.TEST_NAME LIKE 'PARCC%'
		AND StudentTest.ADMIN_DATE = @TestDate

-- delete the student test parts
-- ---------------------------------------------------------------------------------------
DELETE
	StudentTestPart
--SELECT
--	COUNT(*)
FROM
	rev.EPC_STU_TEST AS StudentTest
	INNER JOIN
	rev.EPC_TEST AS Test
	ON
	StudentTest.TEST_GU = Test.TEST_GU
	
	INNER JOIN 
	rev.EPC_STU_TEST_PART AS StudentTestPart
	ON
	StudentTest.STUDENT_TEST_GU = StudentTestPart.STUDENT_TEST_GU
WHERE
	Test.TEST_NAME LIKE 'PARCC%'
	AND StudentTest.ADMIN_DATE = @TestDate

-- Delete the student test
-- ---------------------------------------------------------------------------------------
DELETE
	StudentTest
--SELECT
--	COUNT(*)
FROM
	rev.EPC_STU_TEST AS StudentTest
	INNER JOIN
	rev.EPC_TEST AS Test
	ON
	StudentTest.TEST_GU = Test.TEST_GU
WHERE
	Test.TEST_NAME LIKE 'PARCC%'
		AND StudentTest.ADMIN_DATE = @TestDate

ROLLBACK
--COMMIT