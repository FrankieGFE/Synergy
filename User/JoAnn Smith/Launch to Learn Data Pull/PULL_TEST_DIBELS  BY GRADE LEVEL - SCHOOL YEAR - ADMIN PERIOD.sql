

--************************************************************************
-- NOTE:  DIEBELS WAS REPLACED BY STEPPING STONES FOR THE SCHOOL YEAR 2016
-- use product type = 'Stepping Stones'
--************************************************************************
SELECT [School Year], [Student APS ID], [Test Name], [Grade Level], Score, [Diebels Proficiency Level] FROM
(SELECT 
	ROW_NUMBER() OVER (PARTITION BY STUDENT_ID ORDER BY cast (substring(TEST_STUDENT_GRADE,(PATINDEX('%[0-9]%',TEST_STUDENT_GRADE)),len(TEST_STUDENT_GRADE))as int)
	--the cast sorts the grade levels in the correct order 
 DESC) AS RN,
	SIS_SCHOOL_YEAR as [School Year],
	STUDENT_ID AS [Student APS ID],
    --,DTBL_STUDENTS.STUDENT_GRADUATION_COHORT
    TEST_NAME as [Test Name],
    --,TEST_EXTERNAL_CODE AS TEST_WINDOW
    --,DTBL_SCHOOLS.SCHOOL_CODE
    TEST_STUDENT_GRADE as [Grade Level],
    YEAR_VALUE AS YEAR,
    --,TEST_PRODUCT 
    --,TEST_SUBJECT AS CONTENT_AREA
	DTBL_CALENDAR_DATES.DATE_VALUE AS TEST_DATE,
    TEST_SCORE_VALUE AS Score,
	--
    TEST_PRIMARY_RESULT AS [Diebels Proficiency Level]
    --,TEST_NAME
    --,TEST_CLASS
    --,TEST_GROUP
    --,TEST_SUBGROUP
    --,TEST_ADMIN_PERIOD
FROM
	 K12INTEL_DW.FTBL_TEST_SCORES
INNER JOIN
	 K12INTEL_DW.DTBL_TESTS ON DTBL_TESTS.TESTS_KEY = FTBL_TEST_SCORES.TESTS_KEY 
INNER JOIN
	 K12INTEL_DW.DTBL_STUDENTS ON DTBL_STUDENTS.STUDENT_KEY = FTBL_TEST_SCORES.STUDENT_KEY 
INNER JOIN
	 K12INTEL_DW.DTBL_SCHOOLS ON DTBL_SCHOOLS.SCHOOL_KEY = FTBL_TEST_SCORES.SCHOOL_KEY
INNER JOIN
	 K12INTEL_DW.DTBL_CALENDAR_DATES ON DTBL_CALENDAR_DATES.CALENDAR_DATE_KEY= FTBL_TEST_SCORES.CALENDAR_DATE_KEY
INNER JOIN
	 K12INTEL_DW.DTBL_SCHOOL_DATES ON DTBL_SCHOOL_DATES.SCHOOL_DATES_KEY = FTBL_TEST_SCORES.SCHOOL_DATES_KEY 
WHERE
	TEST_PRODUCT = 'DIBELS Next'
	AND TEST_SUBGROUP IN ('TOT','Composite')
	AND SIS_SCHOOL_YEAR = '2015'
	AND TEST_ADMIN_PERIOD = 'MOY'
	AND TEST_STUDENT_GRADE IN ('P1', 'P2', 'PK', 'K', '01', '02', '03', '04', '05', '06', '07', '08')
	--AND STUDENT_ID = '980011869'
) AS T1
WHERE
	 RN = 1
ORDER BY
	 [Grade Level], [Student APS ID] 

--970063910
--980004712
--970095140
--980007774
--970095140
--970104040
--980011869
