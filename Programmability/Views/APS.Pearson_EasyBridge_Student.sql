/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 8/24/2015
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 08/19/2015
 * 
 * Initial Request: Pull all active students for Pearson EasyBridge extract
 *
 * Description: 
 * One Record Per Student
 *
 * Tables Referenced: 
 */
 ALTER VIEW APS.Pearson_EasyBridge_Student
 AS
 
SELECT
	[STUDENT].[SIS_NUMBER] AS [student_code]
	,[STUDENT].[LAST_NAME] AS [last_name]
	,[STUDENT].[FIRST_NAME] AS [first_name]
	,[STUDENT].[MIDDLE_NAME] AS [middle_name]
	,[STUDENT].[GENDER] AS [gender_code]
	,CONVERT(VARCHAR(4),YEAR([STUDENT].[BIRTH_DATE])) + '-' + RIGHT('00' + CONVERT(VARCHAR(2),DATEPART(MM,[STUDENT].[BIRTH_DATE])),2) + '-' + RIGHT('00' + CONVERT(VARCHAR(2),DATEPART(DD,[STUDENT].[BIRTH_DATE])),2) AS [dob]
	,[PERSON].[EMAIL] AS [email]
	,[STUDENT].[SIS_NUMBER] AS [student_number]
	,[STUDENT].[SIS_NUMBER] AS [federated_id]
	
FROM
	APS.PrimaryEnrollmentDetailsAsOf('08/11/2016') [ENROLLMENT]
	
	INNER JOIN
	APS.BasicStudent AS [STUDENT]
	ON
	[ENROLLMENT].[STUDENT_GU] = [STUDENT].[STUDENT_GU]
	
	INNER JOIN
	rev.REV_PERSON AS [PERSON]
	ON
	[ENROLLMENT].[STUDENT_GU] = [PERSON].[PERSON_GU]
	
WHERE
	[ENROLLMENT].[GRADE] IN ('06','07','08')