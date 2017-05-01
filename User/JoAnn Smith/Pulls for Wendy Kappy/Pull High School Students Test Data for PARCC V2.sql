/*
use this query for SW Creative Collaborations
data request from Wendy K

*/

--WITH PARCC_ALGII_PL 
--as
--(
--SELECT 
--    STUDENT_ID AS SIS_NUMBER
--    ,TEST_SCORE_VALUE AS SCORE
--    ,TEST_PRIMARY_RESULT AS PERFORMANCE_LEVEL
--    ,TEST_NAME
--    ,TEST_SUBJECT
--    ,TEST_SUBGROUP
--FROM
--	 K12INTEL_DW.FTBL_TEST_SCORES AS TS
--INNER JOIN
--	 K12INTEL_DW.DTBL_TESTS AS TSTS
--ON
--	 TSTS.TESTS_KEY = TS.TESTS_KEY 
--INNER JOIN
--	 K12INTEL_DW.DTBL_STUDENTS AS STUDS
--ON
--	 STUDS.STUDENT_KEY = TS.STUDENT_KEY 
--INNER JOIN
--	 K12INTEL_DW.DTBL_SCHOOLS AS SCH
--ON
--	 SCH.SCHOOL_KEY = TS.SCHOOL_KEY
--INNER JOIN
--	 K12INTEL_DW.DTBL_CALENDAR_DATES CD
--ON
--	 CD.CALENDAR_DATE_KEY= TS.CALENDAR_DATE_KEY
--INNER JOIN
--	 K12INTEL_DW.DTBL_SCHOOL_DATES SD
--ON
--	 SD.SCHOOL_DATES_KEY = TS.SCHOOL_DATES_KEY 
--	AND (TEST_NAME LIKE '%PARCC%')
--	AND LOCAL_SCHOOL_YEAR = '2015-2016'
--	AND TEST_SUBGROUP IN ('Reading','Writing','Overall')
--	AND TEST_NAME = 'PARCC � 07-12 - Algebra II � Overall'
--)

; WITH CTE1
AS
(
SELECT 
	   ROW_NUMBER() OVER(PARTITION BY SIS_NUMBER, TEST_NAME ORDER BY SIS_NUMBER) AS ROWNUM
       ,SIS_NUMBER AS 'APS STUDENT ID'
       ,STATE_ID AS 'STATE ID'
       ,'PARCC' AS 'TEST TYPE NAME'
       ,TEST_NAME as 'TEST SECTION NAME'
          ,CASE WHEN PERFORMANCE_LEVEL = 'Did Not Yet Meet Expectations' THEN '1'
                    WHEN PERFORMANCE_LEVEL = 'Approached Expectations' THEN '3'
                    WHEN  PERFORMANCE_LEVEL = 'Met Expectations' THEN '4'
                    WHEN  PERFORMANCE_LEVEL = 'Partially Met Expectations' THEN '2'
                    --WHEN  TEST_NAME = 'PARCC Grade 11 � English Language Arts � Writing' AND SCORE = '0' THEN 'PASS'
                    --WHEN TEST_NAME = 'PARCC Grade 11 � English Language Arts � Reading' AND SCORE = '0' THEN 'PASS'
                    ELSE 'FAIL'
           END AS 'SCORE GROUP CODE'
          ,PERFORMANCE_LEVEL AS 'SCORE GROUP NAME'
          ,SCORE AS 'SCALED SCORE'
         --,
       ,TEST_LEVEL  AS 'PARCC TEST LEVEL'

         --,STUDENT_LAST_NAME
         --,STUDENT_FIRST_NAME
FROM 
(
SELECT 
    DTBL_STUDENTS.STUDENT_ID AS SIS_NUMBER
       ,SD.STUDENT_STATE_ID AS STATE_ID
       ,ATT.STUDENT_CURRENT_GRADE_CODE AS TEST_LEVEL
    --,DTBL_STUDENTS.STUDENT_GRADUATION_COHORT
    ,YEAR_VALUE AS YEAR
       --,TEST_PRIMARY_RESULT
       ,TEST_NAME
       --,TEST_SUBGROUP
       --,STUDENT_LAST_NAME
       --,STUDENT_FIRST_NAME
       --,ALGII_PL.SCORE AS ALGII_PL
    ,DTBL_TESTS.TEST_SUBJECT AS CONTENT_AREA
    ,TEST_SCORE_VALUE AS SCORE
    ,TEST_PRIMARY_RESULT AS PERFORMANCE_LEVEL
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
INNER JOIN K12INTEL_DW.DTBL_STUDENT_ATTRIBS AS ATT
ON ATT.STUDENT_ATTRIB_KEY = K12INTEL_DW.FTBL_TEST_SCORES.STUDENT_ATTRIB_KEY
INNER JOIN K12INTEL_DW.DTBL_STUDENT_DETAILS AS SD
ON SD.STUDENT_ID = DTBL_STUDENTS.STUDENT_ID

WHERE 
1 = 1
AND (DTBL_TESTS.TEST_NAME LIKE '%PARCC%')
--AND TEST_PRODUCT = 'DIBELS Next'
--AND TEST_SUBGROUP IN ('TOT','Composite')
AND LOCAL_SCHOOL_YEAR = '2015-2016'
AND DTBL_TESTS.TEST_SUBGROUP IN ('Reading','Writing','Overall')
--AND TEST_EXTERNAL_CODE = 'BEG'
--AND STUDENT_ID = '104220389'
) AS PARCC
--PIVOT
--       (MAX(SCORE) FOR CONTENT_AREA IN ([MathEMATICS],[English Language Arts],[Writing],[READING],[ALGEBRA],[GEOMETRY])) AS UP1
--WHERE TEST_LEVEL in ('K', '01', '02', '03', '04', '05') 
--WHERE TEST_LEVEL in ('06', '07', '08')  
WHERE TEST_LEVEL in ('09', '10', '11', '12')
)
SELECT * FROM CTE1 WHERE ROWNUM = 1

--FIND DUPS
--SELECT COUNT([APS STUDENT ID]) AS [CT], [APS STUDENT ID]
--FROM CTE1 
--group by [APS STUDENT ID]
--HAVING COUNT([APS STUDENT ID]) >= 7
--ORDER BY [APS STUDENT ID]




