
SELECT
	*
FROM
	(
	SELECT DISTINCT
		--[SECTION_STAFF].*
		[STAFF_PERSON].[FIRST_NAME]
		,[STAFF_PERSON].[LAST_NAME]
		,[STAFF_PERSON].[EMAIL]
		,[STAFF].[BADGE_NUM]
		
		,[School].[SCHOOL_CODE]
		,[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
		--,[COURSE].[COURSE_ID]
		,[COURSE].[COURSE_TITLE]
		
		,[RevYear].[SCHOOL_YEAR]
		
		--,[SchoolYearCourse].*
		,ROW_NUMBER() OVER (PARTITION BY [SECTION_STAFF].[STAFF_GU] ORDER BY [RevYear].[SCHOOL_YEAR] DESC) AS RN
	FROM
		APS.SectionsAndAllStaffAssigned AS [SECTION_STAFF]
		
		INNER JOIN 
		rev.[EPC_SCH_YR_SECT] AS [Section]
		ON
		[SECTION_STAFF].[SECTION_GU] = [Section].[SECTION_GU]
		
		INNER JOIN 
		rev.[EPC_SCH_YR_CRS] AS [SchoolYearCourse]
		ON 
		[Section].[SCHOOL_YEAR_COURSE_GU] = [SchoolYearCourse].[SCHOOL_YEAR_COURSE_GU]
		
		INNER JOIN
		rev.EPC_CRS AS [COURSE]
		ON
		[SchoolYearCourse].[COURSE_GU] = [COURSE].[COURSE_GU]
		
		INNER JOIN 
		rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[SchoolYearCourse].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		INNER JOIN 
		rev.REV_YEAR AS [RevYear] -- Contains the School Year
		ON 
		[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
		
		INNER JOIN 
		rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		
		INNER JOIN 
		rev.EPC_SCH AS [School] -- Contains the School Code / Number
		ON 
		[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
		
		INNER JOIN
		rev.EPC_STAFF AS [STAFF]
		ON
		[SECTION_STAFF].[STAFF_GU] = [STAFF].[STAFF_GU]
		
		INNER JOIN
		rev.REV_PERSON AS [STAFF_PERSON]
		ON
		[SECTION_STAFF].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]
		
	WHERE
		[School].[SCHOOL_CODE] = '592'
	) AS [TEACHERS]
	
WHERE
	[TEACHERS].[RN] = 1