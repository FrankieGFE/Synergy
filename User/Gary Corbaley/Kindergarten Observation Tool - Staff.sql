



SELECT DISTINCT
	'K3P' AS [WindowName]
	,'001' AS [DistrictCode]
	,[School].[SCHOOL_CODE] AS [LocationCode]
	,[STAFF_PERSON].[FIRST_NAME] AS [FirstName]
	,[STAFF_PERSON].[LAST_NAME] AS [LastName]
	--,[STARS_STAFF].[StaffId] AS [StaffID]
	--,REPLACE([LAWSON].[FICA_NBR],'-','') AS [StaffID]
	,RIGHT(CONVERT(VARCHAR(9),REPLACE([LAWSON].[FICA_NBR],'-','')),5) AS [StaffID]
	--,REPLACE([STAFF].[BADGE_NUM],'e','') AS [StaffAltID]
	,[STAFF_PERSON].[EMAIL] AS [Email]
	,CONVERT(VARCHAR(10),[STAFF_PERSON].[BIRTH_DATE],101) AS [Birthdate]
	--,[STARS_STAFF].[Birthdate] AS [Birthdate]
	,[STAFF_PERSON].[GENDER]
	,'' AS [Statement]
	,'' AS [ErrorDesc]
FROM
	APS.StudentScheduleDetails AS [SCHEDULE]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[SCHEDULE].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	
	INNER JOIN
	rev.[REV_YEAR] AS [YEAR]
	ON
	[SCHEDULE].[YEAR_GU] = [YEAR].[YEAR_GU]	
   
	INNER JOIN
	rev.[EPC_STAFF] AS [STAFF]
	ON
	[SCHEDULE].[STAFF_GU] = [STAFF].[STAFF_GU]

	INNER JOIN
	rev.[REV_PERSON] AS [STAFF_PERSON]
	ON
	[STAFF].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]
	
	--LEFT OUTER JOIN
	--(
	--SELECT
	--	*
	--FROM
	--	[046-WS02.APS.EDU.ACTD].[db_STARS_History].[dbo].[STAFF]
		
	--WHERE
	--	[Period] = '2015-06-01'
	--) AS [STARS_STAFF]
	--ON
	--REPLACE([STAFF].[BADGE_NUM],'e','') = [STARS_STAFF].[Field3]
	
	LEFT OUTER JOIN
	(
	SELECT 
		   -- IN SYNERGY USE THE BADGE_NUMBER SUBSTRING(BADGE_NUMBER,2,6) OR USE THE STATE_NUMBER (has no 'e') and join to the EMPLOYEE field in the EMPLOYEE table.
		   EMPLOYEE
		   ,FICA_NBR
	FROM 
	[180-SMAXODS-01.aps.edu.actd].Lawson.dbo.Employee
	) AS [LAWSON]
	ON
	REPLACE([STAFF].[BADGE_NUM],'e','') = [LAWSON].[EMPLOYEE]
	
WHERE
	--[SCHEDULE].[COURSE_ID] IN ('00056015','00004000','00008000','00014001','00018001','00052015')
	--AND 
	(
	--([YEAR].[SCHOOL_YEAR] = '2015' AND [YEAR].[EXTENSION] = 'R')
	--OR
	([YEAR].[SCHOOL_YEAR] = '2016' AND [YEAR].[EXTENSION] = 'N')
	)
	--AND [School].[SCHOOL_CODE] IN ('315','321','207','329','229','203','241','244','350','219','255','328','267','270','395','276','217','300','317','360','389','363','370','264')
	--AND [School].[SCHOOL_CODE] BETWEEN '200' AND '399'
	
	AND [STAFF_PERSON].[LAST_NAME] != 'Closed'
	AND [STAFF_PERSON].[BIRTH_DATE] IS NOT NULL
