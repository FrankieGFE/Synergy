




SELECT
	[SUBJECT_AREA_1]
	,COUNT([BADGE_NUM]) AS [TOTAL]
FROM	
	(
	SELECT
		[Organization].[ORGANIZATION_NAME] AS [SCHOOL_NAME]
		,[SCHEDULE].[DEPARTMENT]
		,[SCHEDULE].[SUBJECT_AREA_1]
		--,[SCHEDULE].[SUBJECT_AREA_1]
		,[STAFF_PERSON].[LAST_NAME]
		,[STAFF_PERSON].[FIRST_NAME]
		,[STAFF_PERSON].[MIDDLE_NAME]
		,REPLACE([STAFF].[BADGE_NUM],'e','') AS [BADGE_NUM]
		
	FROM
		APS.ScheduleAsOf(GETDATE()) AS [SCHEDULE]
		
		INNER JOIN 
		rev.REV_ORGANIZATION_YEAR AS [OrgYear] -- Links between School and Year
		ON 
		[SCHEDULE].[ORGANIZATION_YEAR_GU] = [OrgYear].[ORGANIZATION_YEAR_GU]
		
		INNER JOIN 
		rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
		ON 
		[OrgYear].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
		
		-- Get both primary and secodary staff
		INNER JOIN
		(
		SELECT
			[STAFF_SCHOOL_YEAR_GU]
			,[STAFF_GU]
			,[ORGANIZATION_YEAR_GU]
			,1 AS [PRIMARY_STAFF]
		FROM
			rev.[EPC_STAFF_SCH_YR] AS [STAFF_SCHOOL_YEAR]		
		) AS [ALL_STAFF_SCH_YR]
		ON
	   [SCHEDULE].[STAFF_SCHOOL_YEAR_GU] = [ALL_STAFF_SCH_YR].[STAFF_SCHOOL_YEAR_GU]
	   
		INNER JOIN
		rev.[EPC_STAFF] AS [STAFF]
		ON
		[ALL_STAFF_SCH_YR].[STAFF_GU] = [STAFF].[STAFF_GU]

		INNER JOIN
		rev.[REV_PERSON] AS [STAFF_PERSON]
		ON
		[STAFF].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]

	WHERE
		[SCHEDULE].[DEPARTMENT] = 'Math'

	GROUP BY
		[Organization].[ORGANIZATION_NAME]
		,[SCHEDULE].[DEPARTMENT]
		,[SUBJECT_AREA_1]
		,[STAFF_PERSON].[LAST_NAME]
		,[STAFF_PERSON].[FIRST_NAME]
		,[STAFF_PERSON].[MIDDLE_NAME]
		,[STAFF].[BADGE_NUM]
	) AS [TEACHERS]

GROUP BY
	[SUBJECT_AREA_1]
	
ORDER BY
	[SUBJECT_AREA_1]	
