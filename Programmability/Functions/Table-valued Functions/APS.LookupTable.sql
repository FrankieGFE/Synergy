/**
 * $Revision: 19 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2012-09-27 08:34:31 -0600 (Thu, 27 Sep 2012) $
 */
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[LookupTable]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.LookupTable() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
 * FUNCTION APS.LookupTable
 * pulls values for a specified lookup table.  This differs from the Edupoint SIF standard as
 * it retrieves more inofrmation (such as list information)
 *
 * Tables Used: REV_BOD_LOOKUP_DEF, REV_BOD_LOOKUP_VALUES
 *
 * #param nvarchar(50) @namespace lookup namespace (e.g. 'k12')
 * #param nvarchar(50) @lookupname lookup name (e.g. 'enter_code')
 * 
 * #return TABLE All value fields (see REV_BOD_LOOKUP_VALUES clomuns) for the lookup table.
 */
ALTER FUNCTION APS.LookupTable(@namespace nvarchar(50), @lookupname nvarchar(50))
RETURNS TABLE
AS
RETURN
	SELECT
		LookupValues.*
	FROM
		rev.REV_BOD_LOOKUP_DEF AS LookupDef
		INNER JOIN
		rev.REV_BOD_LOOKUP_VALUES As LookupValues
		ON
		LookupDef.LOOKUP_DEF_GU = LookupValues.LOOKUP_DEF_GU
	WHERE
		LookupDef.LOOKUP_NAMESPACE = @namespace
		AND LookupDef.LOOKUP_DEF_CODE = @lookupname