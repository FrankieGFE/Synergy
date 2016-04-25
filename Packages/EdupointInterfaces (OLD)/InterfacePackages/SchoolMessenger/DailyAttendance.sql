--<APS - School Messenger >
-- *Daily Attendance data view*
--** TODO ** -- Include filters for attendance codes that need to be exposed to SchoolMessenger

--  CREATE VIEW [SchoolMessenger].[DailyAttendance] AS

SELECT 
  TOP (100) PERCENT S.SIS_NUMBER            AS [STUDENT ID NUMBER]
, ECAR.ABBREVIATION                         AS [ABSENCE CODE]
, CONVERT(VARCHAR(10) , ESAD.ABS_DATE, 101) AS [ABSENCE DATE]

FROM rev.EPC_STU_ATT_DAILY        AS ESAD 
LEFT JOIN rev.EPC_STU_ENROLL      AS ESE    ON ESE.ENROLLMENT_GU                   = ESAD.ENROLLMENT_GU 
JOIN rev.EPC_STU_SCH_YR           AS SSY    ON SSY.STUDENT_SCHOOL_YEAR_GU          = ESE.STUDENT_SCHOOL_YEAR_GU 
                                               AND SSY.LEAVE_DATE IS NULL
                                               AND SSY.NO_SHOW_STUDENT = 'N'
                                               AND SSY.STATUS IS NULL
JOIN rev.REV_ORGANIZATION_YEAR    AS OY     ON OY.ORGANIZATION_YEAR_GU             = SSY.ORGANIZATION_YEAR_GU 
JOIN rev.REV_YEAR                 AS Y      ON Y.YEAR_GU                           = OY.YEAR_GU 
                                               AND Y.SCHOOL_YEAR                   = (SELECT SCHOOL_YEAR FROM rev.SIF_22_Common_CurrentYear)
                                               --AND Y.EXTENSION                     = 'R' -- Comment if Summer scools are also required
JOIN rev.EPC_STU                  AS S      ON S.STUDENT_GU                        = SSY.STUDENT_GU 
JOIN rev.EPC_CODE_ABS_REAS_SCH_YR AS ECARSY ON ECARSY.CODE_ABS_REAS_SCH_YEAR_GU    = ESAD.CODE_ABS_REAS1_GU 
                                               OR ECARSY.CODE_ABS_REAS_SCH_YEAR_GU = ESAD.CODE_ABS_REAS2_GU
                                               AND ECARSY.ORGANIZATION_YEAR_GU     = OY.ORGANIZATION_YEAR_GU 
JOIN rev.EPC_CODE_ABS_REAS        AS ECAR   ON ECARSY.CODE_ABS_REAS_GU             = ECAR.CODE_ABS_REAS_GU 
                                               --AND ECAR.DFLT_INCL_DIALER           = 'Y' -- Comment/uncomment this based on District setup
