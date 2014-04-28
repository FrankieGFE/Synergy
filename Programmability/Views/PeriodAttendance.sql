/**
 * $LastChangedBy: e204042 
 * $LastChangedDate: 2014-04-28 
 *
 * This is the SchoolMessenger pull for Period Attendance.
 */

BEGIN TRAN
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SchoolMessenger].[PeriodAttendance]'))
	EXEC ('CREATE VIEW SchoolMessenger.PeriodAttendance AS SELECT 0 AS DUMMY')
GO

ALTER VIEW SchoolMessenger.PeriodAttendance AS
SELECT 
  TOP (100) PERCENT S.SIS_NUMBER            AS [STUDENT ID NUMBER]
, ECAR.ABBREVIATION                         AS [ABSENCE CODE]
, CONVERT(VARCHAR(10), ESAD.ABS_DATE, 101)  AS [ABSENCE DATE]
, ESAP.BELL_PERIOD                          AS [MISSING PERIOD]

FROM rev.EPC_STU_ATT_DAILY        AS ESAD 
LEFT JOIN rev.EPC_STU_ATT_PERIOD  AS ESAP   ON ESAP.DAILY_ATTEND_GU             = ESAD.DAILY_ATTEND_GU
JOIN rev.EPC_STU_ENROLL           AS ESE    ON ESE.ENROLLMENT_GU                = ESAD.ENROLLMENT_GU 
JOIN rev.EPC_STU_SCH_YR           AS SSY    ON SSY.STUDENT_SCHOOL_YEAR_GU       = ESE.STUDENT_SCHOOL_YEAR_GU 
                                               AND SSY.LEAVE_DATE IS NULL
                                               AND SSY.NO_SHOW_STUDENT = 'N'
                                               AND SSY.STATUS IS NULL
JOIN rev.REV_ORGANIZATION_YEAR    AS OY     ON OY.ORGANIZATION_YEAR_GU          = SSY.ORGANIZATION_YEAR_GU 
JOIN rev.REV_YEAR                 AS Y      ON Y.YEAR_GU                        = OY.YEAR_GU 
                                               AND Y.SCHOOL_YEAR = (SELECT SCHOOL_YEAR FROM rev.SIF_22_Common_CurrentYear) 
                                               AND Y.EXTENSION = 'R' -- Comment if Summer scools are also required
JOIN rev.EPC_STU                  AS S      ON S.STUDENT_GU = SSY.STUDENT_GU 
JOIN rev.EPC_CODE_ABS_REAS_SCH_YR AS ECARSY ON ECARSY.CODE_ABS_REAS_SCH_YEAR_GU = ESAP.CODE_ABS_REAS_GU 
                                               AND  ECARSY.ORGANIZATION_YEAR_GU = OY.ORGANIZATION_YEAR_GU 
JOIN rev.EPC_CODE_ABS_REAS        AS ECAR   ON ECAR.CODE_ABS_REAS_GU            = ECARSY.CODE_ABS_REAS_GU 
                                               --AND ECAR.DFLT_INCL_DIALER        = 'Y' -- Comment/uncomment this based on District setup

GO