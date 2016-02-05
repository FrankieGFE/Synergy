





SELECT --TOP 100
	[STUDENT].[SIS_NUMBER]
	,[STUDENT].[FIRST_NAME]
	,[STUDENT].[LAST_NAME]
	,[STUDENT].[MIDDLE_NAME]
	--,[VACCINE].*
	--,[DOSAGE].[IN_COMPLIANCE]
	,[VACCINE].[IN_COMLIANCE]
	,[STU_YEAR].[SCHOOL_CODE]
	,[STU_YEAR].[SCHOOL_NAME]
	,[STU_YEAR].[ENTER_DATE]
	,[STU_YEAR].[LEAVE_DATE]
	,[STU_YEAR].[EXCLUDE_ADA_ADM]
	
	--,[VACCINE].*
	
FROM
	APS.BasicStudent AS [STUDENT]
	
	INNER JOIN
	rev.EPC_STU_IMM_VACCINE AS [VACCINE]
	ON
	[STUDENT].[STUDENT_GU] = [VACCINE].[STUDENT_GU]
	
	INNER JOIN
	rev.EPC_STU_IMM_DOSAGE AS [DOSAGE]
	ON
	[VACCINE].[STU_IMM_VACCINE_GU] = [DOSAGE].[STU_IMM_VACCINE_GU]
	
	LEFT OUTER JOIN
	(
	SELECT
		[STU_YEAR].[STUDENT_GU]
		,[StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
		,[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
		,[StudentSchoolYear].[ENTER_DATE]
		,[StudentSchoolYear].[LEAVE_DATE]
		,[StudentSchoolYear].[EXCLUDE_ADA_ADM]
		,ROW_NUMBER() OVER (PARTITION BY [StudentSchoolYear].[STUDENT_GU] ORDER BY [StudentSchoolYear].[ENTER_DATE] DESC) AS RN
	FROM
		rev.EPC_STU_YR AS [STU_YEAR]
		
		INNER JOIN
		rev.EPC_STU_SCH_YR AS [StudentSchoolYear]
		ON
		[STU_YEAR].[STU_SCHOOL_YEAR_GU] = [StudentSchoolYear].[STUDENT_SCHOOL_YEAR_GU]
		
		INNER JOIN 
		rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[StudentSchoolYear].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		INNER JOIN 
		rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		
		INNER JOIN 
		rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON 
		[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
		
	) AS [STU_YEAR]
	ON	
	[STUDENT].[STUDENT_GU] = [STU_YEAR].[STUDENT_GU]
	AND [STU_YEAR].[RN] = 1
	
WHERE 
	--[DOSAGE].[IN_COMPLIANCE] = 'Y'
	[VACCINE].[IN_COMLIANCE] = 'Y'
	
	
--UPDATE rev.EPC_STU_IMM_DOSAGE
--SET IN_COMPLIANCE = 'N'