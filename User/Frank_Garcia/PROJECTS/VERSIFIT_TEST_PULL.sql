SELECT 
    STUDENT_ID AS SIS_NUMBER
    --,DTBL_STUDENTS.STUDENT_GRADUATION_COHORT
    ,TEST_NAME
    --,TEST_EXTERNAL_CODE AS TEST_WINDOW
    ,DTBL_SCHOOLS.SCHOOL_CODE
    ,TEST_STUDENT_GRADE
	,LOCAL_SCHOOL_YEAR
    --,YEAR_VALUE AS YEAR
    ,TEST_PRODUCT 
    --,TEST_SUBJECT AS CONTENT_AREA
    ,DTBL_CALENDAR_DATES.DATE_VALUE AS TEST_DATE
    ,TEST_SCORE_VALUE AS SCORE
    ,TEST_PRIMARY_RESULT AS PERFORMANCE_LEVEL
    ,TEST_NAME
    ,TEST_CLASS
    ,TEST_GROUP
    ,TEST_SUBGROUP
    ,TEST_ADMIN_PERIOD
FROM K12INTEL_DW.FTBL_TEST_SCORES
INNER JOIN K12INTEL_DW.DTBL_TESTS
ON DTBL_TESTS.TESTS_KEY = FTBL_TEST_SCORES.TESTS_KEY 
INNER JOIN K12INTEL_DW.DTBL_STUDENTS 
ON DTBL_STUDENTS.STUDENT_KEY = FTBL_TEST_SCORES.STUDENT_KEY 
INNER JOIN K12INTEL_DW.DTBL_SCHOOLS
ON DTBL_SCHOOLS.SCHOOL_KEY = FTBL_TEST_SCORES.SCHOOL_KEY
INNER JOIN K12INTEL_DW.DTBL_CALENDAR_DATES
ON DTBL_CALENDAR_DATES.CALENDAR_DATE_KEY= FTBL_TEST_SCORES.CALENDAR_DATE_KEY
INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES
ON DTBL_SCHOOL_DATES.SCHOOL_DATES_KEY = FTBL_TEST_SCORES.SCHOOL_DATES_KEY 
WHERE TEST_PRODUCT = 'Stepping Stones'
--WHERE TEST_PRODUCT = 'dibels next'
--AND TEST_SUBGROUP IN ('TOT','Composite')
--AND LOCAL_SCHOOL_YEAR = '2014-2015'
ORDER BY LOCAL_SCHOOL_YEAR


