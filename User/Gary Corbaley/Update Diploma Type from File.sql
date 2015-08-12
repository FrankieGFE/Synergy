



EXECUTE AS LOGIN='QueryFileUser'
GO

	SELECT
		[STUDENT].[FIRST_NAME]
		,[STUDENT].[LAST_NAME]
		,[STUDENT].[MIDDLE_NAME]
		,[STUDENT].[SIS_NUMBER]
		,[STUDENT].[STATE_STUDENT_NUMBER]		
		
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from Lutheran_Family_Services_2014.csv' 
		)AS [FILE]
		
		INNER JOIN
		APS.BasicStudent AS [STUDENT]
		ON
		[FILE].[APS ID] = [STUDENT].[SIS_NUMBER]
		
		INNER JOIN
		(
		SELECT
			*
			,
		FROM
			APS.[StudentEnrollmentDetails]
		WHERE
			SCHOOL_YEAR = '2014'
		
		)  AS [ENROLLMENT]
		ON
		[STUDENT].[STUDENT_GU] = [ENROLLMENT].[STUDENT_GU]
	
REVERT
GO