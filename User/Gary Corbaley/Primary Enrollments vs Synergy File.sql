



EXECUTE AS LOGIN='QueryFileUser'
GO

	SELECT
		*
		
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from 2015_Enrollment_Count_Details.csv' 
		)AS [FILE]
		
		LEFT OUTER JOIN
		APS.BasicStudent AS [STUDENT]
		ON
		[FILE].[Perm ID] = [STUDENT].[SIS_NUMBER]
		
		LEFT OUTER JOIN
		APS.PrimaryEnrollmentDetailsAsOf('08/13/2015') AS [ENROLLMENTS]
		ON
		[STUDENT].[STUDENT_GU] = [ENROLLMENTS].[STUDENT_GU]
		
	WHERE
		[ENROLLMENTS].[ENTER_DATE] IS NULL
	
REVERT
GO