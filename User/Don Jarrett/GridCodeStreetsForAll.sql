EXECUTE AS LOGIN='QueryFileUser'
GO

SELECT
    *
FROM
(SELECT
    [s].*
    ,ROW_NUMBER() OVER (PARTITION BY [GC].[HSE_NBR],[GC].[STREET],[GC].[CITY],[GC].[STATE] ORDER BY [GC].[APT]) AS [RN]
FROM
    [rev].[EPC_GRID] AS [g]

    INNER HASH JOIN
    [rev].[EPC_STREET] AS [s]
    ON
    [g].[GRID_GU]=[s].[GRID_GU]

    INNER HASH JOIN	 
    [APS].[LookupTable]('K12.AddressInfo','STREET_TYPE') AS [Lookup]
    ON
    [s].[STREET_TYPE]=[Lookup].[VALUE_CODE]

    INNER HASH JOIN
    OPENROWSET('Microsoft.ACE.OLEDB.12.0', 
	   'Excel 12.0;Database=\\syntempssis.aps.edu.actd\Files\TempQuery\Dwellings4082014_2.xlsx;', 
	   'SELECT * from [Dwellings4082014$]') AS [GC]
    ON
    [s].[STREET_NAME]=[GC].[STREET]
    AND [s].[STREET_HIGH_ADDRESS]=[GC].[HSE_NBR]
    AND [s].[CITY]=[GC].[CITY]
    AND [s].[STATE]=[GC].[STATE]
    AND LEFT(CAST([GC].[ZIPCODE] AS VARCHAR(10)),5)=[s].[ZIP_5]

WHERE
    [g].[SCHOOL_YEAR]=2015
) AS [All]

WHERE
[All].[RN]=1

	   
REVERT
GO
