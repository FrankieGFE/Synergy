



SELECT
	[Conditions].[ID_NBR] AS [SIS_NUMBER]
	,'' AS [SCHOOL_YEAR]
	,'' AS [SCHOOL_CODE]
	,[Conditions].[START_DT] AS [DATE_ENTERED]
	,[Conditions].[HLCODE] AS [CONDITION_CODE]
	,'' AS [COMMENT]
	,'' AS [SOURCE]
	,'' AS [FEEDER_DISTRICT_ID]
	,'' AS [FEEDER_STUDENT_ID]
FROM	
	[DBTSIS].[HE015_V] AS [Conditions]