/**
 * $Revision$
 * $LastChangedBy$
 * $LastChangedDate$
 */
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[ScheduleAsOf]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.ScheduleAsOf() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
 * FUNCTION APS.ScheduleAsOf
 * Pulls current classes for kids as of a specific date
 * It looks a little complex because this function does not require you speciify a year/extension.
 * 
 * Tables Used: APS.BasicSchedule, EPC_CRS
 *
 * #param DATE @AsOfDate date to look for scheduled classes
 * 
 * #return TABLE basic schedule information on all currently enrolled classes on that specific date
 */
ALTER FUNCTION APS.ScheduleAsOf(@AsOfDate DATE)
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
	@asOfDate BETWEEN BasicSchedule.COURSE_ENTER_DATE AND COALESCE(BasicSchedule.COURSE_LEAVE_DATE, @asOfDate)