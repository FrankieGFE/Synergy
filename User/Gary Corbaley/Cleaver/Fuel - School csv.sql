



SELECT --DISTINCT 
	[ENROLLMENTS].[SCHOOL_CODE] AS [School_id]
	,[ENROLLMENTS].[SCHOOL_NAME] AS [School_name]
	,'' AS [State_id]
	,'' AS [Nces_id]
	,'' AS [Low_grade]
	,'' AS [High_grade]
	,'' AS [Principal]
	,'' AS [Pricipal_email]
	,[SCHOOL_ADDRESS].[ADDRESS] AS [School_address]
	,[SCHOOL_ADDRESS].[CITY] AS [School_city]
	,[SCHOOL_ADDRESS].[STATE] AS [School_state]
	,[SCHOOL_ADDRESS].[ZIP_5] AS [School_zip]
FROM
	APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS [ENROLLMENTS]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[ENROLLMENTS].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	-- Get Home Address
	LEFT OUTER JOIN
	rev.REV_ADDRESS AS [SCHOOL_ADDRESS]
	ON
	[Organization].[ADDRESS_GU] = [SCHOOL_ADDRESS].[ADDRESS_GU]