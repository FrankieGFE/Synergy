/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 8/24/2015
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 08/19/2015
 * 
 * Initial Request: Pull all active courses for Pearson EasyBridge extract
 *
 * Description: 
 * One Record Per course
 *
 * Tables Referenced: 
 */
ALTER VIEW APS.Pearson_EasyBridge_Staff_S
AS

 
SELECT DISTINCT	
	REPLACE([STAFF].[BADGE_NUM],'e','') AS [staff_code]
	,[STAFF_PERSON].[LAST_NAME] AS [last_name]
	,[STAFF_PERSON].[FIRST_NAME] AS [first_name]
	,[STAFF_PERSON].[MIDDLE_NAME] AS [middle_name]
	,[STAFF_PERSON].[EMAIL] AS [email]
	,'' AS [title]
	,REPLACE([STAFF].[BADGE_NUM],'e','') AS [staff_number]
	,[STAFF].[BADGE_NUM] AS [federated_id]
	
FROM
	APS.PrimaryEnrollmentDetailsAsOf(GETDATE()) AS [ENROLLMENT]
	
	INNER JOIN
	APS.ScheduleDetailsAsOf(GETDATE()) AS [SCHEDULE]
	ON
	[ENROLLMENT].[STUDENT_GU] = [SCHEDULE].[STUDENT_GU]
	AND [ENROLLMENT].[ORGANIZATION_YEAR_GU] = [SCHEDULE].[ORGANIZATION_YEAR_GU]
	
	INNER JOIN
	rev.[EPC_STAFF] AS [STAFF]
	ON
	[SCHEDULE].[STAFF_GU] = [STAFF].[STAFF_GU]
	
	INNER JOIN
	rev.[REV_PERSON] AS [STAFF_PERSON]
	ON
	[STAFF].[STAFF_GU] = [STAFF_PERSON].[PERSON_GU]
	
WHERE
	[ENROLLMENT].[GRADE] IN ('06','07','08')