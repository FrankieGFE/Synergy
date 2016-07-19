/*
	Created by Debbie Ann Chavez (ORIGINAL CODE FROM MLM/EDUPOINT)
	Date 7/18/2016
*/


ALTER VIEW APS.CleverTeachers AS

SELECT DISTINCT
         sch.SCHOOL_CODE          AS [School_id]
       , stf.BADGE_NUM            AS [Teacher_id]
       , stf.BADGE_NUM            AS [Teacher_number]
       , stf.STATE_ID             AS [State_teacher_id]
       , stfp.LAST_NAME           AS [Last_name]
       , stfp.MIDDLE_NAME         AS [Middle_name]
       , LEFT(stfp.FIRST_NAME,1)  AS [First_name]
       , stfp.EMAIL               AS [Teacher_email]
       , stfp.TITLE               AS [Title]
       , ''                       AS [Username]
       , ''                       AS [password]

FROM   rev.EPC_SCH_YR_SECT            sect 
       JOIN rev.EPC_SCH_YR_CRS        scrs ON scrs.SCHOOL_YEAR_COURSE_GU = sect.SCHOOL_YEAR_COURSE_GU
	   JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU   = scrs.ORGANIZATION_YEAR_GU
                                              and oyr.YEAR_GU            = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
	   JOIN rev.EPC_STAFF_SCH_YR      stfy ON stfy.STAFF_SCHOOL_YEAR_GU  = sect.STAFF_SCHOOL_YEAR_GU
	   JOIN rev.EPC_STAFF             stf  ON stf.STAFF_GU               = stfy.STAFF_GU
       JOIN rev.REV_PERSON            stfp ON stfp.PERSON_GU             = stfy.STAFF_GU
--ORDER BY stf.BADGE_NUM