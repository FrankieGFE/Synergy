/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 6/10/2014
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 5/15/2014
 * 
 * Initial Request: Pull all records from HE020 and format them to be imported into Synergy Immunization table.
 *
 * Description: Convert all Immunization entries into a format that can be uploaded to Synergy.
 * One Record Per Entry
 *
 * Tables Referenced: HE020
 */



SELECT
	[Immunizations].[ID_NBR] AS [SIS_NUMBER]
	,'' AS [SCHOOL_YEAR]
	,'' AS [SCHOOL_CODE]
	,[Immunizations].[IMMTYPE] AS [VACCINATION]
	,CASE WHEN [Immunizations].[IMMDATE] = '0' THEN '' ELSE CONVERT(VARCHAR,[Immunizations].[IMMDATE]) END AS [DOSAGE_DATE]
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
	
WHERE
	[Immunizations].[IMMDATE] BETWEEN '19970000' AND '19979999'
