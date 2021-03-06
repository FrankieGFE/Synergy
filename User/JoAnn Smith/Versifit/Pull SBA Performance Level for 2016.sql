; with SCIENCE_2016 --includes very few reading scores because they were retakes (fall is when they do retakes)
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
AND LOCAL_SCHOOL_YEAR = '2016-2017' 
)
--select * from SCIENCE_2016
,SPANISH_2016
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
--AND TEST_GROUP = 'SBA-NM'
AND TEST_SUBGROUP = 'OVERALL'
AND LOCAL_SCHOOL_YEAR = '2016-2017' 
)
--SELECT * FROM SPANISH_2016
,RESULTS
AS
(
SELECT 	
	S16.[Student APS ID],
	'Science' as SUBJECT,
	S16.[Science Overall Performance Level] AS PERF_LEVEL,
	S16.[Science Scale Score] AS SCALED_SCORE
FROM	
	SCIENCE_2016 S16
union all
select
	SP16.[Student APS ID],
	'Spanish',
	SP16.[Spanish Overall Performance Level] AS SPANISH_2014_PERF_LEVEL,
	SP16.[Spanish Scale Score] AS SPANISH_2014_SCALED_SCORE
from
	SPANISH_2016 SP16
)
--select * from results
SELECT * INTO DBO.SBA_2016 FROM RESULTS

