






EXECUTE AS LOGIN='QueryFileUser'
GO

DECLARE @AsOfDate DATETIME = '2/11/2015'

	/*
	SELECT DISTINCT
		[FILE].*
		,[STUDENT].[RACE_1]
		,[STUDENT].[RACE_2]
		,[STUDENT].[RACE_3]
		,[STUDENT].[RACE_4]
		,[STUDENT].[RACE_5]
		,[SCHEDULE].[COURSE_ID]
		,[SCHEDULE].[COURSE_TITLE]
		,[SCHEDULE].[TERM_CODE]
		--,[SCHEDULE].*
		
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from 2014_15_PARCC_Exemptions.csv' 
		)AS [FILE]
				
		INNER JOIN
		APS.BasicStudentWithMoreInfo AS [STUDENT]
		ON
		[FILE].[Student ID] = [STUDENT].[SIS_NUMBER]
		
		LEFT OUTER JOIN
		APS.ScheduleAsOf(@AsOfDate) AS [SCHEDULE]
		ON
		[STUDENT].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
		AND (
		[SCHEDULE].[DEPARTMENT] IN ('Math', 'Eng')
		OR 
		([SCHEDULE].[DEPARTMENT] = 'Elem' AND [SCHEDULE].[PERIOD_BEGIN] = 1)
		)
		AND [SCHEDULE].[TERM_CODE] IN ('FY','S2','YR')
	
	--WHERE
	--	[STUDENT].[SIS_NUMBER] = '104216981'
	--*/
		
	--/*		
	SELECT DISTINCT
		[STUDENT].[FIRST_NAME]
		,[STUDENT].[LAST_NAME]
		,[STUDENT].[MIDDLE_NAME]
		,[STUDENT].[SIS_NUMBER]
		,[ENROLLMENTS].[SCHOOL_CODE]
		,[ENROLLMENTS].[SCHOOL_NAME]
		,[ENROLLMENTS].[GRADE]
		,[STUDENT].[HISPANIC_INDICATOR]
		--,[STUDENT].[RESOLVED_RACE]
		,[STUDENT].[RACE_1]
		,[STUDENT].[RACE_2]
		,[STUDENT].[RACE_3]
		,[STUDENT].[RACE_4]
		,[STUDENT].[RACE_5]
		,CASE WHEN [STUDENT].[LUNCH_STATUS] = '2' THEN 'F' ELSE [STUDENT].[LUNCH_STATUS] END AS [LUNCH_STATUS]
		,'' AS [PARCC_EXEMPTIONS]
		,[SCHEDULE].[COURSE_ID]
		,[SCHEDULE].[COURSE_TITLE]
		,[SCHEDULE].[TERM_CODE]
		,[COURSE].[DEPARTMENT]
		,[COURSE].[DEPARTMENT_CODE]
		,[COURSE].[SUBJECT_AREA_1]
		
	FROM
		APS.PrimaryEnrollmentDetailsAsOf(@AsOfDate) AS [ENROLLMENTS]
		
		INNER JOIN
		APS.BasicStudentWithMoreInfo AS [STUDENT]
		ON
		[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
		
		LEFT OUTER JOIN
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from 2014_15_PARCC_Exemptions.csv' 
		)AS [FILE]
		ON
		[STUDENT].[SIS_NUMBER] = [FILE].[Student ID]
		
		LEFT OUTER JOIN
		APS.ScheduleAsOf(@AsOfDate) AS [SCHEDULE]
		ON
		[STUDENT].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
		AND (
		[SCHEDULE].[DEPARTMENT] IN ('Math', 'Eng')
		OR 
		([SCHEDULE].[DEPARTMENT] = 'Elem' AND [SCHEDULE].[PERIOD_BEGIN] = 1)
		)
		AND [SCHEDULE].[TERM_CODE] IN ('FY','S2','YR')	
		
		LEFT OUTER JOIN
		rev.EPC_CRS AS [COURSE]
		ON
		[SCHEDULE].[COURSE_GU] = [COURSE].[COURSE_GU]	
		
		
	WHERE
		[ENROLLMENTS].[GRADE] BETWEEN '03' AND '12'
		AND [FILE].[Student ID] IS NULL
		AND [STUDENT].[SIS_NUMBER] NOT IN 
		(
		SELECT
			[FILE].[Student ID]
		FROM
			OPENROWSET (
					'Microsoft.ACE.OLEDB.12.0', 
					'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
					'SELECT * from 2014_15_PARCC_Exemptions_011216.csv' 
				)AS [FILE]
		
		)
	--*/

REVERT
GO