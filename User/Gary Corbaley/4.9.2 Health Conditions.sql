/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 6/10/2014
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 5/15/2014
 * 
 * Initial Request: Pull all records from HE015 and format them to be imported into Synergy Health Conditions table.
 *
 * Description: Convert all health condition entries into a format that can be uploaded to Synergy.
 * One Record Per Entry
 *
 * Tables Referenced: HE015
 */



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