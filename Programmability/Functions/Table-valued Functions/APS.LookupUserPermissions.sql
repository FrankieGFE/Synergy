/**
 * $LastChangedBy: Don Jarrett 
 * $LastChangedDate: 2014-08-29 
 *
 * This function takes a login name as a parameter and returns all the schools that a user
 * can focus to. If the user has a district access it is returned as 'APS'.
 */

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[LookupUserPermissions]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.LookupUserPermissions() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

ALTER FUNCTION APS.LookupUserPermissions(@loginName VARCHAR(50))
RETURNS TABLE
AS
RETURN	
SELECT 
    u.LOGIN_NAME
    ,ugo.ORGANIZATION_UPDATE
    ,o.ORGANIZATION_NAME
    ,ISNULL(s.SCHOOL_CODE,'APS') AS [SCHOOL_CODE]
    ,ug.USERGROUP_NAME
FROM 
    [rev].[REV_USER] AS [u]

    INNER JOIN
    [rev].[REV_USER_USERGROUP] AS [uug]

    ON
    [u].[USER_GU]=[uug].[USER_GU]

    INNER JOIN
    [rev].[REV_USERGROUP_ORGANIZATION] AS [ugo]

    ON
    [uug].[USERGROUP_GU]=[ugo].[USERGROUP_GU]

    INNER JOIN
    [rev].[REV_ORGANIZATION] AS [o]

    ON
    [ugo].[ORGANIZATION_GU]=[o].[ORGANIZATION_GU]

    LEFT JOIN
    [rev].[EPC_SCH] AS [s]

    ON
    [o].[ORGANIZATION_GU]=[s].[ORGANIZATION_GU]

    INNER JOIN
    [rev].[REV_USERGROUP] AS [ug]

    ON
    [uug].[USERGROUP_GU]=[ug].[USERGROUP_GU]

WHERE
    [u].[LOGIN_NAME]=@loginName
