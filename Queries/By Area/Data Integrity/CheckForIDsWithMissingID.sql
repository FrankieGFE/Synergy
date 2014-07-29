/**
 * $LastChangedBy: e204042 
 * $LastChangedDate: 2014-07-29
 *
 * Checks a file against the missing IDs in Synergy that were in SchoolMax to see
 * if they have any course history.
 *
 */

SELECT
    *
FROM
    (
	   SELECT
	   [SMAX].[ID_NBR]
	   ,[SMAX].[STATE_ID]
	   ,[Synergy].[SIS_NUMBER]
	   ,[Synergy].[STATE_STUDENT_NUMBER]
	   FROM
	   [DBTSIS].[CE020_V] AS [SMAX]

	   LEFT JOIN
	   OPENQUERY([011-SYNERGYDB.APS.EDU.ACTD],'SELECT [SIS_NUMBER],[STATE_STUDENT_NUMBER] FROM [ST_Production].[rev].[EPC_STU]') AS [Synergy]

	   ON
	   CAST([SMAX].[ID_NBR] AS VARCHAR(9))=CAST([Synergy].[SIS_NUMBER] AS VARCHAR(9))

	   WHERE
	   [Synergy].[SIS_NUMBER] IS NULL
    ) as [SMAX]

    LEFT JOIN
    OPENROWSET ('MSDASQL', 'Driver={Microsoft Access Text Driver (*.txt, *.csv)};DBQ=D:\SQLWorkingFiles;', 'SELECT * from "StudentCourseHistory-Additive-7-22.csv"') AS [crs]

    ON 
    --CAST([SMAX].[ID_NBR] AS VARCHAR(9))=[crs].[SIS_NUMBER]
    [SMAX].[ID_NBR]=[crs].[SIS_NUMBER]

WHERE
    [crs].[SIS_NUMBER] IS NOT NULL

