



EXECUTE AS LOGIN='QueryFileUser'
GO

	UPDATE [STUDENT]

	SET [STUDENT].[DIPLOMA_ATTEMPT_TYPE_1] = [New Diploma].[VALUE_CODE]
		
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
			--'SELECT * from Personal_Needs_Profile_Export_20141125_FULL_DISTRICT.csv'
			'SELECT DISTINCT * from GradpathwayDistrict.csv' 
		)AS [FILE]

		LEFT OUTER JOIN
		rev.EPC_STU AS [STUDENT]
		ON
		[FILE].[Student ID] = [STUDENT].[SIS_NUMBER]
		
		LEFT OUTER JOIN
		APS.LookupTable('K12','DIPLOMA_TYPE') AS [New Diploma]
		ON
		UPPER(REPLACE([FILE].[GraduationPathway],'Option','Diploma')) = UPPER([New Diploma].[VALUE_DESCRIPTION])
		
	WHERE
		[STUDENT].[DIPLOMA_ATTEMPT_TYPE_1] IS NULL
	

	
REVERT
GO