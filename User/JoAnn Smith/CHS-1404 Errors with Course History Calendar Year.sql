declare @SchoolYearGu uniqueidentifier = 'A3F9F1FB-4706-49AA-B3A3-21F153966191'
declare @CourseHistoryYear nvarchar(4) = '2017'
declare @CalendarYear nvarchar(4) = '2016'
declare @CalendarMonth nvarchar(2) = '12'
SELECT 
CASE WHEN NON.SCHOOL_NON_DISTRICT_GU IS NOT NULL THEN NON.NAME ELSE ORGANIZATION_NAME END AS SCHOOL_NAME
,ENROLL.SCHOOL_NAME AS MOST_RECENT_PRIMARY_SCHOOL_2017
,STU.SIS_NUMBER
,HIST.CALENDAR_YEAR
,HIST.SCHOOL_YEAR
,HIST.CALENDAR_MONTH
,HIST.COURSE_ID
,HIST.COURSE_TITLE
,HIST.SECTION_ID
,HIST.MARK
,HIST.CREDIT_COMPLETED
,hist.STU_COURSE_HISTORY_GU


 FROM 
REV.EPC_STU_CRS_HIS AS HIST
LEFT HASH JOIN 
REV.REV_ORGANIZATION AS ORG
ON
HIST.SCHOOL_IN_DISTRICT_GU = ORG.ORGANIZATION_GU
LEFT HASH JOIN 
REV.EPC_SCH AS SCH
ON
SCH.ORGANIZATION_GU = ORG.ORGANIZATION_GU

LEFT HASH JOIN 
REV.EPC_SCH_NON_DST AS NON
ON
NON.SCHOOL_NON_DISTRICT_GU = HIST.SCHOOL_NON_DISTRICT_GU
INNER HASH JOIN 
REV.EPC_STU AS STU
ON
HIST.STUDENT_GU = STU.STUDENT_GU

LEFT HASH JOIN 
APS.LatestPrimaryEnrollmentInYear (@SchoolYearGu) AS ENROLL
ON
ENROLL.STUDENT_GU = STU.STUDENT_GU


WHERE
HIST.SCHOOL_YEAR = @CourseHistoryYear AND CALENDAR_YEAR = @CalendarYear AND CALENDAR_MONTH = @CalendarMonth

ORDER BY ORG.ORGANIZATION_NAME, ENROLL.STUDENT_GU