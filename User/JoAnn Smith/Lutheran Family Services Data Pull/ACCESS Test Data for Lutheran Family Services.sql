	--can take WAPT only once
	--ACCESS can be taken multiple years




EXECUTE AS LOGIN='QueryFileUser'
GO

with STUDENTCTE(LASTNAME, FIRSTNAME, SISNUMBER, STATENUMBER)
AS
(

SELECT
	 [Student Last Name], 
	 [Student First Name],
	 APS_ID,
	 BS.STATE_STUDENT_NUMBER



	 --ROWNUM, FIRSTNAME, LASTNAME, SISNUMBER, TESTNAME,  PERFLEVEL, TESTSCORE, ADMINDATE           
FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SYNTEMPSSIS\Files\TempQuery;',
		'SELECT * from LutheranFamilyServicesRequest.csv')
INNER JOIN
	APS.BasicStudentWithMoreInfo BS
	ON BS.SIS_NUMBER = APS_ID
                ) 
--SELECT * FROM STUDENTCTE

,
TESTCTE(ROWNUM, FIRSTNAME, LASTNAME, SISNUMBER, TESTNAME, PERFLEVEL, TESTSCORE, TESTDATE)
AS
(

SELECT 
          ROW_NUMBER () OVER (PARTITION BY SIS_NUMBER ORDER BY TEST_SCORE DESC) AS ROWNUM
        ,PERSON.FIRST_NAME
       ,PERSON.LAST_NAME
       ,CAST (SIS_NUMBER AS INT) AS SIS_NUMBER
       ,TEST.TEST_NAME
       ,STU_PART.PERFORMANCE_LEVEL AS PL
       ,SCORES.TEST_SCORE
       ,STUDENTTEST.ADMIN_DATE
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

       LEFT OUTER JOIN
       rev.EPC_STU AS Student
       ON Student.STUDENT_GU = StudentTest.STUDENT_GU

       INNER JOIN
       rev.REV_PERSON AS Person
       ON Person.PERSON_GU = StudentTest.STUDENT_GU

       LEFT JOIN
       APS.PrimaryEnrollmentsAsOf(GETDATE()) AS Enroll
       ON
       StudentTest.STUDENT_GU = Enroll.STUDENT_GU

       LEFT JOIN
       rev.REV_ORGANIZATION_YEAR AS OrgYear
       ON
       Enroll.ORGANIZATION_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

       LEFT JOIN
       rev.REV_ORGANIZATION AS Org
       ON
       OrgYear.ORGANIZATION_GU = Org.ORGANIZATION_GU

       LEFT JOIN
       APS.LookupTable('K12','Grade') AS GradeLevel
       ON
       Enroll.GRADE = GradeLevel.VALUE_CODE


WHERE
1 = 1
        AND TEST.TEST_NAME LIKE '%ACCESS%'
		AND SCORE_DESCRIPTION IN ('Overall LP')

)
,
RESULTCTE(FIRSTNAME, LASTNAME, SISNUMBER, TESTNAME, PERFLEVEL, TESTSCORE, TESTDATE)
AS
(
SELECT 
	LASTNAME,
	FIRSTNAME,
	SISNUMBER,
	TESTNAME,
	PERFLEVEL,
	TESTSCORE,
	TESTDATE
FROM TESTCTE
WHERE
 ROWNUM = 1
)

	SELECT
	 
	 STU.LASTNAME,
	 STU.FIRSTNAME,
	 STU.SISNUMBER,
	 STU.STATENUMBER,
	 RESULT.TESTNAME,
	 RESULT.PERFLEVEL,
	 RESULT.TESTSCORE,
	 RESULT.TESTDATE
	 --ROWNUM, FIRSTNAME, LASTNAME, SISNUMBER, TESTNAME,  PERFLEVEL, TESTSCORE, ADMINDATE           
FROM
	STUDENTCTE STU
LEFT OUTER JOIN
	RESULTCTE RESULT
	ON STU.SISNUMBER = RESULT.SISNUMBER
--WHERE
--	ROWNUM = 1
ORDER BY
	 STU.LASTNAME,
	 STU.FIRSTNAME

	REVERT
	GO