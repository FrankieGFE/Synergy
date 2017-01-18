/**
 * $Revision: 181 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2014-10-02 07:50:52 -0600 (Thu, 02 Oct 2014) $
 */
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[SchoolMemberDayFromDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.SchoolMemberDayFromDate() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
 * FUNCTION APS.SchoolMemberDayFromDate
 * Pulls member day (e.g. 1 for 1st day of school) given a school (orgYear) and date
 * dates not having a member day (e.g. Saturdays) will return the last member day applicable.)
 *
 * Tables Used: EPC_SCH_ATT_CAL_OPT, 
 *
 * #param DATE @onDate Date to check for member day
 * 
 * #return TABLE of OrgYearGUs and the member day for the given date
 * If passed day is after last day of school, record returns 0
 */
ALTER FUNCTION APS.SchoolMemberDayFromDate(@onDate DATE)
RETURNS TABLE
AS
RETURN
SELECT
	ORG_YEAR_GU
	,
	CASE 
		-- if the passed date is large than the last day, then return zero as invalid
		WHEN END_DATE < @onDate THEN 0
		-- else we calculate the difference between the passed date and the first day an each orgYear
		-- stripping out weekends and holidays
		ELSE
			(DATEDIFF(dd, START_DATE, @OnDate) + 1) -- Number of days difference between 2 dates (start date and day looked up)
			-(DATEDIFF(wk, START_DATE, @OnDate) * 2) -- Number of weeks difference (*2) - removes weekends
			-(CASE WHEN DATENAME(dw, @OnDate) = 'Saturday' THEN 1 ELSE 0 END) -- subtract one if the end day is on a (weekend) Not sure what we want to do hear
			- NumNonDays -- number of holidays	
	END
	AS MemberDay	
FROM
	-- this subselect gives you first and last day of calendar along with number of holidays before passed date
	(
	SELECT
		CalOption.ORG_YEAR_GU
		,MIN(CalOption.START_DATE) AS START_DATE
		,MAX(CalOption.END_DATE) AS END_DATE
		,COUNT(*) * CASE WHEN SchoolCal.SCHOOL_YEAR_GU IS NULL THEN 0 ELSE 1 END AS NumNonDays
	FROM
		REV.EPC_SCH_ATT_CAL_OPT AS CalOption

		LEFT JOIN
		REV.EPC_SCH_ATT_CAL AS SchoolCal
		ON
		SchoolCal.SCHOOL_YEAR_GU = CalOption.ORG_YEAR_GU
		AND SchoolCal.HOLIDAY IN ('Hol')
		AND CAL_DATE <= @onDate
	GROUP BY
		CalOption.ORG_YEAR_GU
		-- used to identify calendars with no holidays between start and passed date
		,CASE WHEN SchoolCal.SCHOOL_YEAR_GU IS NULL THEN 0 ELSE 1 END
	)NumDays