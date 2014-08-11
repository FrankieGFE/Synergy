/**
 * $Revision: 20 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2012-10-01 12:06:39 -0600 (Mon, 01 Oct 2012) $
 */
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[DistrictMemberDayFromDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.DistrictMemberDayFromDate() RETURNS INT AS BEGIN RETURN -1 END')
GO

/**
 * FUNCTION APS.DistrictMemberDayFromDate
 * Pulls member day (e.g. 1 for 1st day of school) given a district and date
 * dates not having a member day (e.g. Saturdays) will return the last member day applicable.)
 *
 * Tables Used: EPC_ATT_CAL_TYPE, EPC_ATT_CAL_OPT, REV_YEAR, EPC_ATT_CAL
 *
 * #param NUMERIC @SchoolYear Synergy Year of pull (2014 for 14-15)
 * #param NVARCHAR(1) @Extension one letter denoting year extention (most commonly R or S)
 * #param DATETIME @onDate Date to check for member day
 * 
 * #return INT member day of date (e.g. 30 for 30th day)
 */
ALTER FUNCTION APS.DistrictMemberDayFromDate(@SchoolYear NUMERIC, @Extension NVARCHAR(1), @onDate DATE)
RETURNS INT
AS
BEGIN
	DECLARE @FirstDay DATE
	DECLARE @CalTypeGu  UNIQUEIDENTIFIER
	DECLARE @NumNonDays INT

	-- Grabing first day and CalTypeGu
	SELECT
		@FirstDay = DistrictCalType.START_DATE
		,@CalTypeGu = DistrictCalType.ATT_CAL_TYPE_GU
	FROM
		rev.EPC_ATT_CAL_TYPE AS DistrictCalType
		INNER JOIN 
		rev.EPC_ATT_CAL_OPT AS DistrictCalOption
		ON
		DistrictCalType.ATT_CAL_OPT_GU = DistrictCalOption.ATT_CAL_OPT_GU
	
		RIGHT JOIN
		rev.REV_YEAR AS SynYear
		ON
		DistrictCalOption.YEAR_GU = SynYear.YEAR_GU
	WHERE
		SynYear.SCHOOL_YEAR = @SchoolYear
		AND SynYear.EXTENSION = @Extension

	-- grab number of non-counted days (holidays)
	SELECT
		@NumNonDays = COUNT(*)
	FROM
		rev.EPC_ATT_CAL
	WHERE
		ATT_CAL_TYPE_GU = @CalTypeGu
		AND
		CAL_DATE BETWEEN @FirstDay AND @OnDate
		AND HOLIDAY IN ('Hol')

	-- caluculate and return the number
	RETURN
	   (DATEDIFF(dd, @FirstDay, @OnDate) + 1) -- Number of days difference between 2 dates (start date and day looked up)
	  -(DATEDIFF(wk, @FirstDay, @OnDate) * 2) -- Number of weeks difference (*2) - removes weekends
	  -(CASE WHEN DATENAME(dw, @OnDate) = 'Saturday' THEN 1 ELSE 0 END) -- subtract one if the end day is on a (weekend) Not sure what we want to do hear
	  - @NumNonDays -- number of holidays
		
END