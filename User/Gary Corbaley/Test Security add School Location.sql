



EXECUTE AS LOGIN='QueryFileUser'
GO

	SELECT
		[FILE].*
		--[FILE].[Last Name]
		--,[FILE].[First Name]
		--,[FILE].[Username]
		--,[FILE].[Student ID]
		,[STAFF].[SCHOOL_NAME]
		
	FROM
		OPENROWSET (
			'Microsoft.ACE.OLEDB.12.0', 
			'Text;Database=\\SynTempSSIS\Files\TempQuery\;',
			'SELECT * from TestSecurityTestAdministrators.csv' 
		)AS [FILE]
		--/*
		LEFT OUTER JOIN
		(
		SELECT
			[STAFF].*
			,[School].[SCHOOL_CODE]
			,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
		FROM
			rev.[EPC_STAFF] AS [STAFF]
			
			INNER JOIN
			rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
			ON
			[STAFF].[STAFF_GU] = [STAFF_SCHOOL_YEAR].[STAFF_GU]
			
			INNER JOIN 
			rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
			ON 
			[STAFF_SCHOOL_YEAR].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
			
			INNER JOIN 
			rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
			ON 
			[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
			
			INNER JOIN 
			rev.EPC_SCH AS [School] -- Contains the School Code / Number
			ON 
			[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
			
			INNER JOIN 
			rev.REV_YEAR AS [RevYear] -- Contains the School Year
			ON 
			[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
			
		WHERE
			[RevYear].[SCHOOL_YEAR] = '2015'
			AND [RevYear].[EXTENSION] = 'R'
		) AS [STAFF]
		ON
		[FILE].[Username] = [STAFF].[BADGE_NUM]
		--*/
		

	
REVERT
GO