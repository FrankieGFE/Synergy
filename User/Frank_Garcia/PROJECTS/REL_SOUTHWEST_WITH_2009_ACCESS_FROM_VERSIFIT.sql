



EXECUTE AS LOGIN='QueryFileUser'
GO

WITH
ACCESS_SCALE AS
(
SELECT
	STUDENT_ID
	,CAST ([2009] AS VARCHAR)  AS 'ACCESS SCALE 2009-2010'
	,CAST ([2010] AS VARCHAR) AS 'ACCESS SCALE 2010-2011'
	,CAST ([2011] AS VARCHAR) AS 'ACCESS SCALE 2011-2012'
	,CAST ([2012] AS VARCHAR) AS 'ACCESS SCALE 2012-2013'
	,CAST ([2013] AS VARCHAR) AS 'ACCESS SCALE 2013-2014'
	,CAST ([2014] AS VARCHAR) AS 'ACCESS SCALE 2014-2015'
FROM
(
SELECT 
    STUDENT_ID
    ,TEST_PRODUCT 
    ,TEST_SUBJECT AS CONTENT_AREA
    ,TEST_SCORE_VALUE AS SCORE
    --,TEST_PRIMARY_RESULT AS PERFORMANCE_LEVEL
	,SIS_SCHOOL_YEAR
FROM [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.FTBL_TEST_SCORES
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_TESTS
ON DTBL_TESTS.TESTS_KEY = FTBL_TEST_SCORES.TESTS_KEY 
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_STUDENTS 
ON DTBL_STUDENTS.STUDENT_KEY = FTBL_TEST_SCORES.STUDENT_KEY 
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_SCHOOLS
ON DTBL_SCHOOLS.SCHOOL_KEY = FTBL_TEST_SCORES.SCHOOL_KEY
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_CALENDAR_DATES
ON DTBL_CALENDAR_DATES.CALENDAR_DATE_KEY= FTBL_TEST_SCORES.CALENDAR_DATE_KEY
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_SCHOOL_DATES
ON DTBL_SCHOOL_DATES.SCHOOL_DATES_KEY = FTBL_TEST_SCORES.SCHOOL_DATES_KEY 
WHERE TEST_PRODUCT = 'ACCESS'
AND TEST_SUBJECT = 'OVERALL'
--AND LOCAL_SCHOOL_YEAR = '2009-2010'
) AS ACC
PIVOT
	(MAX([SCORE]) FOR SIS_SCHOOL_YEAR IN ([2009],[2010],[2011],[2012],[2013],[2014],[2015])) AS UP1
)
,ACCESS_PL AS
(
SELECT
	STUDENT_ID
	,[2009] AS 'ACCESS PL 2009-2010'
	,[2010] AS 'ACCESS PL 2010-2011'
	,[2011] AS 'ACCESS PL 2011-2012'
	,[2012] AS 'ACCESS PL 2012-2013'
	,[2013] AS 'ACCESS PL 2013-2014'
	,[2014] AS 'ACCESS PL 2014-2015'
FROM
(
SELECT 
    STUDENT_ID
    ,TEST_PRODUCT 
    ,TEST_SUBJECT AS CONTENT_AREA
    --,TEST_SCORE_VALUE AS SCORE
    ,TEST_PRIMARY_RESULT AS PL
	,SIS_SCHOOL_YEAR
FROM [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.FTBL_TEST_SCORES
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_TESTS
ON DTBL_TESTS.TESTS_KEY = FTBL_TEST_SCORES.TESTS_KEY 
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_STUDENTS 
ON DTBL_STUDENTS.STUDENT_KEY = FTBL_TEST_SCORES.STUDENT_KEY 
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_SCHOOLS
ON DTBL_SCHOOLS.SCHOOL_KEY = FTBL_TEST_SCORES.SCHOOL_KEY
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_CALENDAR_DATES
ON DTBL_CALENDAR_DATES.CALENDAR_DATE_KEY= FTBL_TEST_SCORES.CALENDAR_DATE_KEY
INNER JOIN [VERSIFIT.APS.EDU.ACTD].K12INTEL.K12INTEL_DW.DTBL_SCHOOL_DATES
ON DTBL_SCHOOL_DATES.SCHOOL_DATES_KEY = FTBL_TEST_SCORES.SCHOOL_DATES_KEY 
WHERE TEST_PRODUCT = 'ACCESS'
AND TEST_SUBJECT = 'OVERALL'
--AND LOCAL_SCHOOL_YEAR = '2009-2010'
) AS ACC
PIVOT
	(MAX([PL]) FOR SIS_SCHOOL_YEAR IN ([2009],[2010],[2011],[2012],[2013],[2014],[2015])) AS UP1
)





select 
	CASE WHEN [ACCESS SCALE 2009-2010] IS NULL THEN 'Missing' ELSE [ACCESS SCALE 2009-2010] END AS 'English Proficiency SCALE 2009-2010'
	,CASE WHEN [ACCESS PL 2009-2010] IS NULL THEN 'Missing' ELSE [ACCESS PL 2009-2010] END AS 'English Proficiency PL 2009-2010'
	,*
 from

		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
			'SELECT * FROM APS_identified_data_RELSW.csv'  
		)AS [FILE]

LEFT JOIN
REV.EPC_STU AS STU
ON STU.STATE_STUDENT_NUMBER = [FILE].STUDENT_ID

LEFT JOIN
ACCESS_SCALE AS ACS
ON ACS.STUDENT_ID = STU.STATE_STUDENT_NUMBER

LEFT JOIN
ACCESS_PL AS ACPL
ON ACPL.STUDENT_ID = STU.STATE_STUDENT_NUMBER



REVERT
GO