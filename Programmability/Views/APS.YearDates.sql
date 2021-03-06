/**
 * $Revision: 1104 $
 * $LastChangedBy: e104090 $
 * $LastChangedDate: 2016-05-31 17:34:00 -0600 (Tue, 31 May 2016) $
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
		,EXTENSION
		,MIN(CalendarOptions.START_DATE) AS START_DATE
		,MAX(CalendarOptions.END_DATE) AS END_DATE
	FROM
		rev.EPC_SCH_ATT_CAL_OPT AS CalendarOptions
		INNER JOIN
		REV.REV_ORGANIZATION_YEAR AS OrgYear
		ON
		CalendarOptions.ORG_YEAR_GU = OrgYear.ORGANIZATION_YEAR_GU

		INNER JOIN 
		rev.REV_YEAR AS YEARS
		ON
		OrgYear.YEAR_GU = YEARS.YEAR_GU
	WHERE
		-- Exclude Child Find and Early Childhood
		OrgYear.ORGANIZATION_GU != '02D7B4ED-495A-4617-83FD-834AF27BDD15'
	GROUP BY
		OrgYear.YEAR_GU
		,EXTENSION