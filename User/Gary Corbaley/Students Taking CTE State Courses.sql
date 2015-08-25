


EXECUTE AS LOGIN='QueryFileUser'
GO

--SELECT
--	[SCHOOL_CODE]
--	,[SCHOOL_NAME]
--	,[LUNCH_STATUS]
--	,COUNT( DISTINCT [SIS_NUMBER] ) AS [TOTAL]
--FROM
--(
SELECT --TOP 100
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	,[ENROLLMENT].[GRADE]
	,CASE WHEN [STUDENT].[LUNCH_STATUS] IS NULL THEN 'N' ELSE [STUDENT].[LUNCH_STATUS] END AS [LUNCH_STATUS]
	,[ENROLLMENT].[SCHOOL_CODE]
	,[ENROLLMENT].[SCHOOL_NAME]
	,[SCHEDULE].[COURSE_TITLE]
	,[SCHEDULE].[COURSE_ID]
	,[COURSE].[STATE_COURSE_CODE]
	,[SCHEDULE].[SECTION_ID]
	,[SCHEDULE].[DEPARTMENT]
	,[SCHEDULE].[TERM_CODE]
	,[SCHEDULE].[COURSE_ENTER_DATE]
	,[SCHEDULE].[COURSE_LEAVE_DATE]
	
FROM		
	APS.StudentScheduleDetails AS [SCHEDULE]
	
	INNER HASH JOIN
	rev.EPC_CRS AS [COURSE]
	ON
	[SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]
	
	INNER JOIN
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
		'SELECT * from CTE_STATE_COURSE_NUMBERS.csv' 
	)AS [FILE]
	ON
	CONVERT(VARCHAR,[COURSE].[STATE_COURSE_CODE]) = CONVERT(VARCHAR,[FILE].[STARS])	
	
	INNER HASH JOIN
	APS.StudentEnrollmentDetails AS [ENROLLMENT]
	ON
	[SCHEDULE].[ORGANIZATION_YEAR_GU] = [ENROLLMENT].[ORGANIZATION_YEAR_GU]
	AND [SCHEDULE].[STUDENT_GU] = [ENROLLMENT].[STUDENT_GU]
	
	INNER HASH JOIN
	APS.BasicStudentWithMoreInfo AS [STUDENT]
	ON
	[SCHEDULE].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
WHERE
	[ENROLLMENT].[SCHOOL_YEAR]	= '2014'
	AND [ENROLLMENT].[EXTENSION] = 'R'
	
--) AS [SUB1]

--GROUP BY
--	[SCHOOL_CODE]
--	,[SCHOOL_NAME]
--	,[LUNCH_STATUS]
	
REVERT
GO