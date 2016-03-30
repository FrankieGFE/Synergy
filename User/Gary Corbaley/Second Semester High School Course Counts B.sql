
EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT
	[Lost].*
	,[SCHEDULE].*
FROM
	OPENROWSET (
		'Microsoft.ACE.OLEDB.12.0', 
		'Text;Database=\\SynTempSSIS.aps.edu.actd\Files\TempQuery\;HDR=YES;', 
		'SELECT * from Second_Semester_High_School_Course_Counts_030316.csv WHERE SCHOOL_CODE IS NOT NULL'
		) AS [Lost]
		
	LEFT OUTER JOIN
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	CONVERT(VARCHAR,[Lost].[SCHOOL_CODE]) = [School].[SCHOOL_CODE]
		
	LEFT OUTER JOIN
	APS.ScheduleAsOf('10/14/2015') AS [SCHEDULE]
	ON
	[School].[ORGANIZATION_GU] = [SCHEDULE].[ORGANIZATION_GU]
	AND CONVERT(VARCHAR,[Lost].[COURSE_ID]) = [SCHEDULE].[COURSE_ID]
	AND CONVERT(VARCHAR,[Lost].[SECTION_ID]) = CONVERT(VARCHAR,[SCHEDULE].[SECTION_ID])
	AND [Lost].[TERM_CODE] = [SCHEDULE].[TERM_CODE]
	
ORDER BY
	[Lost].[TEACHER NAME]
	,[Lost].[PERIOD]
		
REVERT
GO