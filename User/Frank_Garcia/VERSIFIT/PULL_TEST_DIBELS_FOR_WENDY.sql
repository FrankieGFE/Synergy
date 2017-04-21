SELECT DISTINCT
    SIS_SCHOOL_YEAR AS 'School Year'
	,STUD.STUDENT_ID AS 'Student APS ID'
	,SDET.STUDENT_STATE_ID AS 'Student STATE_ID'
    ,TEST_PRIMARY_RESULT AS 'Dibels Performance Level'
    ,CAST(TEST_SCORE_VALUE AS INT) AS 'Dibels Raw Score'
 --   ,STUD.STUDENT_GRADUATION_COHORT
    --,TEST_NAME
    --,TEST_EXTERNAL_CODE AS TEST_WINDOW
 --   ,DTBL_SCHOOLS.SCHOOL_CODE
 --   ,TEST_STUDENT_GRADE
 --   ,YEAR_VALUE AS YEAR
 --   ,TEST_PRODUCT 
    --,TEST_SUBJECT AS CONTENT_AREA
    --,DTBL_CALENDAR_DATES.DATE_VALUE AS TEST_DATE
 --   ,TEST_NAME
	--,SIS_SCHOOL_YEAR
    --,TEST_CLASS
    --,TEST_GROUP
    --,TEST_SUBGROUP
    --,TEST_ADMIN_PERIOD
FROM K12INTEL_DW.FTBL_TEST_SCORES
INNER JOIN K12INTEL_DW.DTBL_TESTS
ON DTBL_TESTS.TESTS_KEY = FTBL_TEST_SCORES.TESTS_KEY 
INNER JOIN K12INTEL_DW.DTBL_STUDENTS STUD
ON STUD.STUDENT_KEY = FTBL_TEST_SCORES.STUDENT_KEY 
INNER JOIN K12INTEL_DW.DTBL_SCHOOLS
ON DTBL_SCHOOLS.SCHOOL_KEY = FTBL_TEST_SCORES.SCHOOL_KEY
INNER JOIN K12INTEL_DW.DTBL_CALENDAR_DATES
ON DTBL_CALENDAR_DATES.CALENDAR_DATE_KEY= FTBL_TEST_SCORES.CALENDAR_DATE_KEY
INNER JOIN K12INTEL_DW.DTBL_SCHOOL_DATES
ON DTBL_SCHOOL_DATES.SCHOOL_DATES_KEY = FTBL_TEST_SCORES.SCHOOL_DATES_KEY 
JOIN
[K12INTEL_DW].[DTBL_STUDENT_DETAILS] AS SDET
ON SDET.STUDENT_ID = STUD.STUDENT_ID
WHERE 
1 = 1
AND TEST_PRODUCT = 'DIBELS NEXT'
AND TEST_SUBGROUP IN ('TOT','Composite')
AND LOCAL_SCHOOL_YEAR = '2015-2016'
--AND TEST_EXTERNAL_CODE = 'BEG'
--AND STUD.STUDENT_ID = '970084689'
