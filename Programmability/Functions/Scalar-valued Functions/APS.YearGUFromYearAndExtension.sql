/**
 * $Revision: 270 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2014-11-04 10:01:32 -0700 (Tue, 04 Nov 2014) $
 */
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[YearGUFromYearAndExtension]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.YearGUFromYearAndExtension() RETURNS INT AS BEGIN RETURN -1 END')
GO

/**
 * FUNCTION APS.YearGUFromYearAndExtension
 * Returns Year GU given year and extension
 *
 * #param INT @Year 4 digit year qualifier
 * #param VARCHAR(1) @Extension 1 digit extension qualifiers (typically R or S)
 * 
 * #return UNIQUEIDENTIFIER Year GUID of qualified Year
 */
ALTER FUNCTION APS.YearGUFromYearAndExtension(@Year INT, @Extension VARCHAR(1))
RETURNS UNIQUEIDENTIFIER
AS
BEGIN
	DECLARE @TheReturn UNIQUEIDENTIFIER

	SELECT
		@TheReturn = YEAR_GU
	FROM
		rev.REV_YEAR
	WHERE
		SCHOOL_YEAR = @Year
		AND EXTENSION = @Extension

	RETURN @TheReturn

END -- END Function