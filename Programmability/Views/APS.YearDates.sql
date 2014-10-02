/**
 * $Revision$
 * $LastChangedBy$
 * $LastChangedDate$
 *
 *  This view calculates the min/max possible calendar dates for a year_gu 
 *  It is used in conjunction withorgyear when narrowing down where people should be searching for things
 *  on a given date or date range (like enrollments)
 *
 * This is really needed ast the "district" calendar is more of guidelines, and may be wrong (Synergy
 * allows for school calendars to be outside the district calendar)
 */

-- Drop view if it exists
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[APS].[YearDates]'))
	EXEC ('CREATE VIEW APS.YearDates AS SELECT 0 AS DUMMY')
GO

ALTER VIEW APS.YearDates AS
	SELECT
		OrgYear.YEAR_GU
		,MIN(CalendarOptions.START_DATE) AS START_DATE
		,MAX(CalendarOptions.END_DATE) AS END_DATE
	FROM
		rev.EPC_SCH_ATT_CAL_OPT AS CalendarOptions
		INNER JOIN
		REV.REV_ORGANIZATION_YEAR AS OrgYear
		ON
		CalendarOptions.ORG_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU
	GROUP BY
		OrgYear.YEAR_GU