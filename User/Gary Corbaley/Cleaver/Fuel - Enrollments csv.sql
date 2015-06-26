



SELECT DISTINCT
	[School].[SCHOOL_CODE]  AS [School_id]
	,CONVERT(VARCHAR,[School].[SCHOOL_CODE]) + '-' + CONVERT(VARCHAR,[SCHEDULE].[SECTION_ID]) AS [Section_id]
	,[STUDENT].[SIS_NUMBER] AS [Student_id]
	
FROM
	APS.ScheduleAsOf(GETDATE()) AS [SCHEDULE]
	
	INNER JOIN 
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[SCHEDULE].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	INNER JOIN 
	rev.EPC_SCH AS [School] -- Contains the School Code / Number
	ON 
	[Organization].[ORGANIZATION_GU] = [School].[ORGANIZATION_GU]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[SCHEDULE].[STUDENT_GU] = [STUDENT].[STUDENT_GU]