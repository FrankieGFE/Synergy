






EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT
	--[FILE].*
	[FILE].SIS_NUMBER	
	,[FILE].FIRST_NAME	
	,[FILE].LAST_NAME	
	,[FILE].MIDDLE_NAME	
	,[FILE].SCHOOL_NAME	
	,[FILE].ENROLLMENT_ENTER_DATE	
	,[FILE].ENROLLMENT_LEAVE_DATE	
	,[FILE].COURSE_ID	
	,[FILE].COURSE_TITLE	
	,[FILE].COURSE_ENTER_DATE	
	,[FILE].COURSE_LEAVE_DATE	
	,RIGHT('0000' + CONVERT(VARCHAR,[FILE].[SECTION_ID]),4) AS [SECTION_ID]	
	,('S' + CONVERT(VARCHAR,CONVERT(INT,[FILE].[TERM_CODE]))) AS [TERM_CODE]	
	,[FILE].DUAL_CREDIT	
	,[FILE].OTHER_PROVIDER_NAME	
	,CONVERT(VARCHAR,CASE WHEN CONVERT(VARCHAR,[FILE].CREDIT) = '1' THEN '1.000' ELSE CONVERT(VARCHAR,[FILE].CREDIT) END) AS [CREDIT]
	,[STUDENT].[HISPANIC_INDICATOR]
	,[STUDENT].[RACE_1]
	,[STUDENT].[RACE_2]
	,[STUDENT].[RACE_3]
	,[STUDENT].[RACE_4]
	,[STUDENT].[RACE_5]
	,[STUDENT].[RESOLVED_RACE]
	,[STUDENT].[LUNCH_STATUS]
	--,[COURSE_HISTORY].[GRADE]
	,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	--,[COURSE_HISTORY].[COURSE_ID]
	--,[COURSE_HISTORY].[COURSE_TITLE]
	--,[COURSE_HISTORY].[TERM_CODE]
	--,[COURSE_HISTORY].[SCHOOL_YEAR]
	--,[COURSE_HISTORY].[CLASS_BEGIN_DATE]
	--,[COURSE_HISTORY].[CLASS_END_DATE]
	,[COURSE_HISTORY].[MARK]
	,[COURSE_HISTORY].[CREDIT_COMPLETED]
	
	--,'S' + CONVERT(VARCHAR,CONVERT(INT,[FILE].[TERM_CODE]))
	
	--,[SCHEDULE].[COURSE_ID]
	--,[SCHEDULE].[SECTION_ID]
	--,[SCHEDULE].[COURSE_TITLE]
FROM
	OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from Dual_Credit_Students_Classes_062415.csv' 
		)AS [FILE]
		
	INNER JOIN
	APS.BasicStudentWithMoreInfo AS [STUDENT]
	ON
	[FILE].[SIS_NUMBER] = [STUDENT].[SIS_NUMBER]
	
	--LEFT OUTER JOIN
	--APS.StudentScheduleDetails AS [SCHEDULE]
	--ON
	--[STUDENT].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
	--AND [FILE].[COURSE_ID] = [SCHEDULE].[COURSE_ID]
	--AND RIGHT('0000' + CONVERT(VARCHAR,[FILE].[SECTION_ID]),4) = [SCHEDULE].[SECTION_ID]
	--AND [SCHEDULE].[YEAR_GU] = '26F066A3-ABFC-4EDB-B397-43412EDABC8B'
	
	LEFT OUTER JOIN
	rev.[EPC_STU_CRS_HIS] AS [COURSE_HISTORY]
	ON
	[STUDENT].[STUDENT_GU] = [COURSE_HISTORY].[STUDENT_GU]
	AND [FILE].[COURSE_ID] = [COURSE_HISTORY].[COURSE_ID]
	AND ('S' + CONVERT(VARCHAR,CONVERT(INT,[FILE].[TERM_CODE]))) = [COURSE_HISTORY].[TERM_CODE]
	AND [COURSE_HISTORY].[SCHOOL_YEAR] = '2014'
	
	LEFT OUTER JOIN
	APS.LookupTable('K12','Grade') AS [Grades]
	ON
	[COURSE_HISTORY].[GRADE] = [Grades].[VALUE_CODE]
	
--WHERE
--	[FILE].[SIS_NUMBER] = '100016351'
	
	
REVERT
GO


