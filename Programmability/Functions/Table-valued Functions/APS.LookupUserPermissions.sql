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
	*
FROM
	(
	SELECT
		DISTINCT
	    CAST(o.ORGANIZATION_GU AS VARCHAR(128)) AS ORGANIZATION_GU
	    ,o.ORGANIZATION_NAME
	FROM 
	    [rev].[REV_USER] AS [u] --select all from the user table
	    INNER JOIN
	    [rev].[REV_USER_USERGROUP] AS [uug] --join in their usergroup
	    ON
	    [u].[USER_GU]=[uug].[USER_GU]

	    INNER JOIN
	    [rev].[REV_USERGROUP_ORGANIZATION] AS [ugo] --get the usergroup gu
	    ON
	    [uug].[USERGROUP_GU]=[ugo].[USERGROUP_GU]

	    INNER JOIN
	    [rev].[REV_ORGANIZATION] AS [o] --join the usergroup gu to rev_organization for the organization name
	    ON
	    [ugo].[ORGANIZATION_GU]=[o].[ORGANIZATION_GU]

	WHERE
	    [u].[LOGIN_NAME]=@loginName --narrow it down to just the specified username
	    AND o.ORGANIZATION_GU != '8D749524-419B-4CB2-BEAE-134B947A853D'

	UNION

	SELECT
		CAST(Org.ORGANIZATION_GU AS VARCHAR(128))
		,Org.ORGANIZATION_NAME
	FROM
		(
		SELECT 
			DISTINCT 1 AS HasDistrict
		FROM 
		    [rev].[REV_USER] AS [u] --select all from the user table
		    INNER JOIN
		    [rev].[REV_USER_USERGROUP] AS [uug] --join in their usergroup
		    ON
		    [u].[USER_GU]=[uug].[USER_GU]

		    INNER JOIN
		    [rev].[REV_USERGROUP_ORGANIZATION] AS [ugo] --get the usergroup gu
		    ON
		    [uug].[USERGROUP_GU]=[ugo].[USERGROUP_GU]

		    INNER JOIN
		    [rev].[REV_ORGANIZATION] AS [o] --join the usergroup gu to rev_organization for the organization name
		    ON
		    [ugo].[ORGANIZATION_GU]=[o].[ORGANIZATION_GU]


		WHERE
		    [u].[LOGIN_NAME]=@loginName --narrow it down to just the specified username
		    AND o.ORGANIZATION_GU = '8D749524-419B-4CB2-BEAE-134B947A853D'
		) AS HasDistrict

		LEFT JOIN
		rev.REV_ORGANIZATION AS Org
		ON
		Org.ORGANIZATION_NAME NOT LIKE 'ZZ %'
		AND Org.IS_LEAF = 'Y'

	UNION

	SELECT
		DistrictWide.ORGANIZATION_GU
		,DistrictWide.ORGANIZATION_NAME
	FROM
		(
		SELECT 
			DISTINCT 1 AS HasDistrict
		FROM 
		    [rev].[REV_USER] AS [u] --select all from the user table
		    INNER JOIN
		    [rev].[REV_USER_USERGROUP] AS [uug] --join in their usergroup
		    ON
		    [u].[USER_GU]=[uug].[USER_GU]

		    INNER JOIN
		    [rev].[REV_USERGROUP_ORGANIZATION] AS [ugo] --get the usergroup gu
		    ON
		    [uug].[USERGROUP_GU]=[ugo].[USERGROUP_GU]

		    INNER JOIN
		    [rev].[REV_ORGANIZATION] AS [o] --join the usergroup gu to rev_organization for the organization name
		    ON
		    [ugo].[ORGANIZATION_GU]=[o].[ORGANIZATION_GU]


		WHERE
		    [u].[LOGIN_NAME]=@loginName --narrow it down to just the specified username
		    AND o.ORGANIZATION_GU = '8D749524-419B-4CB2-BEAE-134B947A853D'
		) AS HasDistrict

		LEFT JOIN
		(
		SELECT
			'%' AS ORGANIZATION_GU
			,'<District Wide>' AS ORGANIZATION_NAME
		) AS DistrictWide
		ON
		1 = 1
	) AS AllSchools
