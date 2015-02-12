


	--SELECT		
	--	[STUDENT].[SIS_NUMBER]
	--	,[PERSON].[FIRST_NAME]
	--	,[PERSON].[LAST_NAME]
	--	,[PERSON].[MIDDLE_NAME]
	--	,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
	--	,[STUDENT].[DIPLOMA_TYPE] AS [CURRENT DIPLOMA CODE]

/*	
	UPDATE [STUDENT]

	SET [STUDENT].[DIPLOMA_TYPE] = '01'
	--SET [STUDENT].[DIPLOMA_ATTEMPT_TYPE_1] = NULL
		
	FROM
		APS.PrimaryEnrollmentsAsOf(GETDATE()) AS [Enrollments]

		LEFT OUTER JOIN
		rev.EPC_STU AS [STUDENT]
		ON
		[Enrollments].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
		
		LEFT OUTER JOIN
		rev.REV_PERSON AS [PERSON]
		ON
		[STUDENT].[STUDENT_GU] = [PERSON].[PERSON_GU]
		
		LEFT OUTER JOIN
		APS.LookupTable('K12','Grade') AS [Grades]
		ON
		[Enrollments].[GRADE] = [Grades].[VALUE_CODE]
		
	WHERE
		[Grades].[VALUE_DESCRIPTION] IN ('09','10','11','12')
		AND ([STUDENT].[DIPLOMA_TYPE] IS NULL OR [STUDENT].[DIPLOMA_TYPE] = '')
		
*/
--EXECUTE AS LOGIN='QueryFileUser'
--GO


	SELECT
		--[FILE].*
		--,'' AS [End of File]
		[STUDENT].[SIS_NUMBER]
		,[PERSON].[FIRST_NAME]
		,[PERSON].[LAST_NAME]
		,[PERSON].[MIDDLE_NAME]
		,[Grades].[VALUE_DESCRIPTION] AS [GRADE]
		,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
		--,[STUDENT].[STUDENT_GU]
		,[STUDENT].[DIPLOMA_TYPE] AS [CURRENT DIPLOMA CODE]
		,[Diploma].[VALUE_DESCRIPTION] AS [CURRENT DIPLOMA DESCRIPTION]
		--,[New Diploma].[VALUE_CODE] AS [NEW DIPLOMA CODE]
		--,REPLACE([FILE].[GraduationPathway],'Option','Diploma') AS [NEW DIPLOMA DESCRIPTION]
		--,[New Diploma].[VALUE_DESCRIPTION] AS [NEW DIPLOMA DESCRIPTION]
		
	FROM
		APS.PrimaryEnrollmentsAsOf(GETDATE()) AS [Enrollments]
		--OPENROWSET (
		--	'Microsoft.ACE.OLEDB.12.0', 
		--	'Text;Database=\\SynTempSSIS\Files\TempQuery\;', 
		--	--'SELECT * from Personal_Needs_Profile_Export_20141125_FULL_DISTRICT.csv'
		--	'SELECT DISTINCT * from GradpathwayDistrict.csv' 
		--)AS [FILE]

		LEFT OUTER JOIN
		rev.EPC_STU AS [STUDENT]
		ON
		[Enrollments].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
		--[FILE].[Student ID] = [STUDENT].[SIS_NUMBER]
		
		LEFT OUTER JOIN
		rev.REV_PERSON AS [PERSON]
		ON
		[STUDENT].[STUDENT_GU] = [PERSON].[PERSON_GU]
		
		LEFT OUTER JOIN
		APS.LookupTable('K12','DIPLOMA_TYPE') AS [Diploma]
		ON
		[STUDENT].[DIPLOMA_TYPE] = [Diploma].[VALUE_CODE]

		--LEFT OUTER JOIN
		--APS.PrimaryEnrollmentsAsOf(GETDATE()) AS [Enrollments]
		--ON
		--[STUDENT].[STUDENT_GU] = [Enrollments].[STUDENT_GU]
		
		LEFT OUTER JOIN
		rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
		ON
		[Enrollments].[STUDENT_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
		
		LEFT OUTER JOIN
		rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		LEFT OUTER JOIN 
		rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		
		LEFT OUTER JOIN
		APS.LookupTable('K12','Grade') AS [Grades]
		ON
		[StudentSchoolYear].[GRADE] = [Grades].[VALUE_CODE]
		
		--LEFT OUTER JOIN
		--APS.LookupTable('K12','DIPLOMA_TYPE') AS [New Diploma]
		--ON
		--UPPER(REPLACE([FILE].[GraduationPathway],'Option','Diploma')) = UPPER([New Diploma].[VALUE_DESCRIPTION])
		
	WHERE
		[Grades].[VALUE_DESCRIPTION] IN ('09','10','11','12')
		--AND ([STUDENT].[DIPLOMA_TYPE] IS NULL OR [STUDENT].[DIPLOMA_TYPE] = '')
	

	
--REVERT
--GO