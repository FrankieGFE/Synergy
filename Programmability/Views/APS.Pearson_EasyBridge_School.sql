/**
 * 
 * $LastChangedBy: Gary Corbaley
 * $LastChangedDate: 8/24/2015
 *
 * Request By: Andy Gutierrez
 * InitialRequestDate: 08/19/2015
 * 
 * Initial Request: Pull all active schools for Pearson EasyBridge extract
 *
 * Description: 
 * One Record Per School
 *
 * Tables Referenced: 
 */
 ALTER VIEW
 APS.Easy_Bridge_School
 AS
 
SELECT DISTINCT
	[ENROLLMENT].[SCHOOL_CODE] AS [school_code]
	,[ENROLLMENT].[SCHOOL_NAME] AS [school_name]
	,'001' AS [district_code]
	,'' AS [grade_start]
	,'' AS [grade_end]
	
	,[SCHOOL_ADDRESS].[ADDRESS] AS [address_1]
	,[SCHOOL_ADDRESS].[ADDRESS2] AS [address_2]
	,[SCHOOL_ADDRESS].[CITY] AS [city]
	,[SCHOOL_ADDRESS].[STATE] AS [state]
	,CONVERT(VARCHAR(5),[SCHOOL_ADDRESS].[ZIP_5]) + '-0000' AS [zip]
	
	,LEFT([Organization].[PHONE],3) + '-' + RIGHT(LEFT([Organization].[PHONE],6),3) + '-' + RIGHT([Organization].[PHONE],4) AS [phone]
	
FROM
	APS.PrimaryEnrollmentDetailsAsOf('08/11/2016') [ENROLLMENT]
	
	INNER JOIN
	rev.REV_ORGANIZATION AS [Organization] -- Contains the School Name
	ON 
	[ENROLLMENT].[ORGANIZATION_GU] = [Organization].[ORGANIZATION_GU]
	
	-- Get Mailing Address
	LEFT OUTER JOIN
	rev.REV_ADDRESS AS [SCHOOL_ADDRESS]
	ON
	[Organization].[ADDRESS_GU] = [SCHOOL_ADDRESS].[ADDRESS_GU]
	
WHERE
	[ENROLLMENT].[GRADE] IN ('06','07','08')