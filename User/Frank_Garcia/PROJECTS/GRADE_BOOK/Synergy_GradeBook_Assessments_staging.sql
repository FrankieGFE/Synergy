/*
* Count of questions and sum of total points within a test.
*/
IF OBJECT_ID('tempdb..#QUESTION_COUNT') IS NOT NULL
DROP TABLE #QUESTION_COUNT
SELECT   
    t.ID TESTID
    ,t.TESTNAME
    ,count(*) question_count
    ,sum(Q.points) total_points
INTO #QUESTION_COUNT
FROM K12INTEL_STAGING_EDP.EGB_TEST_ITEMBANK IB
INNER JOIN K12INTEL_STAGING_EDP.EGB_TEST_QUESTIONS Q
    ON Q.ITEMBANKID = IB.ID
INNER JOIN K12INTEL_STAGING_EDP.EGB_TEST t 
    on t.id = q.TESTID 
GROUP BY
    T.ID 
    ,T.TESTNAME

/*
Response information rate. Note that students may not have repsonses for all 
questions to get the right denominator you need to look at the points for
all of the questions within the test definitions. 

By Convention APS does not use weighted questions.

*/
IF OBJECT_ID('tempdb..#records') IS NOT NULL
DROP TABLE #records
SELECT   
    t.ID TESTID
    ,t.TESTNAME
    ,SCHD.DELETEDATE
    ,schd.STARTDATE
    ,schd.ENDDATE
    ,schd.NAME
    ,resp.STUDENTID
    ,schd.id as SCHEDULEDTESTID
    ,EGB_GRADE.GRADE
    ,sum(q.POINTS) question_points 
    ,MIN(CONVERT(DATE,resp.RESPONSEDATE)) MIN_RESPONSE_DATE
    ,MAX(CONVERT(DATE,resp.RESPONSEDATE)) MAX_RESPONSE_DATE
    ,count(*) rec_count
    ,sum(case when resp.CORRECT = 1 then 1 else 0 end ) count_correct
    ,sum(resp.POINTS) response_points
INTO #RECORDS
FROM K12INTEL_STAGING_EDP.EGB_TEST_ITEMBANK IB
INNER JOIN K12INTEL_STAGING_EDP.EGB_TEST_QUESTIONS Q
    ON Q.ITEMBANKID = IB.ID
INNER JOIN K12INTEL_STAGING_EDP.EGB_TEST t 
    on t.id = q.TESTID 
INNER join K12INTEL_STAGING_EDP.EGB_GRADE
    on EGB_GRADE.ID= t.GRADEID
INNER JOIN K12INTEL_STAGING_EDP.EGB_TEST_SCHEDULED schd
    on schd.testid = t.id
INNER JOIN K12INTEL_STAGING_EDP.EGB_TEST_STUDENTRESPONSES resp
    on resp.SCHEDULEDTESTID=schd.ID
    and ib.ID= resp.QUESTIONID
INNER JOIN K12INTEL_STAGING_EDP.egb_people stu 
    on stu.id = resp.STUDENTID
WHERE 1=1
GROUP BY     
    t.ID 
    ,t.TESTNAME
    ,schd.STARTDATE
    ,SCHD.DELETEDATE
    ,schd.ENDDATE
    ,schd.NAME
    ,EGB_GRADE.GRADE
    ,resp.STUDENTID
    ,schd.id 
/
INSERT INTO [K12INTEL_USERDATA].[XTBL_TESTS](
	[TEST_NUMBER]
	, [DISTRICT_CODE]
    , [TEST_CLASS]
	, [TEST_NAME]
    , [TEST_SHORT_NAME]
    , [TEST_GROUP]
    , [TEST_SUBGROUP]
    , [TEST_TYPE]    
	, [TEST_SUBJECT]
    , [COURSES_SUBJECT]
    , [CURRICULUM_CODE]
    , [TEST_GRADE_GROUP]
    , [TEST_METHOD]
    , [TEST_EXTERNAL_CODE]
    , [TEST_STATUS]
	, [TEST_VENDOR]
	, [TEST_PRODUCT]
	, [TEST_VERSION]
	, [TEST_SORT_ORDER]
    , [TEST_ALPHA_SORT]
	, [TEST_DESCRIPTION]
	, [TEST_CONTROL_GROUP_CODE]
    , [TEST_BENCHMARK_CONTROL_CODE]
	, [TEST_SCORE_FACTOR]
	, [ETL_REF_BENCHMARK_NAME]
    , [ETL_REF_BENCHMARK_MEASURE]
	, [ETL_CUSTOM_BENCHMARK_NAME]
	, [ETL_CUSTOM_BENCHMARK_MEASURE]
    , [ATTENTION_REQUIRED]
    , [APPROVE_FOR_ETL_IND]
    , [TEST_UUID]
    , [MOD_USER]
    , [MOD_DATE]
) 

SELECT 
    'EDP_EGB_'+CONVERT(VARCHAR,#QUESTION_COUNT.TESTID) TEST_NUMBER
    ,'001' DISTRICT_CODE
    ,'Composite' TEST_CLASS
    ,LTRIM(#QUESTION_COUNT.TESTNAME) TESTNAME
     ,CASE
        WHEN #QUESTION_COUNT.TESTNAME LIKE '%EOC %' THEN 'EOC'
        WHEN #QUESTION_COUNT.TESTNAME LIKE '%Summative Assessment %' THEN 'Interim'
        WHEN #QUESTION_COUNT.TESTNAME LIKE '%Interim Assessment %' THEN 'Interim'
        WHEN #QUESTION_COUNT.TESTNAME LIKE 'SS %' THEN 'SS'
        WHEN #QUESTION_COUNT.TESTNAME LIKE '%CCSS (SS)%' THEN 'SS'
        WHEN #QUESTION_COUNT.TESTNAME LIKE '%Assessment A - Paper%' THEN 'A - Paper'
        WHEN #QUESTION_COUNT.TESTNAME LIKE '%Assessment A - Online%' THEN 'A - Online'
        WHEN #QUESTION_COUNT.TESTNAME LIKE '%Assessment B - Paper%' THEN 'B - Paper'
        WHEN #QUESTION_COUNT.TESTNAME LIKE '%Assessment B - Online%' THEN 'B - Online'
        WHEN #QUESTION_COUNT.TESTNAME LIKE '%Assessment C - Paper%' THEN 'C - Paper'
        WHEN #QUESTION_COUNT.TESTNAME LIKE '%Assessment C - Online%' THEN 'C - Online'
        ELSE #QUESTION_COUNT.TESTNAME 
     END  + ' ' +EGB_GRADE.GRADE 
        TEST_SHORT_NAME
     ,CASE
        WHEN #QUESTION_COUNT.TESTNAME LIKE '%EOC %' THEN 'EOC'
        WHEN #QUESTION_COUNT.TESTNAME LIKE '%Summative Assessment %' THEN 'Summative Assessment'
        WHEN #QUESTION_COUNT.TESTNAME LIKE '%Interim Assessment %' THEN 'Interim Assessment'
        WHEN #QUESTION_COUNT.TESTNAME LIKE 'SS %' THEN 'Stepping Stones'
        WHEN #QUESTION_COUNT.TESTNAME LIKE '%CCSS (SS)%' THEN 'Stepping Stones'
        ELSE #QUESTION_COUNT.TESTNAME 
     END  [TEST_GROUP]
    , '--' [TEST_SUBGROUP]
    ,  '--' [TEST_TYPE]    
    ,SUBJECT AS TEST_SUBJECT
    , '--'  [COURSES_SUBJECT]
    , '--'  [CURRICULUM_CODE]
    , EGB_GRADE.GRADE [TEST_GRADE_GROUP]
    , '--' [TEST_METHOD]
    , #QUESTION_COUNT.TESTID [TEST_EXTERNAL_CODE]
    ,'Active' [TEST_STATUS]
    ,'' [TEST_VENDOR]
    ,CASE
        WHEN #QUESTION_COUNT.TESTNAME LIKE '%EOC %' THEN 'EOC'
        WHEN #QUESTION_COUNT.TESTNAME LIKE '%Summative Assessment %' THEN 'Summative Assessment'
        WHEN #QUESTION_COUNT.TESTNAME LIKE '%Interim Assessment %' THEN 'Interim Assessment'
        WHEN #QUESTION_COUNT.TESTNAME LIKE 'SS %' THEN 'Stepping Stones'
        ELSE #QUESTION_COUNT.TESTNAME 
     END TEST_PRODUCT
    , '--' [TEST_VERSION]
    , 0 [TEST_SORT_ORDER]
    , 0 [TEST_ALPHA_SORT]
    , #QUESTION_COUNT.TESTNAME [TEST_DESCRIPTION]
    , '--' [TEST_CONTROL_GROUP_CODE]
    , '--'  [TEST_BENCHMARK_CONTROL_CODE]
    , NULL  [TEST_SCORE_FACTOR]
    , '--' [ETL_REF_BENCHMARK_NAME]
    , NULL [ETL_REF_BENCHMARK_MEASURE]
    , '--' [ETL_CUSTOM_BENCHMARK_NAME]
    , NULL  [ETL_CUSTOM_BENCHMARK_MEASURE]
    , 'N' [ATTENTION_REQUIRED]
    , 'N' [APPROVE_FOR_ETL_IND]
    , newid() [TEST_UUID]
    , 'Max.Janairo' [MOD_USER]
    , CURRENT_TIMESTAMP [MOD_DATE]
from #QUESTION_COUNT
INNER JOIN #RECORDS
ON #QUESTION_COUNT.TESTID = #RECORDS.TESTID
inner join K12INTEL_STAGING_EDP.EGB_TEST 
on EGB_TEST.id = #QUESTION_COUNT.testid
inner join K12INTEL_STAGING_EDP.EGB_SUBJECTS
on EGB_SUBJECTS.id = EGB_TEST.SUBJECTID
inner join K12INTEL_STAGING_EDP.EGB_GRADE
on EGB_GRADE.id = EGB_TEST.GRADEID
WHERE #RECORDS.REC_COUNT<=QUESTION_COUNT
AND 'EDP_EGB_'+CONVERT(VARCHAR,#QUESTION_COUNT.TESTID) 
NOT IN 
( SELECT TEST_NUMBER  FROM k12inteL_userdata.XTBL_TESTS)
GROUP BY 
    #QUESTION_COUNT.TESTID
    ,#QUESTION_COUNT.TESTNAME
    ,QUESTION_COUNT
    ,EGB_SUBJECTS.SUBJECT
    ,EGB_GRADE.GRADE
ORDER BY #QUESTION_COUNT.TESTNAME


/
/*
* Report Percent Correct for sets of respsones. Along with student data and 
* teacher information (via the class).
* This is the main score that  is typically used for reporting and determining 
* performance levels.
* This report was used at the main QA report for APS.
*/


IF object_id('tempdb..#all_gradbook_scores') IS NOT NULL
DROP TABLE #all_gradbook_scores

SELECT 
    'EDP_EGB_'+CONVERT(VARCHAR,#records.TESTID) "XTBL_TEST_SCORES.TEST_NUMBER"
    ,'EDP_EGB_'+CONVERT(VARCHAR,#records.TESTID)
        +'_' +EGB_PEOPLE.STUDENTID 
        +'_'+ CONVERT(VARCHAR,MAX_RESPONSE_DATE,101) 
        +'_'+ convert(varchar,#records.SCHEDULEDTESTID) 
        +'_'+convert(varchar,EGB_TEST_STUDENTS.id) AS  "XTBL_TEST_ADMIN.PROD_TEST_ID"
    ,'001' "XTBL_TEST_ADMIN.DISTRICT_CODE"
    ,EGB_PEOPLE.STUDENTID AS "XTBL_TEST_ADMIN.DISTRICT_STUDENT_ID"
    ,SCHOOL_CODE AS "XTBL_TEST_ADMIN.DISTRICT_SCHOOL_ID"
    ,CONVERT(VARCHAR,MAX_RESPONSE_DATE,101) AS "XTBL_TEST_ADMIN.TEST_ADMIN_DATE_STR"-- US ONLY
    ,CASE 
        WHEN #records.TESTNAME LIKE '%Form 1%' Then 'Fall'
        WHEN #records.TESTNAME LIKE '%Form 2%' Then 'Winter'
        WHEN #records.TESTNAME LIKE '%Form 3%' Then 'Spring'
        WHEN MONTH(MAX_RESPONSE_DATE) IN (9,10,11) Then 'Fall'
        WHEN MONTH(MAX_RESPONSE_DATE) IN (12,1,2) Then 'Winter'
        WHEN MONTH(MAX_RESPONSE_DATE) IN (3,4,5,6) Then 'Spring'
        WHEN MONTH(MAX_RESPONSE_DATE) IN (7,8) Then 'Summer'
        ELSE '--'
    END "XTBL_TEST_ADMIN.TEST_ADMIN_PERIOD"
    ,PASSING_INDICATOR "XTBL_TEST_SCORES.TEST_PASSED_INDICATOR"
    ,TEST_BENCHMARK_NAME "XTBL_TEST_SCORES.TEST_PRIMARY_RESULT"
    ,#records.rec_count "XTBL_TEST_SCORES.TEST_ITEMS_ATTEMPTED"
    ,response_points "XTBL_TEST_SCORES.TEST_SCORE_VALUE"
    ,response_points "XTBL_TEST_SCORES.TEST_RAW_SCORE"
    ,response_points "XTBL_TEST_SCORES.TEST_SCALED_SCORE"
    ,0 "XTBL_TEST_SCORES.TEST_LOWER_BOUND" -- All have a lower bound of 0
    ,total_points  "XTBL_TEST_SCORES.TEST_UPPER_BOUND"
    ,NAME  "XTBL_TEST_ADMIN.TEST_SCHEDULE_NAME"
    ,EGB_PEOPLE.LASTNAME  "XTBL_TEST_ADMIN.STUDENT_FIRST_NAME"
    ,EGB_PEOPLE.FIRSTNAME  "XTBL_TEST_ADMIN.STUDENT_LAST_NAME"
    ,CONVERT(VARCHAR,EGB_PEOPLE.DOB,101) "XTBL_TEST_ADMIN.STUDENT_BIRTHDATE_STR"
    ,STUDENT_CURRENT_GRADE_CODE "XTBL_TEST_SCORES.TEST_STUDENT_GRADE"
    ,teacher.LASTNAME +' ' +teacher.FIRSTNAME "XTBL_TEST_ADMIN.TEST_TEACHER"
    ,EGB_SCHOOL.SCHOOLNAME
    ,CONVERT(varchar,100*(response_points/total_points)) "XTBL_TEST_SCORES.TEST_PERCENTAGE_SCORE"
INTO #all_gradbook_scores
from #records
inner join #QUESTION_COUNT
    on #records.testid = #QUESTION_COUNT.testid 
inner join K12INTEL_STAGING_EDP.EGB_PEOPLE
    on EGB_PEOPLE.id= #records.studentid
inner join K12INTEL_DW.DTBL_STUDENTS
    on DTBL_STUDENTS.STUDENT_ID = EGB_PEOPLE.studentid
left join K12INTEL_STAGING_EDP.EGB_TEST_STUDENTS
    on EGB_TEST_STUDENTS.SCHEDULEDTESTID = #records.SCHEDULEDTESTID
    and EGB_TEST_STUDENTS.studentid = #records.studentid
left join K12INTEL_STAGING_EDP.EGB_CLASS
    on EGB_CLASS.ID= EGB_TEST_STUDENTS.CLASSID
left join K12INTEL_STAGING_EDP.EGB_PEOPLE teacher
    on teacher.ID= EGB_CLASS.TEACHERID
LEFT join K12INTEL_USERDATA.XTBL_TEST_BENCHMARKS
    on XTBL_TEST_BENCHMARKS.TEST_NUMBER = 'EDP_EGB_'+CONVERT(VARCHAR,#records.TESTID) 
    AND response_points BETWEEN XTBL_TEST_BENCHMARKS.MIN_VALUE and XTBL_TEST_BENCHMARKS.MAX_VALUE
INNER JOIN K12INTEL_STAGING_EDP.EGB_SCHOOL
    ON EGB_CLASS.SCHOOLID = EGB_SCHOOL.ID
INNER JOIN K12INTEL_STAGING_EDP.EPC_SCH
    ON EPC_SCH.ORGANIZATION_GU = EGB_SCHOOL.GENESISGUID
    AND EPC_SCH.STAGE_SIS_SCHOOL_YEAR =2015

/

IF OBJECT_ID('tempdb..##GENERIC_TEST_FILE_OUTPUT') IS NOT NULL
DROP TABLE ##GENERIC_TEST_FILE_OUTPUT
SELECT *
INTO ##GENERIC_TEST_FILE_OUTPUT
FROM #ALL_GRADBOOK_SCORES
WHERE #ALL_GRADBOOK_SCORES.[XTBL_TEST_ADMIN.PROD_TEST_ID] NOT IN (SELECT XTBL_TEST_ADMIN.PROD_TEST_ID FROM K12INTEL_USERDATA.XTBL_TEST_ADMIN)
/
SELECT *
FROM ##GENERIC_TEST_FILE_OUTPUT
WHERE [XTBL_TEST_ADMIN.TEST_ADMIN_PERIOD]='Fall'
/
SELECT *
FROM ##GENERIC_TEST_FILE_OUTPUT
WHERE [XTBL_TEST_ADMIN.TEST_ADMIN_PERIOD]='Winter'
/
SELECT *
FROM ##GENERIC_TEST_FILE_OUTPUT
WHERE [XTBL_TEST_ADMIN.TEST_ADMIN_PERIOD]='Spring'
/