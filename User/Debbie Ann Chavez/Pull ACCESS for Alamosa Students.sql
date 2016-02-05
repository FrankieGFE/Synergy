


SELECT * FROM (

SELECT 
       SCHOOL
	   ,SYN.FIRST_NAME
       ,SYN.LAST_NAME
      -- ,ACCU.STUDENT_CODE
       ,SIS_NUMBER
       ,GRADE
	   ,TEST_NAME
      -- ,ACCU.TEST_SECTION_NAME
       ,PART_DESCRIPTION
       ,SCORE_DESCRIPTION
       ,PERFORMANCE_LEVEL
       ,TEST_SCORE
       --,ACCU.SCALED_SCORE
       ,CAST (ADMIN_DATE AS DATE) AS DATES
       ,ADMIN_DATE
       ,PART_NUMBER
	   ,ROW_NUMBER() OVER (PARTITION BY SIS_NUMBER ORDER BY ADMIN_DATE DESC) AS RN
FROM
(
SELECT 
       ORG.ORGANIZATION_NAME AS SCHOOL
	   ,PERSON.FIRST_NAME
       ,PERSON.LAST_NAME
       ,SIS_NUMBER
       ,Enroll.GRADE
	   ,TEST.TEST_NAME
   	   ,PART_DESCRIPTION
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

       INNER JOIN
       (SELECT DISTINCT STUDENT_GU, ORGANIZATION_YEAR_GU, GRADE FROM 
		APS.StudentEnrollmentDetails
		WHERE
		SCHOOL_YEAR = '2015'
		AND EXTENSION = 'R'
		AND SCHOOL_CODE = '210'
		AND SUMMER_WITHDRAWL_CODE IS NULL
	   
	  )  AS Enroll
	   
	   
	   ON
       StudentTest.STUDENT_GU = Enroll.STUDENT_GU

       INNER JOIN
       rev.REV_ORGANIZATION_YEAR AS OrgYear
       ON
       Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

       INNER JOIN
       rev.REV_ORGANIZATION AS Org
       ON
       OrgYear.ORGANIZATION_GU = Org.ORGANIZATION_GU


WHERE
       TEST_NAME like '%ACCESS%'
	
) AS SYN

) AS T1
WHERE
RN = 1

ORDER BY SIS_NUMBER
