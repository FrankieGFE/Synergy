


EXECUTE AS LOGIN='QueryFileUser'
GO
	SELECT
		[FILE].*
		,[STUDENT].[HISPANIC_INDICATOR]
		,[STUDENT].[RESOLVED_RACE]
		,[STUDENT].[ELL_STATUS]
		,[STUDENT].[SPED_STATUS]
		,CASE 
			WHEN [STUDENT].[LUNCH_STATUS] IS NULL THEN 'N'
			WHEN [STUDENT].[LUNCH_STATUS] = '2' THEN 'F'
			ELSE [STUDENT].[LUNCH_STATUS]
		END AS [LUNCH_STATUS]
		--,[STUDENT].[LUNCH_STATUS] AS [LUNCH_STATUS2]
		,[STUDENT].[GENDER]
		,[ENROLLMENTS].[GRADE]
		
		--,[FRMHistory].*
		
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from suspension_data_for_Jason.csv' 
		)AS [FILE]
		
		LEFT OUTER HASH JOIN
		APS.BasicStudentWithMoreInfo AS [STUDENT]
		ON
		[FILE].[PERM ID] = [STUDENT].[SIS_NUMBER]
		
		LEFT OUTER JOIN
		APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS [ENROLLMENTS]
		ON
		[STUDENT].[STUDENT_GU] = [ENROLLMENTS].[STUDENT_GU]		
		
	--WHERE
	--	[FILE].[PERM ID] = '980007794'


REVERT
GO