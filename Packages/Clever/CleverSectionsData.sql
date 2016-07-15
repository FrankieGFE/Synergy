-- =================================================================
-- Author     :	mlm - EduPoint                                    --
-- Create date: 12/17/2015                                        --
-- Description:	Clever – Sections Data Extract - sections.csv     --
-- Revision   :                                                   --
-- =================================================================

SELECT
         sch.SCHOOL_CODE                                  AS [School_id]
       , sch.SCHOOL_CODE+'_'+sect.SECTION_ID              AS [Section_id]
       , stf.BADGE_NUM                                    AS [Teacher_id]
       , crs.COURSE_TITLE + ' - ' +
	     sch.SCHOOL_CODE  + '_' +
		 sect.SECTION_ID  + ' - ' +
		 'Period:' + CAST(sect.PERIOD_BEGIN as char(3))   AS [Name]
      , CASE
	       --WHEN grd.VALUE_DESCRIPTION in ('P3', 'P4', '5C', '8C') THEN 'Prekindergarten'
		   WHEN grd.VALUE_DESCRIPTION = 'P1'                      THEN 'P1'
		   WHEN grd.VALUE_DESCRIPTION = 'P2'                      THEN 'P2'
		   WHEN grd.VALUE_DESCRIPTION = 'PK'                      THEN 'PK'
	       WHEN grd.VALUE_DESCRIPTION = 'K'                       THEN 'K'
	       --WHEN grd.VALUE_DESCRIPTION in ('PG', 'Grad', '12+')    THEN 'Postgraduate'
		   WHEN grd.VALUE_DESCRIPTION = '01'                      THEN '1'
		   WHEN grd.VALUE_DESCRIPTION = '02'                      THEN '2'
		   WHEN grd.VALUE_DESCRIPTION = '03'                      THEN '3'
		   WHEN grd.VALUE_DESCRIPTION = '04'                      THEN '4'
		   WHEN grd.VALUE_DESCRIPTION = '05'                      THEN '5'
		   WHEN grd.VALUE_DESCRIPTION = '06'                      THEN '6'
		   WHEN grd.VALUE_DESCRIPTION = '07'                      THEN '7'
		   WHEN grd.VALUE_DESCRIPTION = '08'                      THEN '8'
		   WHEN grd.VALUE_DESCRIPTION = '09'                      THEN '9'
		   ELSE grd.VALUE_DESCRIPTION
		  END                                             AS [Grade]
       , crs.COURSE_TITLE                                 AS [Course_name]
       , crs.COURSE_ID                                    AS [Course_number]
       , sect.PERIOD_BEGIN                                AS [Period]
       , dept.VALUE_DESCRIPTION                           AS [Subject]
       , sect.TERM_CODE                                   AS [Term_name]
	   --, CONVERT(VARCHAR(10), trms.TermStart, 101)        AS [Term_start]
	   --, CONVERT(VARCHAR(10), trms.TermEnd, 101)          AS [Term_end] 
FROM   rev.EPC_SCH_YR_SECT            sect 
       JOIN rev.EPC_SCH_YR_CRS        scrs ON scrs.SCHOOL_YEAR_COURSE_GU = sect.SCHOOL_YEAR_COURSE_GU
	   JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU   = scrs.ORGANIZATION_YEAR_GU
                                              and oyr.YEAR_GU            = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
       JOIN rev.EPC_CRS               crs  ON crs.COURSE_GU              = scrs.COURSE_GU
	   JOIN rev.EPC_STAFF_SCH_YR      stfy ON stfy.STAFF_SCHOOL_YEAR_GU  = sect.STAFF_SCHOOL_YEAR_GU
	   JOIN rev.EPC_STAFF             stf  ON stf.STAFF_GU               = stfy.STAFF_GU
       JOIN rev.REV_PERSON            stfp ON stfp.PERSON_GU             = stfy.STAFF_GU
	   --JOIN ##Terms                   trms ON trms.OrgGu                 = oyr.ORGANIZATION_GU
	   --                                       AND trms.TermCode          = sect.TERM_CODE
       LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd on grd.VALUE_CODE = sect.GRADE_RANGE_LOW
	   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12,CourseInfo', 'Department') dept on dept.VALUE_CODE = crs.DEPARTMENT