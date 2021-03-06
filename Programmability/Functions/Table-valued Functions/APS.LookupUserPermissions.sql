/**
 * $LastChangedBy: Don Jarrett 
 * $LastChangedDate: 2014-09-04
 *
 * This function takes in a login name and returns
 * all the school's ORGANIZATION_GUs that the user
 * can access. If a user has District wide access,
 * a % for every school and then all the schools is returned.
 */

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[LookupUserPermissions]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.LookupUserPermissions() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

ALTER FUNCTION APS.LookupUserPermissions(@loginName VARCHAR(255))
RETURNS TABLE
AS
RETURN	
SELECT
	*
FROM
	(
	SELECT
		DISTINCT
	    CAST([Organization].ORGANIZATION_GU AS VARCHAR(128)) AS ORGANIZATION_GU
	    ,[Organization].ORGANIZATION_NAME
	FROM 
	    [rev].[REV_USER] AS [Users] --select all from the user table
	    INNER JOIN
	    [rev].[REV_USER_USERGROUP] AS [UserUserGroup] --join in their usergroup
	    ON
	    [Users].[USER_GU]=[UserUserGroup].[USER_GU]

	    INNER JOIN
	    [rev].[REV_USERGROUP_ORGANIZATION] AS [UsergroupOrganization] --get the usergroup gu
	    ON
	    [UserUserGroup].[USERGROUP_GU]=[UsergroupOrganization].[USERGROUP_GU]

	    INNER JOIN
	    [rev].[REV_ORGANIZATION] AS [Organization] --join the usergroup gu to rev_organization for the organization name
	    ON
	    [UsergroupOrganization].[ORGANIZATION_GU]=[Organization].[ORGANIZATION_GU]

	WHERE
	    [Users].[LOGIN_NAME]=@loginName --narrow it down to just the specified username
	    AND [Organization].ORGANIZATION_GU != '8D749524-419B-4CB2-BEAE-134B947A853D' --we don't want the district wide organization gu, instead we want a wildcard representing all(%).

	UNION

	SELECT
		CAST([Organization].ORGANIZATION_GU AS VARCHAR(128))
		,[Organization].ORGANIZATION_NAME
	FROM
		(
		SELECT 
			DISTINCT 1 AS HasDistrict
		FROM 
		    [rev].[REV_USER] AS [Users] --select all from the user table
		    INNER JOIN
		    [rev].[REV_USER_USERGROUP] AS [UserUserGroup] --join in their usergroup
		    ON
		    [Users].[USER_GU]=[UserUserGroup].[USER_GU]

		    INNER JOIN
		    [rev].[REV_USERGROUP_ORGANIZATION] AS [UsergroupOrganization] --get the usergroup gu
		    ON
		    [UserUserGroup].[USERGROUP_GU]=[UsergroupOrganization].[USERGROUP_GU]

		    INNER JOIN
		    [rev].[REV_ORGANIZATION] AS [Organization] --join the usergroup gu to rev_organization for the organization name
		    ON
		    [UsergroupOrganization].[ORGANIZATION_GU]=[Organization].[ORGANIZATION_GU]


		WHERE
		    [Users].[LOGIN_NAME]=@loginName --narrow it down to just the specified username
		    AND [Organization].ORGANIZATION_GU = '8D749524-419B-4CB2-BEAE-134B947A853D' --we only want a result if they have district wide access.
		) AS HasDistrict

		LEFT JOIN
		rev.REV_ORGANIZATION AS [Organization]
		ON
		[Organization].ORGANIZATION_NAME NOT LIKE 'ZZ %' --these are schools we don't want.
		AND [Organization].IS_LEAF = 'Y' --eliminate district wide and a few more.

	UNION

	SELECT --join one more time if they need the district wide wildcard
		DistrictWide.ORGANIZATION_GU
		,DistrictWide.ORGANIZATION_NAME
	FROM
		(
		SELECT 
			DISTINCT 1 AS HasDistrict
		FROM 
		    [rev].[REV_USER] AS [Users] --select all from the user table
		    INNER JOIN
		    [rev].[REV_USER_USERGROUP] AS [UserUserGroup] --join in their usergroup
		    ON
		    [Users].[USER_GU]=[UserUserGroup].[USER_GU]

		    INNER JOIN
		    [rev].[REV_USERGROUP_ORGANIZATION] AS [UsergroupOrganization] --get the usergroup gu
		    ON
		    [UserUserGroup].[USERGROUP_GU]=[UsergroupOrganization].[USERGROUP_GU]

		    INNER JOIN
		    [rev].[REV_ORGANIZATION] AS [Organization] --join the usergroup gu to rev_organization for the organization name
		    ON
		    [UsergroupOrganization].[ORGANIZATION_GU]=[Organization].[ORGANIZATION_GU]


		WHERE
		    [Users].[LOGIN_NAME]=@loginName --narrow it down to just the specified username
		    AND [Organization].ORGANIZATION_GU = '8D749524-419B-4CB2-BEAE-134B947A853D' --we will be returning the district wide wildcard
		) AS HasDistrict

		LEFT JOIN
		(
		SELECT
			'%' AS ORGANIZATION_GU
			,'<District Wide>' AS ORGANIZATION_NAME
		) AS DistrictWide
		ON
		1 = 1 --give us any record that exists.
	) AS AllSchools
