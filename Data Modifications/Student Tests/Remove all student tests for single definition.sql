/* Brian Rieb
 * 8/22/2014
 *
 * This removes student tests by test name.  Theoretically you could also add
 * a date component to only remove certain student tests within a test/date range
 */


-- delete the student scores
BEGIN TRANSACTION
DECLARE @TestName NVARCHAR(MAX) = 'WAPT'

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
	Test.TEST_NAME = @TestName

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
	Test.TEST_NAME = @TestName

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
	Test.TEST_NAME = @TestName

ROLLBACK