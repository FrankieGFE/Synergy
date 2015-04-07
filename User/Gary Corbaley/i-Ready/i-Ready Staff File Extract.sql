



SELECT DISTINCT
	'nm-albuq87774' AS [Client ID]
	,[School].[SCHOOL_CODE] AS [School ID]
	,REPLACE([STAFF].[BADGE_NUM],'e','') AS [Staff Member SIS ID]
	,[STAFF_PERSON].[FIRST_NAME] AS [First Name]
	,[STAFF_PERSON].[LAST_NAME] AS [Last Name]
	,[STAFF].[TYPE]
	,[STAFF_PERSON].[EMAIL]
	,[STAFF_PERSON].[EMAIL] AS [User Name]
	,'teacher' AS [Password]
	,'' AS [Partner ID]
	,'' AS [Action]
	,'' AS [Reserved1]
	,'' AS [Reserved2]
	,'' AS [Reserved3]
	,'' AS [Reserved4]
	,'' AS [Reserved5]
	,'' AS [Reserved6]
	,'' AS [Reserved7]
	,'' AS [Reserved8]
	,'' AS [Reserved9]
	,'' AS [Reserved10]
	
FROM
	rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
	
	INNER JOIN
	rev.[EPC_STAFF] AS [STAFF]
	ON
	[STAFF_SCHOOL_YEAR].[STAFF_GU] = [STAFF].[STAFF_GU]
	
	INNER JOIN
	rev.[REV_PERSON] AS [STAFF_PERSON]
	ON
	[STAFF].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]
	
	INNER JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[STAFF_SCHOOL_YEAR].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[OrgYear].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]