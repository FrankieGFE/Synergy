--------------------------------------------
--Step 1
--Remove the previously loaded test (if needed)
--query xtbl_test_batch_id
--Puts table into RO mode / disables indexes
--------------------------------------------
EXECUTE [K12INTEL_METADATA].[WORKFLOW_ALTER_INDEXES] 
   'K12INTEL_DW' 
   , 'FTBL_TEST_SCORES' 
   , 'DISABLE' 
   , 'NONCLUSTERED COLUMNSTORE' 
   , NULL 
GO

--Revmove the test scores
--Only need to remove test scores when prod test id changes or test number changes
EXEC K12INTEL_METADATA.REMOVE_TESTSCORES 'GENERIC ISTATION 001 APS 2016-2017'	 --'GENERIC SBA-NM 001 APS 2015-2016'		--If the name has changed, used the previous name here.
--EXEC K12INTEL_METADATA.REMOVE_TESTSCORES 'GENERIC HSGA-Composite 001 APS 2015-2016'	 --'GENERIC SBA-NM 001 APS 2015-2016'		--If the name has changed, used the previous name here.

EXECUTE [K12INTEL_METADATA].[WORKFLOW_ALTER_INDEXES] 
   'K12INTEL_DW' 
   , 'FTBL_TEST_SCORES' 
   , 'REBUILD' 
   , 'NONCLUSTERED COLUMNSTORE' 
   , NULL 
GO

--------------------------------------------
--Step 2 / 4 (verify after CSCRIPT load)
--Verify that test scores were removed/added
--Test will be gone from the dashboard
--------------------------------------------
--Verify that test scores were removed/added
SELECT DISTINCT --count(*) --verify # records
	--scores.*  --Verify scores look correct; test_scores and test_score_text etc.
	--admin.*		--Verify that names looks correct, cols will be off if there is a tab in the data
	batch.LOAD_STATUS
FROM K12INTEL_USERDATA.XTBL_TESTS tests  WITH (NOLOCK)
INNER JOIN K12INTEL_USERDATA.XTBL_TEST_SCORES scores WITH (NOLOCK)
    ON tests.TEST_NUMBER = scores.TEST_NUMBER
INNER JOIN K12INTEL_USERDATA.XTBL_TEST_ADMIN admin WITH (NOLOCK)
    ON scores.TEST_ADMIN_KEY = admin.TEST_ADMIN_KEY
INNER JOIN K12INTEL_USERDATA.XTBL_TEST_BATCH_IDS batch WITH (NOLOCK)
    ON admin.BATCH_ID = batch.BATCH_ID
WHERE 1=1
    AND batch.BATCH_NAME in( 'ACT 001 APS 2016-2017 AUG') --, 'GENERIC HSGA-Composite 001 APS 2015-2016')  --This is the folder structure; needs to be changed if the test is moved.
	
----------------------------------------------------------------------------------------
--Run CScript
--F:\K12INTEL_Programs\uTL\load_scripts>cscript loadGeneric.vbs
--Re-run Step 2(4) to verify the number of records and any changes made.
----------------------------------------------------------------------------------------

--------------------------------------------
--Step 3
--Audits table will be loaded here
--Modify the stored procedure [K12INTEL_METADATA].[BLD_F_TEST_SCORES_XTBL] 
--to only run the batch we're interested in.
--Line 599
/*
            --run only for specific batch if provided in PARAM_MISC_PARAMS.  Can be a expression like "SELECT BATCH_NAME='ACT%2008-2009'"
            --AND (a.batch_name LIKE @BATCH_NAME_TO_PROCESS OR @BATCH_NAME_TO_PROCESS IS NULL)
            --AND b.DISTRICT_STUDENT_ID like '%1000245%'
--            AND(a.batch_name LIKE '%SAT%' /*or a.batch_name LIKE 'GENERIC%ACT%'*/)
--            AND(a.batch_name = 'GENERIC WAPT 001 APS ALL')
--                AND (a.batch_id in (1092))
			AND a.BATCH_NAME = 'GENERIC SBA-NM 001 APS 2015-2016'
			*/
--------------------------------------------
EXEC [K12INTEL_METADATA].[WORKFLOW_ALTER_INDEXES]
    @PARAM_TABLE_SCHEMA = 'K12INTEL_DW',
    @PARAM_TABLE_NAME = 'DTBL_TESTS',
    @PARAM_ALTER_COMMAND = 'DISABLE',
    @PARAM_INDEX_TYPE = 'NONCLUSTERED COLUMNSTORE',
    @PARAM_DATA_COMPRESSION = NULL
 
EXEC [K12INTEL_METADATA].[WORKFLOW_ALTER_INDEXES]
    @PARAM_TABLE_SCHEMA = 'K12INTEL_DW',
    @PARAM_TABLE_NAME = 'FTBL_TEST_SCORES',
    @PARAM_ALTER_COMMAND = 'DISABLE',
    @PARAM_INDEX_TYPE = 'NONCLUSTERED COLUMNSTORE',
    @PARAM_DATA_COMPRESSION = NULL
--Ran into error here---but it was a SQL Server flaky error - reran later in the day and it worked.
--Moves xtbl tests to dtble tests
EXEC K12INTEL_METADATA.EXEC_VERSIFIT_AUTOMATION 'BUILD EDVANTAGE', 'BUILD D_TESTS_XTBL', 0, '-param "BOOL_USE_FULL_REFRESH=Y"'
--Moves xtbl scores to ftbl scores (test admin and test batch id)
EXEC K12INTEL_METADATA.EXEC_VERSIFIT_AUTOMATION 'BUILD EDVANTAGE', 'BUILD 001 F_TEST_SCORES_XTBL', 0, '-param "BOOL_USE_FULL_REFRESH=Y"'
 
EXEC [K12INTEL_METADATA].[WORKFLOW_ALTER_INDEXES]
    @PARAM_TABLE_SCHEMA = 'K12INTEL_DW',
    @PARAM_TABLE_NAME = 'FTBL_TEST_SCORES',
    @PARAM_ALTER_COMMAND = 'REBUILD',
    @PARAM_INDEX_TYPE = 'NONCLUSTERED COLUMNSTORE',
    @PARAM_DATA_COMPRESSION = NULL
 
EXEC [K12INTEL_METADATA].[WORKFLOW_ALTER_INDEXES]
    @PARAM_TABLE_SCHEMA = 'K12INTEL_DW',
    @PARAM_TABLE_NAME = 'DTBL_TESTS',
    @PARAM_ALTER_COMMAND = 'REBUILD',
    @PARAM_INDEX_TYPE = 'NONCLUSTERED COLUMNSTORE',
    @PARAM_DATA_COMPRESSION = NULL

--------------------------------------------------------------
--***Revert Stored Procedure***-
--Modify [K12INTEL_METADATA].[BLD_F_TEST_SCORES_XTBL] 
--------------------------------------------------------------

--------------------------------------------
--Step 4 - find the build number
--Verify by record number and most recent build 
--Watch build progress from build step above
--The process is still running when number unkonwn is > 0 
--And process_id still running in Task Manager on server
--------------------------------------------
SELECT 
    BUILD_NUMBER
    ,BUILD_METHOD
    ,COUNT(*) NUM_OF_TASKS
    ,DATEDIFF(hh, MIN(START_TIME), MAX(END_TIME)) TOTAL_HOURS
    ,DATEDIFF(mi, MIN(START_TIME), MAX(END_TIME)) TOTAL_MINUTES
    ,SUM(ROWS_PROCESSED) NUM_OF_ROWS_PROCESSED
    ,SUM(ROWS_INSERTED) NUM_OF_INSERTS
    ,SUM(ROWS_UPDATED) NUM_OF_UPDATES
    ,SUM(ROWS_DELETED) NUM_OF_DELETES
    ,SUM(ROWS_AUDITED) NUM_OF_AUDITS
    ,SUM(CASE STATUS_NAME WHEN 'SUCCESS' THEN 1 ELSE 0 END) NUM_OF_SUCCESS
    ,SUM(CASE STATUS_NAME WHEN 'FAILURE' THEN 1 ELSE 0 END) NUM_OF_FAILURE
    ,SUM(CASE STATUS_NAME WHEN 'UNKNOWN' THEN 1 ELSE 0 END) NUM_OF_UNKNOWN
    ,SUM(CASE STATUS_NAME WHEN 'SUCCESS_WITH_WARNINGS' THEN 1 ELSE 0 END) NUM_OF_WARNINGS
    ,SUM(DBERR_COUNT) NUM_OF_DBERR
    ,MIN(START_TIME) DATE_START
    ,MAX(END_TIME) DATE_END
    ,PROCESS_ID
FROM K12INTEL_METADATA.BUILD_STATUS_ALL WITH (NOLOCK)
WHERE 1=1
GROUP BY BUILD_NUMBER, BUILD_METHOD, PROCESS_ID
ORDER BY BUILD_NUMBER DESC

--------------------------------------------
--Step 5
--High level overview of what happened
--------------------------------------------
SELECT AUDIT_SOURCE, TASK_ID, AUDIT_SOURCE_LOCATION, AUDIT_BASE_MSG, COUNT(*) COUNT
FROM K12INTEL_AUDIT.RAW_AUDITS
WHERE 1=1
    AND BUILD_NUMBER = 1644
GROUP BY AUDIT_SOURCE, TASK_ID, AUDIT_SOURCE_LOCATION, AUDIT_BASE_MSG
ORDER BY 5 DESC,1,2,3,4

--------------------------------------------
--Detals of what happened
--Can use audit-data-lineage to determine error / look up student ids
--In the case of missing student IDs, you will get 2 audits since it checks state and federal IDs (will be more if there are more IDs to check)
SELECT *
FROM K12INTEL_AUDIT.RAW_AUDITS
WHERE 1=1
    AND BUILD_NUMBER = 1644

--------------------------------------------
--Verify Scores
--Dashboard is talking to these tables
--Verify # records  test_primary_result and test_score_text (changes values)
SELECT scores.*, TESTS.*
FROM K12INTEL_DW.DTBL_TESTS tests WITH (NOLOCK)
INNER JOIN K12INTEL_DW.FTBL_TEST_SCORES scores WITH (NOLOCK)
    ON tests.TESTS_KEY = scores.TESTS_KEY
WHERE 1=1
	AND tests.TEST_PRODUCT = 'ISTATION'
	--AND CONVERT(DATE, scores.SYS_CREATED) = '11/15/2016'
