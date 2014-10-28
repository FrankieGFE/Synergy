/**
 * $Revision: 181 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2014-10-02 07:50:52 -0600 (Thu, 02 Oct 2014) $
 */
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[ScheduleWithFutureAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.ScheduleWithFutureAsOf() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
 * FUNCTION APS.ScheduleWithFutureAsOf
 * Pulls current classes for kids as of a specific date
 * It looks a little complex because this function does not require you speciify a year/extension.
 * 
 * Tables Used: APS.BasicSchedule, EPC_CRS
 *
 * #param DATE @AsOfDate date to look for scheduled classes
 * 
 * #return TABLE basic schedule information on all current **OR FUTURE** enrolled classes as of a specific date
 */
ALTER FUNCTION APS.ScheduleWithFutureAsOf(@AsOfDate DATE)
RETURNS TABLE
AS
RETURN	
SELECT
	BasicSchedule.*
	,CourseMaster.COURSE_ID
	,CourseMaster.COURSE_TITLE
	,CourseMaster.CREDIT
	-- I am sure we will want to add more Course Level info here (Dual credit... etc.)
FROM
	APS.BasicSchedule
	INNER JOIN
	rev.EPC_CRS AS CourseMaster
	ON
	BasicSchedule.COURSE_GU = CourseMaster.COURSE_GU
WHERE	
	COALESCE(BasicSchedule.COURSE_LEAVE_DATE, @asOfDate) >= @asOfDate 
	