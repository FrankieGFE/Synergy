CREATE VIEW APS.GeoCode_Street_Segments
AS

SELECT
	[st].[SCHOOL_YEAR]
	,ISNULL([gr].[GRID_CODE],'') AS [GRID_CODE]
	,[st].[STREET_LOW_ADDRESS]
	,[st].[STREET_HIGH_ADDRESS]
	,[st].[STREET_NAME]
	,ISNULL([typ].[VALUE_DESCRIPTION],'') AS [STREET_TYPE]
	,ISNULL([st].[STREET_POST_DIRECTION],'') AS [STREET_POST_DIRECTION]
	,[st].[CITY]
	,[st].[STATE]
	,[st].[ZIP_5]
FROM
	[rev].[EPC_STREET] AS [st]

	LEFT JOIN
	[APS].[LookupTable]('K12.AddressInfo','STREET_TYPE') AS [typ]
	ON
	[st].[STREET_TYPE]=[typ].[VALUE_CODE]

	LEFT JOIN
	[rev].[EPC_GRID] AS [gr]
	ON
	[st].[GRID_GU]=[gr].[GRID_GU]

WHERE
	[st].[SCHOOL_YEAR]=(SELECT [SCHOOL_YEAR] FROM [rev].[SIF_22_Common_CurrentYear])