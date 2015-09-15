





SELECT
	'001' AS [district_code]
	,[Organization].[ORGANIZATION_NAME] AS [district_name]
	,[ADDRESS].[ADDRESS] AS [address_1]
	,[ADDRESS].[ADDRESS2] AS [address_2]
	,[ADDRESS].[CITY] AS [city]
	,[ADDRESS].[STATE] AS [state]
	,[ADDRESS].[ZIP_5] AS [zip]
	,[Organization].[PHONE] AS [phone]
	,'2015' AS [current_school_year]
	
FROM
	rev.REV_ORGANIZATION AS [Organization]
	
	LEFT OUTER JOIN
	rev.REV_ADDRESS AS [ADDRESS]
	ON
	[Organization].[ADDRESS_GU] = [ADDRESS].[ADDRESS_GU]
	
WHERE
	[Organization].[ORGANIZATION_GU] = '8D749524-419B-4CB2-BEAE-134B947A853D'
	
	