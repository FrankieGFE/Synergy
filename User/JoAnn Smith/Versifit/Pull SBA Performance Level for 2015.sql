;WITH SCIENCE_2015 
AS
(
SELECT DISTINCT ----TEST_NAME
    SIS_SCHOOL_YEAR AS 'School Year'
       ,STUD.STUDENT_ID AS 'Student APS ID'
       ,SDET.STUDENT_STATE_ID AS 'Student STATE_ID'
    ,TEST_PRIMARY_RESULT AS 'Science Overall Performance Level'
    ,CAST(TEST_SCALED_SCORE AS INT) AS 'Science Scale Score'
       ,TEST_NAME
       ,TEST_PRODUCT
       ,TEST_GROUP
       ,TEST_SUBGROUP
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
AND TEST_PRODUCT = 'SBA-NM'
AND TEST_GROUP = 'SCIENCE'
AND TEST_SUBGROUP = 'OVERALL'
AND LOCAL_SCHOOL_YEAR = '2015-2016' 
)
--SELECT * FROM SCIENCE_2015
--spanish 2015
,SPANISH_2015 
AS
(
SELECT DISTINCT ----TEST_NAME
    SIS_SCHOOL_YEAR AS 'School Year'
       ,STUD.STUDENT_ID AS 'Student APS ID'
       ,SDET.STUDENT_STATE_ID AS 'Student STATE_ID'
    ,TEST_PRIMARY_RESULT AS 'Spanish Overall Performance Level'
    ,CAST(TEST_SCALED_SCORE AS INT) AS 'Spanish Scale Score'
       ,TEST_NAME
       ,TEST_PRODUCT
       ,TEST_GROUP
       ,TEST_SUBGROUP
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
AND TEST_PRODUCT = 'SBA-NM'
AND TEST_GROUP = 'SBA-NM'
AND TEST_SUBGROUP = 'OVERALL'
AND LOCAL_SCHOOL_YEAR = '2015-2016' 
)
--SELECT * FROM SPANISH_2015
,RESULTS
AS
(
SELECT 	
	S15.[Student APS ID],
	'Science' as SUBJECT,
	S15.[Science Overall Performance Level] AS PERF_LEVEL,
	S15.[Science Scale Score] AS SCALED_SCORE
FROM	
	SCIENCE_2015 S15
union all
select
	SP15.[Student APS ID],
	'Spanish',
	SP15.[Spanish Overall Performance Level] AS SPANISH_2015_PERF_LEVEL,
	SP15.[Spanish Scale Score] AS SPANISH_2015_SCALED_SCORE
from
	SPANISH_2015 SP15
)
SELECT * INTO DBO.SBA_2015 FROM RESULTS
