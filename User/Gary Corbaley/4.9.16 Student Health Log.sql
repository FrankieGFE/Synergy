/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 6/10/2014
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 5/15/2014
 * 
 * Initial Request: Pull all records from HE020 and format them to be imported into Synergy Health Log table.
 *
 * Description: Convert all Health Log entries into a format that can be uploaded to Synergy.
 * One Record Per Entry
 *
 * Tables Referenced: HE050
 */



SELECT DISTINCT
	'2013' AS [SCHOOL_YEAR]
	,[Health Log].[SCH_NBR] AS [SCHOOL_CODE]
	,'e' + CONVERT(VARCHAR,CASE WHEN [Opperator].[OPER_NBR] IS NULL THEN '117025' ELSE [Opperator].[OPER_NBR] END) AS [ENTERED_BY]
	,[Health Log].[LOGDATE] AS [EFFECTIVE_DATE]
	,[Health Log].[LOG_REACD] AS [HEALTH_CODE]
	,[Health Log].[ID_NBR] AS [SIS_NUMBER]
	,[Health Log].[LOG_REASON] + [Health Log].[LOG_RESULT] + [Health Log].[LOG_COMNT] AS [ACCIDENT_DESC]
	,[Health Log].[LOG_ACTCD] AS [ACTION_TAKEN]
	,'' AS [CARE_GIVER]
	,'' AS [CONTACT_ATTEMPT_TIME]
	,'' AS [CONTACT_MADE_TIME]
	,'' AS [END_DATE]
	,'' AS [FOLLOW_UP]
	,'' AS [FOLLOW_UP_DATE]
	,'' AS [HOW_PARENT_NOTIFIED]
	,'' AS [INCIDENT_ACTIVITY]
	,'' AS [INCIDENT_DATE]
	,'' AS [INCIDENT_DESC]
	,'' AS [INCIDENT_EQUIPMENT]
	,'' AS [INCIDENT_LOCATION]
	,'' AS [INCIDENT_TIME]
	,'' AS [INJURY Lookup]
	,'' AS [INSURANCE_COVERAGE]
	,'' AS [MEDICAL_CARE_REC]
	,'' AS [NOTIFIED_PARENT_LN]
	,'' AS [NOTIFIED_PARENT_FN]
	,'' AS [OTHER_INJURIES]
	,'' AS [PREVENTIVE_MEASURE]
	,'' AS [REASON_PRESENT]
	,'' AS [REFERRED_BY]
	,'' AS [SUPERVISING_STAFF_BADGE_NUM]
	,'' AS [SUBJ_OBJ_COMMENT]
	,'' AS [TAKEN_BY]
	,'' AS [TAKEN_TIME]
	,[Health Log].[TMEIN] AS [TIME_IN]
	,[Health Log].[TMEOUT] AS [TIME_OUT]
	,'' AS [WHERE_TAKEN]
	,'' AS [WHO_NOTIFIED_PARENT]
	,'' AS [WITNESSES]
	,CASE WHEN [Health Log].[LOG_OUTCD] = '' THEN '' ELSE CONVERT(VARCHAR,[Health Log].[LOG_OUTCD]) + '-' + [OutcomeCodes].[CODE_DESCR] END AS [UD_HealthInfo_UDHealthIncident_Outcome]
	
FROM
	[DBTSIS].[HE050_V] AS [Health Log]
	
	LEFT OUTER JOIN
	[DBTOAS].[OS010_V] AS [Opperator]
	
	ON
	[Health Log].[MNT_INIT] = [Opperator].[OPER_INIT]
	
	LEFT OUTER JOIN
	[DBTSIS].[HE082_V] AS [OutcomeCodes]
	
	ON
	[Health Log].[DST_NBR] = [OutcomeCodes].[DST_NBR]
	AND [Health Log].[LOG_OUTCD] = [OutcomeCodes].[CODE_NME]
	AND [OutcomeCodes].[CODE_TYPE] = 'OUTCD'
	
WHERE
	[Health Log].[LOGDATE] BETWEEN '20130813' AND '20140522'