/**
 * $Revision: 270 $
 * $LastChangedBy: e201594 $
 * $LastChangedDate: 2014-11-04 10:01:32 -0700 (Tue, 04 Nov 2014) $
 */
 
-- Removing function if it exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[APS].[ScheduleForYear]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	EXEC('CREATE FUNCTION APS.ScheduleForYear() RETURNS TABLE AS RETURN (SELECT 0 AS DUMMY)')
GO

/**
 * FUNCTION APS.ScheduleForYear
 * Pulls current classes for kids as of a specific date
 * It looks a little complex because this function does not require you speciify a year/extension.
 * 
 * Tables Used: APS.BasicSchedule, EPC_CRS
 *
 * #param DATE @YearGu Year to grab shedules for
 * 
 * #return TABLE basic schedule information on all currently enrolled classes on that specific date
 */
ALTER FUNCTION APS.ScheduleForYear(@YearGu UNIQUEIDENTIFIER)
RETURNS TABLE
AS
RETURN	
SELECT
	BasicSchedule.*
	,CourseMaster.COURSE_ID
	,CourseMaster.COURSE_TITLE
	,CourseMaster.CREDIT
	-- I am sure we will want to add more Course Level info here (Dual credit... etc.)
	,CourseMaster.DEPARTMENT
	,CourseMaster.GRADE_RANGE_LOW
	,CourseMaster.GRADE_RANGE_HIGH
	,CourseMaster.COURSE_HISTORY_TYPE
	,CourseMaster.ACADEMIC_TYPE
	,CourseMaster.SUBJECT_AREA_1
	,CourseMaster.SUBJECT_AREA_2
	,CourseMaster.SUBJECT_AREA_3
	,CourseMaster.SUBJECT_AREA_4
	,CourseMaster.SUBJECT_AREA_5
	,CourseMaster.PROGRAM_3Y
	,CourseMaster.PROGRAM_4Y
	,CourseMaster.ONLINE_COURSE
	,CourseMaster.DISTANCE_LEARNING
	,CourseMaster.AP_INDICATOR
	,CourseMaster.COURSE_DURATION

FROM
	APS.BasicSchedule
	INNER JOIN
	rev.EPC_CRS AS CourseMaster
	ON
	BasicSchedule.COURSE_GU = CourseMaster.COURSE_GU
WHERE
	BasicSchedule.YEAR_GU = @YearGu