/**
 * $LastChangedBy: e204042 
 * $LastChangedDate: 2014-07-25 
 *
 * This function returns a table with a list of all the Organization Year GUs given an extract name.
 * The pull is based on the UD_EXTRACTS table, then pulls REV_YEAR and REV_ORGANIZATION_YEAR
 * for a list of the schools in a YEAR_GU.
 */

-- Removing function if it exists
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[OrganizationsFromExtracts]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION APS.OrganizationsFromExtracts
GO
/**

 */
CREATE FUNCTION APS.OrganizationsFromExtracts(@extractName VARCHAR(1024))
    RETURNS @List TABLE (OrganizationYearGU VARCHAR(1024), [SCHOOL_YEAR] INT, EXTENSION VARCHAR(1))

AS
BEGIN
    --Year variables, depending on the selection of the Extract. Can be CurrentYear, CurrentYear-1,CurrentYear+1
    DECLARE @CurrentYear INT=(SELECT SCHOOL_YEAR FROM rev.SIF_22_Common_CurrentYear)
    DECLARE @CurrentYear1 INT=(SELECT SCHOOL_YEAR-1 FROM rev.SIF_22_Common_CurrentYear)
    DECLARE @CurrentYear2 INT=(SELECT SCHOOL_YEAR+1 FROM rev.SIF_22_Common_CurrentYear)

    INSERT INTO
	   @List

	   SELECT
		  [Years].[ORGANIZATION_YEAR_GU] --the school GU for the year
		  ,[Years].[SCHOOL_YEAR]         --the school year
		  ,[Years].[EXTENSION]           --the extension

	   FROM
	   [rev].[UD_EXTRACTS] AS [E] --the UD_EXTRACTS table in Synergy.

		  INNER JOIN --join it with REV_ORGANIZATION_YEAR and REV_YEAR based on the SCHOOL_YEAR specified.
		  (
			 SELECT
				[OY].[ORGANIZATION_YEAR_GU]
				,[OY].[ORGANIZATION_GU]
				,[Y].[SCHOOL_YEAR]
				,[Y].[EXTENSION]
			 FROM
				[rev].[REV_ORGANIZATION_YEAR] AS [OY]
    
				INNER JOIN
				[rev].[REV_YEAR] AS [Y]

				ON
				[OY].[YEAR_GU]=[Y].[YEAR_GU]

		  ) AS [Years]

		  ON
		  ([Years].[EXTENSION] LIKE
			 CASE
				WHEN [E].[SUMMER_SCHOOL]='Y' AND [E].[REGULAR]='Y' THEN '[RS]' --Both summer and regular school year
				WHEN [E].[SUMMER_SCHOOL]='Y' AND [E].[REGULAR]='N' THEN '[S]'  --Just summer school
				WHEN [E].[SUMMER_SCHOOL]='N' AND [E].[REGULAR]='Y' THEN '[R]'  --Just Regular school year
				WHEN [E].[SUMMER_SCHOOL]='N' AND [E].[REGULAR]='N' THEN ''     --what's the point then?!
			 END)
		  AND
		  CASE --this picks the year to use for the extract.
			 WHEN [E].[SCHOOL_YEAR]='CY' THEN @CurrentYear   --the current school year.
			 WHEN [E].[SCHOOL_YEAR]='CY1' THEN @CurrentYear1 --current school year - 1
			 WHEN [E].[SCHOOL_YEAR]='CY2' THEN @CurrentYear2 --current school year + 1
			 ELSE [E].[SCHOOL_YEAR]
		  END
		  =[Years].[SCHOOL_YEAR]

	   WHERE
	   [E].[EXTRACT_NAME]=@extractName --only get the results for the extract specified.

    RETURN
END
GO