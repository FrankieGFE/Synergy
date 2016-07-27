

CREATE VIEW APS.iReadyStaff AS

SELECT
	[Client ID]
	,[School ID]
	,[Staff Member SIS ID]
	,[First Name]
	,[Last Name]
	,[Role]
	,[EMAIL]
	,[User Name]
	,[Password]
	,[Partner ID]
	,[Action]
	,[Reserved1]
	,[Reserved2]
	,[Reserved3]
	,[Reserved4]
	,[Reserved5]
	,[Reserved6]
	,[Reserved7]
	,[Reserved8]
	,[Reserved9]
	,[Reserved10]
FROM
(
SELECT DISTINCT
	'nm-albuq87774' AS [Client ID]
	,[School].[SCHOOL_CODE] AS [School ID]
	,REPLACE([STAFF].[BADGE_NUM],'e','') AS [Staff Member SIS ID]
	,[STAFF_PERSON].[FIRST_NAME] AS [First Name]
	,[STAFF_PERSON].[LAST_NAME] AS [Last Name]
	,CASE 
		WHEN [STAFF].[TYPE] = 'TE' THEN 'Teacher'
		WHEN [STAFF].[TYPE] = 'DA' THEN 'SchoolAdministrator'
		WHEN [STAFF].[TYPE] = 'SA' THEN 'SchoolAdministrator'
		WHEN [STAFF].[TYPE] = 'SCA' THEN 'SchoolAdministrator'
		WHEN [STAFF].[TYPE] = 'ED' THEN 'Teacher'
		ELSE 'SchoolAdministrator'
	END AS [Role]
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
	,ROW_NUMBER() OVER (PARTITION BY REPLACE([STAFF].[BADGE_NUM],'e',''), [STAFF_PERSON].[FIRST_NAME] ORDER BY [STAFF_PERSON].[LAST_NAME] DESC) AS RN
	
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
	
	INNER JOIN 
	rev.REV_YEAR AS [RevYear] -- Contains the School Year
	ON 
	[OrgYear].[YEAR_GU] = [RevYear].[YEAR_GU]
	
WHERE
	[OrgYear].[YEAR_GU] IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
	--[RevYear].[SCHOOL_YEAR] = '2015'
	--AND [RevYear].[EXTENSION] = 'R'
	AND [STAFF_PERSON].[FIRST_NAME] != 'Teacher'
	AND [STAFF_PERSON].[EMAIL] IS NOT NULL
	AND ISNUMERIC(REPLACE([STAFF].[BADGE_NUM],'e','')) = 1
	AND LEFT(REPLACE([STAFF].[BADGE_NUM],'e',''),1) != '9'
	AND REPLACE([STAFF].[BADGE_NUM],'e','') NOT IN ('222222222','666666666','777777777','888888888','999999999')
) AS [SUB1]

WHERE
	[RN] = 1