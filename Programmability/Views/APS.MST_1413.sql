/*
	Created by Frank Garcia (ORIGINAL CODE FROM MLM/EDUPOINT)
	Date 9/30/2016

Frank � below is another SSRS report request from Patti to create a version of the MST-1411 that includes all sections
 in a school�s master schedule and all section tags attached to any section.  
 Please work on developing this version for her using the current MST-1411 as a basis and you can name 
 the new one MST-1413 School Master Schedule with STARS number, zero sections and tags.  
 Let me know if you�d like to meet to go over and we can include Debbie to help guide us.  
 Thanks- Andy
*/

ALTER VIEW
APS.MST_1413
AS

SELECT
	SCHOOL_NAME
	,SCHOOL_YEAR
	,TERM_CODE
	,TOTAL_FEMALE + TOTAL_MALE AS STUDENT_COUNT
	,MAX_STUDENTS
	,COURSE_TITLE
	,COURSE_ID
	,SECTION_ID
	,TAG
	,ROOM_SIMPLE
	,MEETING_DAYS
	,STAFF_NAME
	,BADGE_NUM
	,STATE_COURSE_CODE
	,ORGANIZATION_GU
FROM
(
SELECT
	ORG.[ORGANIZATION_NAME] AS [SCHOOL_NAME]
	,YR.SCHOOL_YEAR
	,SECT.TERM_CODE
	,TOTAL_FEMALE + TOTAL_MALE AS STUDENT_COUNT
	,CASE WHEN TOTAL_FEMALE IS NULL THEN 0 ELSE TOTAL_FEMALE END AS TOTAL_FEMALE
	,CASE WHEN TOTAL_MALE IS NULL THEN 0 ELSE TOTAL_MALE END AS TOTAL_MALE
	,SECT.MAX_STUDENTS
	,CRSE.COURSE_TITLE AS COURSE_TITLE
	,CRSE.COURSE_ID AS COURSE_ID
	,SECT.SECTION_ID
	,SECT.ROOM_SIMPLE
	,SECT.PERIOD_BEGIN
	,SECT.PERIOD_END
	, STUFF((SELECT ','+ left(symd.MEET_DAY_CODE,1)
	         FROM rev.EPC_SCH_YR_SECT        sec 	
	         JOIN rev.EPC_SCH_YR_SECT_MET_DY sysmd ON sysmd.SECTION_GU      = sec.SECTION_GU
	         JOIN rev.EPC_SCH_YR_MET_DY      symd  ON symd.SCH_YR_MET_DY_GU = sysmd.SCH_YR_MET_DY_GU
	       WHERE sec.SECTION_GU  = sect.SECTION_GU	
	       ORDER BY symd.ORDERBY	
	       FOR XML PATH('')
	     ),1,1,'') AS [MEETING_DAYS]
	,PER.FIRST_NAME + ' ' + PER.LAST_NAME AS STAFF_NAME
	,STAF.BADGE_NUM AS BADGE_NUM
	,CRSE.STATE_COURSE_CODE AS STATE_COURSE_CODE
	,CASE WHEN TAG.TAG IS NULL THEN '' ELSE TAG.TAG END AS TAG
	,ORG.ORGANIZATION_GU
FROM
rev.EPC_SCH_YR_SECT as sect
JOIN
REV.EPC_SCH_YR_CRS AS CRS
ON SECT.SCHOOL_YEAR_COURSE_GU = CRS.SCHOOL_YEAR_COURSE_GU

JOIN
REV.EPC_CRS AS CRSE
ON CRSE.COURSE_GU = CRS.COURSE_GU

JOIN
REV.REV_ORGANIZATION_YEAR AS ORGY
ON ORGY.ORGANIZATION_YEAR_GU = CRS.ORGANIZATION_YEAR_GU

JOIN 
REV.REV_ORGANIZATION AS ORG
ON ORG.ORGANIZATION_GU = ORGY.ORGANIZATION_GU

LEFT OUTER JOIN 
REV.EPC_STAFF_SCH_YR AS STY
ON STY.STAFF_SCHOOL_YEAR_GU = SECT.STAFF_SCHOOL_YEAR_GU

JOIN
REV.EPC_STAFF STAF
ON STAF.STAFF_GU = STY.STAFF_GU

JOIN
REV.REV_PERSON AS PER
ON PER.PERSON_GU = STY.STAFF_GU

JOIN
REV.REV_YEAR AS YR
ON YR.YEAR_GU = ORGY.YEAR_GU

LEFT JOIN
REV.UD_SECTION_TAG AS TAG
ON TAG.SECTION_GU = SECT.SECTION_GU


WHERE 1 = 1
	--AND ORG.[ORGANIZATION_GU] LIKE @School
	--AND [TERM_CODE] LIKE @TermCode
AND YR.SCHOOL_YEAR = (SELECT * FROM rev.SIF_22_Common_CurrentYear)
--AND SECTION_ID IN ('E711','E712')
) AS MST_1413
--ORDER BY SCHOOL_NAME







----select (TOTAL_FEMALE + TOTAL_MALE) as TOTAL_STUDENTS,* from
--SELECT * FROM
--rev.EPC_SCH_YR_CRS as crs
--left join 
--rev.EPC_SCH_YR_SECT as sect
--on crs.COURSE_GU = sect.SCHOOL_YEAR_COURSE_GU
--AND CRS.ORGANIZATION_YEAR_GU = SECT.ORGANIZATION_YEAR_GU