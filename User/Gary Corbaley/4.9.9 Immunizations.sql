




SELECT
	[Immunizations].[ID_NBR] AS [SIS_NUMBER]
	,'' AS [SCHOOL_YEAR]
	,'' AS [SCHOOL_CODE]
	,[Immunizations].[IMMTYPE] AS [VACCINATION]
	,[Immunizations].[IMMDATE] AS [DOSAGE_DATE]
	,'' AS [COMMENT]
	,[Immunizations].[IMMEXMPT] AS [EXEMPT_REASON]
	,'' AS [SOURCE]
	,'' AS [FEEDER_DISTRICT_ID]
	,'' AS [FEEDER_STUDENT_ID]
	,'' AS [EXEMPT_GRANTED]
	,'' AS [VACCINE_COMPLIANCE]
	,'' AS [DOSAGE_COMPLIANCE]
FROM
	[DBTSIS].[HE020_V] AS [Immunizations]
