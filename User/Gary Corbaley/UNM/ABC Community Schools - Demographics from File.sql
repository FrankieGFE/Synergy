



EXECUTE AS LOGIN='QueryFileUser'
GO

	SELECT
		[FILE].*
		,[ENROLLMENT].[SCHOOL_YEAR]
		,[STUDENT].[SIS_NUMBER]
		,[STUDENT].[FIRST_NAME]
		,[STUDENT].[LAST_NAME]
		,[ENROLLMENT].[GRADE]
		,[STUDENT].[RESOLVED_RACE]
		,[STUDENT].[GENDER]
		,[STUDENT].[LUNCH_STATUS]
		,[STUDENT].[ELL_STATUS]
		,[STUDENT].[SPED_STATUS]		
		
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from 2014_2015_ABC_Community_School_Participants.csv' 
		)AS [FILE]
		
		LEFT OUTER JOIN
		APS.BasicStudentWithMoreInfo AS [STUDENT]
		ON
		[FILE].[APS ID] = [STUDENT].[SIS_NUMBER]
		
		LEFT OUTER HASH JOIN
		APS.PrimaryEnrollmentDetailsAsOf('05/20/2015') AS [ENROLLMENT]
		ON
		[STUDENT].[STUDENT_GU] = [ENROLLMENT].[STUDENT_GU]
		

	
REVERT
GO