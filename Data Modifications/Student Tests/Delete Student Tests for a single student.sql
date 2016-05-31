
/* Debbie Ann Chavez
 * 5/11/2016
 *
 * This removes student tests for a single student.  A student gu is needed.  And this only deletes from 3 tables.  
 * Run with SELECT first, if the records look correct then run with DELETE.  
 *
 *  If a student has several tests you may need to enter the TEST_DATE to the where condition also
 *
 */


-- delete the student scores
--BEGIN TRANSACTION
DECLARE @TestName NVARCHAR(MAX) = 'SP-LAS-LINKS'

BEGIN TRANSACTION 

DELETE
	StudentTestPartScore
--SELECT
--	*
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
	AND STUDENT_GU = '5A52B8B4-9A3E-4C83-BBA4-832F52F1EA7C'
	


-- delete the student test parts
-- ---------------------------------------------------------------------------------------
DELETE
	StudentTestPart
--SELECT
--	*
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
		AND STUDENT_GU = '5A52B8B4-9A3E-4C83-BBA4-832F52F1EA7C'

-- Delete the student test
-- ---------------------------------------------------------------------------------------
DELETE
	StudentTest
--SELECT
--	*
FROM
	rev.EPC_STU_TEST AS StudentTest
	INNER JOIN
	rev.EPC_TEST AS Test
	ON
	StudentTest.TEST_GU = Test.TEST_GU
WHERE
	Test.TEST_NAME = @TestName
	AND STUDENT_GU = '5A52B8B4-9A3E-4C83-BBA4-832F52F1EA7C'

ROLLBACK