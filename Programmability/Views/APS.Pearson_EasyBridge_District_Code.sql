/**
 * 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 8/09/2016
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
 CREATE VIEW APS.Pearson_EasyBridge_District_code
 AS

SELECT
	'001' AS [district_code]
	,[Organization].[ORGANIZATION_NAME] AS [district_name]
	,[ADDRESS].[ADDRESS] AS [address_1]
	,[ADDRESS].[ADDRESS2] AS [address_2]
	,[ADDRESS].[CITY] AS [city]
	,[ADDRESS].[STATE] AS [state]
	,[ADDRESS].[ZIP_5] AS [zip]
	,[Organization].[PHONE] AS [phone]
	,'2016' AS [current_school_year]
	
FROM
	rev.REV_ORGANIZATION AS [Organization]
	
	LEFT OUTER JOIN
	rev.REV_ADDRESS AS [ADDRESS]
	ON
	[Organization].[ADDRESS_GU] = [ADDRESS].[ADDRESS_GU]
	
WHERE
	[Organization].[ORGANIZATION_GU] = '8D749524-419B-4CB2-BEAE-134B947A853D'