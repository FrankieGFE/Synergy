


SELECT
	[School].[SCHOOL_CODE] AS [School_id]
	,REPLACE([STAFF].[BADGE_NUM],'e','') AS [Teacher_id]
	,'' AS [Teacher_number]
	,[STAFF_PERSON].[LAST_NAME] AS [Last_Name]
	,[STAFF_PERSON].[MIDDLE_NAME] AS [Middle_name]
	,[STAFF_PERSON].[FIRST_NAME] AS [First_name]
	,[STAFF_PERSON].[EMAIL] AS [Teacher_email]
	,'' AS [Title]
	,'' AS [Username]
	,'' AS [Password]
	
FROM
	rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]
	
	INNER JOIN 
	rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
	ON 
	[STAFF_SCHOOL_YEAR].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
	
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
	rev.[EPC_STAFF] AS [STAFF]
	ON
	[STAFF_SCHOOL_YEAR].[STAFF_GU] = [STAFF].[STAFF_GU]
	
	INNER JOIN
	rev.[REV_PERSON] AS [STAFF_PERSON]
	ON
	[STAFF].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]
	
WHERE
	[OrgYear].[YEAR_GU] IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
	
	AND	[School].[SCHOOL_CODE] BETWEEN '500' AND '599'