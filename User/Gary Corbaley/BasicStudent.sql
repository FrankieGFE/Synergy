/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 08/26/2014 $
 *
 * Request By: Brian Rieb
 * InitialRequestDate: 08/26/2014
 * 
 * This script will pull detail demographic information for all students in the system
 * One Record Per Student
 */



SELECT
	[Student].[STUDENT_GU]
	,[Student].[SIS_NUMBER]
	,[Student].[STATE_STUDENT_NUMBER]
	,[Person].[LAST_NAME]
	,[Person].[FIRST_NAME]
	,[Person].[MIDDLE_NAME]
	,[Person].[BIRTH_DATE]
	,[Person].[GENDER]
	,[Language].[VALUE_DESCRIPTION] AS [HOME_LANGUAGE]
	,[Student].[EXPECTED_GRADUATION_YEAR] AS [CLASS_OF]	
	,[Person].[HISPANIC_INDICATOR]
	,[Person].[HOME_ADDRESS_GU]
	,[HOME_ADDRESS].[ADDRESS] AS [HOME_ADDRESS]
	,[HOME_ADDRESS].[ADDRESS2] AS [HOME_ADDRESS_2]
	,[HOME_ADDRESS].[CITY] AS [HOME_CITY]
	,[HOME_ADDRESS].[STATE] AS [HOME_STATE]
	,[HOME_ADDRESS].[ZIP_5] AS [HOME_ZIP]
	,[Person].[MAIL_ADDRESS_GU]
	,[MAIL_ADDRESS].[ADDRESS] AS [MAIL_ADDRESS]
	,[MAIL_ADDRESS].[ADDRESS2] AS [MAIL_ADDRESS_2]
	,[MAIL_ADDRESS].[CITY] AS [MAIL_CITY]
	,[MAIL_ADDRESS].[STATE] AS [MAIL_STATE]
	,[MAIL_ADDRESS].[ZIP_5] AS [MAIL_ZIP]
FROM
	-- Get District and State ID Numbers
	rev.EPC_STU AS [Student]		
		
	-- Get Personal Details
	INNER JOIN
	rev.REV_PERSON AS [Person]
	ON
	[Student].[STUDENT_GU] = [Person].[PERSON_GU]
	
	-- Get Home Language
	LEFT OUTER JOIN
	APS.LookupTable ('K12', 'Language') AS [Language]	
	ON
	[Student].[HOME_LANGUAGE] = [Language].[VALUE_CODE]
	
	-- Get Home Address
	LEFT OUTER JOIN
	rev.REV_ADDRESS AS [HOME_ADDRESS]
	ON
	[Person].[HOME_ADDRESS_GU] = [HOME_ADDRESS].[ADDRESS_GU]
	
	-- Get Mailing Address
	LEFT OUTER JOIN
	rev.REV_ADDRESS AS [MAIL_ADDRESS]
	ON
	[Person].[MAIL_ADDRESS_GU] = [MAIL_ADDRESS].[ADDRESS_GU]