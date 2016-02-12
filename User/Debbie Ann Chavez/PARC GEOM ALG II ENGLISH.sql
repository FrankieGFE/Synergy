

/*************************************************************
--PULL PARCC, JUST CHANGE TEST_NAME
TEST_NAME = 
'PARCC HS ELA/L English 11'
'PARCC HS Geometry'
'PARCC HS Algebra II'

*************************************************************/

SELECT 
	SIS_NUMBER
	,LAST_NAME
	,FIRST_NAME
	,TEST_NAME
	,PART_DESCRIPTION AS TEST
	,TEST_SCORE AS SCALE_SCORE
	,PERFORMANCE_LEVEL AS PL
	
FROM
(
SELECT 
	   row_number() over (partition by SIS_NUMBER order by CAST(test_score AS INT) desc) as high
	   ,PERSON.FIRST_NAME
       ,PERSON.LAST_NAME
       ,CAST (SIS_NUMBER AS INT) AS SIS_NUMBER
       ,TEST.TEST_NAME
	   ,PART.PART_DESCRIPTION
	   ,TEST.TEST_LEVEL
	   ,TEST.TEST_FORM
	   ,'' AS SCHOOL_YEAR
	   ,'' AS TEST_DESCRIPTION
	   ,TEST.TEST_TYPE
	   ,TEST.TEST_GROUP
	   ,TEST.TEST_DEF_CODE
       ,SCORE_DESCRIPTION
       ,STU_PART.PERFORMANCE_LEVEL
       ,SCORES.TEST_SCORE
       ,STUDENTTEST.ADMIN_DATE
       ,PART.PART_NUMBER

FROM
       rev.EPC_STU_TEST AS StudentTest

       JOIN
       rev.EPC_TEST_PART AS PART
       ON StudentTest.TEST_GU = PART.TEST_GU

       JOIN
       rev.EPC_STU_TEST_PART AS STU_PART
       ON PART.TEST_PART_GU = STU_PART.TEST_PART_GU
       AND STU_PART.STUDENT_TEST_GU = StudentTest.STUDENT_TEST_GU

		INNER JOIN
		rev.EPC_STU_TEST_PART_SCORE AS SCORES
		ON
		SCORES.STU_TEST_PART_GU = STU_PART.STU_TEST_PART_GU

		LEFT JOIN
		rev.EPC_TEST_SCORE_TYPE AS SCORET
		ON
		SCORET.TEST_GU = StudentTest.TEST_GU
		AND SCORES.TEST_SCORE_TYPE_GU = SCORET.TEST_SCORE_TYPE_GU

		LEFT JOIN
		rev.EPC_TEST_DEF_SCORE AS SCORETDEF
		ON
		SCORETDEF.TEST_DEF_SCORE_GU = SCORET.TEST_DEF_SCORE_GU

       LEFT JOIN
       rev.EPC_TEST AS TEST
       ON TEST.TEST_GU = StudentTest.TEST_GU

       INNER JOIN
       rev.EPC_STU AS Student
       ON Student.STUDENT_GU = StudentTest.STUDENT_GU

       INNER JOIN
       rev.REV_PERSON AS Person
       ON Person.PERSON_GU = StudentTest.STUDENT_GU

WHERE
       TEST_NAME = 'PARCC HS ELA/L English 11'

) AS T1
WHERE high = 1