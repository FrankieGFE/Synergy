



EXECUTE AS LOGIN='QueryFileUser'
GO

	
	SELECT
		[ENROLLMENTS].[SCHOOL_CODE]
		,[ENROLLMENTS].[SCHOOL_NAME]
		,[FILE].[board_district]
		,[STUDENT].[RESOLVED_RACE]
		,COUNT([ENROLLMENTS].[STUDENT_GU]) AS [TOTAL]
		
		
	FROM
		
			OPENROWSET (
				'Microsoft.ACE.OLEDB.12.0', 
				'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
				'SELECT * from schools_board_district.csv' 
			)AS [FILE]
			
			INNER JOIN
			APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS [ENROLLMENTS]
			ON
			CONVERT(VARCHAR(3),[FILE].[school_code]) = [ENROLLMENTS].[SCHOOL_CODE]
			
			INNER JOIN
			(
			SELECT
				*
				,CASE WHEN [STUDENT1].[HISPANIC_INDICATOR] = 'Y' THEN 'Hispanic' ELSE [STUDENT1].[RACE_1] END AS [RACE]
			FROM
				APS.BasicStudentWithMoreInfo AS [STUDENT1]
			) AS [STUDENT]
			ON
			[ENROLLMENTS].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
			
	GROUP BY
		[ENROLLMENTS].[SCHOOL_CODE]
		,[ENROLLMENTS].[SCHOOL_NAME]
		,[FILE].[board_district]
		,[STUDENT].[RESOLVED_RACE]
		
	ORDER BY
		[FILE].[board_district]
		
	
REVERT
GO