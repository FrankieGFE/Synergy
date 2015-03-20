SELECT
    [g].[GRID_CODE]
    ,[s].[STREET_LOW_ADDRESS]
    ,[s].[STREET_HIGH_ADDRESS]
    ,[s].[STREET_NAME]
    ,[Lookup].[VALUE_DESCRIPTION]
    ,[s].[STREET_POST_DIRECTION]
    ,[s].[CITY]
    ,[s].[STATE]
    ,[s].[ZIP_5]
FROM
    [rev].[EPC_GRID] AS [g]

    INNER JOIN
    [rev].[EPC_STREET] AS [s]
    ON
    [g].[GRID_GU]=[s].[GRID_GU]

    INNER JOIN	 
    [APS].[LookupTable]('K12.AddressInfo','STREET_TYPE') AS [Lookup]
    ON
    [s].[STREET_TYPE]=[Lookup].[VALUE_CODE]

WHERE
    [g].[SCHOOL_YEAR]=(SELECT * FROM [rev].[SIF_22_Common_CurrentYear])

ORDER BY
    [g].[GRID_CODE]
