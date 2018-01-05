--<APS - SchoolNet section_result  data>
; with GradeMark AS
(
   SELECT 
            stu.student_gu
          , sect.TERM_CODE
		  , sect.SECTION_ID
		  , crs.COURSE_ID
		  , stf.BADGE_NUM
		  , mk.MARK
   FROM   rev.EPC_STU                        stu
          JOIN rev.EPC_STU_SCH_YR            ssy  ON ssy.STUDENT_GU                    = stu.STUDENT_GU
          JOIN rev.REV_ORGANIZATION_YEAR     oyr  ON oyr.ORGANIZATION_YEAR_GU          = ssy.ORGANIZATION_YEAR_GU
                                                     and oyr.YEAR_GU                   = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
          JOIN rev.EPC_STU_CLASS             cls  ON cls.STUDENT_SCHOOL_YEAR_GU        = ssy.STUDENT_SCHOOL_YEAR_GU
	      JOIN rev.EPC_SCH_YR_SECT           sect ON sect.SECTION_GU                   = cls.SECTION_GU
	      JOIN rev.EPC_SCH_YR_CRS            ycrs ON ycrs.SCHOOL_YEAR_COURSE_GU        = sect.SCHOOL_YEAR_COURSE_GU
	      JOIN rev.EPC_CRS                   crs  ON crs.COURSE_GU                     = ycrs.COURSE_GU
	      JOIN rev.EPC_STAFF_SCH_YR          stfs ON stfs.STAFF_SCHOOL_YEAR_GU         = sect.STAFF_SCHOOL_YEAR_GU
	      JOIN rev.EPC_STAFF                 stf  ON stf.STAFF_GU                      = stfs.STAFF_GU
	      JOIN rev.EPC_STU_SCH_YR_GRD        grd  ON grd.STUDENT_SCHOOL_YEAR_GU        = ssy.STUDENT_SCHOOL_YEAR_GU
	      JOIN rev.EPC_STU_SCH_YR_GRD_PRD    gprd ON gprd.STU_SCHOOL_YEAR_GRD_GU       = grd.STU_SCHOOL_YEAR_GRD_GU
                                                     and gprd.SECTION_GU               = sect.SECTION_GU
	                                                 and gprd.STAFF_SCHOOL_YEAR_GU     = stfs.STAFF_SCHOOL_YEAR_GU
	      JOIN rev.EPC_STU_SCH_YR_GRD_PRD_MK mk   ON mk.STU_SCHOOL_YEAR_GRD_PRD_GU     = gprd.STU_SCHOOL_YEAR_GRD_PRD_GU
	      JOIN rev.EPC_SCH_YR_GRD_PRD        sgp  ON sgp.SCHOOL_YEAR_GRD_PRD_GU        = gprd.SCHOOL_YEAR_GRD_PRD_GU
	      JOIN rev.EPC_SCH_YR_GRD_PRD_MK     smk  ON smk.SCHOOL_YEAR_GRD_PRD_GU        = sgp.SCHOOL_YEAR_GRD_PRD_GU
	                                                   and smk.SCHOOL_YEAR_GRD_PRD_MK_GU = mk.SCHOOL_YEAR_GRD_PRD_MK_GU
	                                                   and smk.MARK_NAME like '%Grade'
), CourseHistoryMark AS
(
SELECT 
            stu.student_gu
          , row_number() over(partition by stu.student_gu,crs.course_id, sect.section_id,sect.term_code  order by crsh.calendar_month desc ) rn
          , sect.TERM_CODE
		  , sect.SECTION_ID
		  , crs.COURSE_ID
		  , crs.COURSE_GU
		  , stf.BADGE_NUM
		  , crsh.MARK
   FROM   rev.EPC_STU                        stu
          JOIN rev.EPC_STU_SCH_YR            ssy  ON ssy.STUDENT_GU                    = stu.STUDENT_GU
          JOIN rev.REV_ORGANIZATION_YEAR     oyr  ON oyr.ORGANIZATION_YEAR_GU          = ssy.ORGANIZATION_YEAR_GU
		  JOIN rev.REV_YEAR                  yr   ON yr.YEAR_GU                        = oyr.YEAR_GU
                                                     and yr.SCHOOL_YEAR                = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
          JOIN rev.EPC_STU_CLASS             cls  ON cls.STUDENT_SCHOOL_YEAR_GU        = ssy.STUDENT_SCHOOL_YEAR_GU
	      JOIN rev.EPC_SCH_YR_SECT           sect ON sect.SECTION_GU                   = cls.SECTION_GU
	      JOIN rev.EPC_SCH_YR_CRS            ycrs ON ycrs.SCHOOL_YEAR_COURSE_GU        = sect.SCHOOL_YEAR_COURSE_GU
	      JOIN rev.EPC_CRS                   crs  ON crs.COURSE_GU                     = ycrs.COURSE_GU
	      JOIN rev.EPC_STAFF_SCH_YR          stfs ON stfs.STAFF_SCHOOL_YEAR_GU         = sect.STAFF_SCHOOL_YEAR_GU
	      JOIN rev.EPC_STAFF                 stf  ON stf.STAFF_GU                      = stfs.STAFF_GU
          JOIN rev.EPC_STU_CRS_HIS           crsh ON crsh.STUDENT_GU = stu.STUDENT_GU
		                                             and crsh.COURSE_GU = crs.COURSE_GU
													 and crsh.SCHOOL_YEAR = yr.SCHOOL_YEAR
)
SELECT  distinct
         stu.SIS_NUMBER                           AS [student_code]
       , yr.SCHOOL_YEAR                           AS [school_year]
       --, sect.TERM_CODE                           AS [term_code]
       , sch.SCHOOL_CODE                          AS [school_code]
	   , crs.COURSE_TITLE
	   , crs.COURSE_ID
	   , crs.DEPARTMENT
   --    , replace(lower(stf.BADGE_NUM), 'e', '')   AS [staff_code]
   --    , CAST(yr.SCHOOL_YEAR AS varchar(4)) 
	  --   + sch.SCHOOL_CODE
		 --+ crs.COURSE_ID                          AS [course_code]
       --, CAST(yr.SCHOOL_YEAR                      AS varchar(4)) 
	  --   + sch.SCHOOL_CODE
		 --+ crs.COURSE_ID
		 --+ replace(lower(stf.BADGE_NUM), 'e', '') AS [section_code]
       , COALESCE(mk.MARK, chsm.MARK)             AS [mark_code]
       --, CONVERT(VARCHAR(10),cls.ENTER_DATE,120)  AS [date_enrolled]
       --, CONVERT(VARCHAR(10),cls.LEAVE_DATE,120)  AS [date_withdrawn]
   --    , stfp.LAST_NAME
	  --   + ', '+ stfp.FIRST_NAME
		 --+ ', '+ crs.COURSE_ID
		 --+ ', '+ sect.SECTION_ID
	  --                                            AS [section_name]
       --, ''                                       AS [period_code]
FROM   rev.EPC_STU                             stu
       JOIN rev.EPC_STU_SCH_YR                 ssy  ON ssy.STUDENT_GU                    = stu.STUDENT_GU
       JOIN rev.REV_ORGANIZATION_YEAR          oyr  ON oyr.ORGANIZATION_YEAR_GU          = ssy.ORGANIZATION_YEAR_GU
                                                       and oyr.YEAR_GU                   = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_YEAR                       yr   ON yr.YEAR_GU                        = oyr.YEAR_GU
	   JOIN rev.EPC_SCH                        sch  ON sch.ORGANIZATION_GU               = oyr.ORGANIZATION_GU
       JOIN rev.EPC_STU_CLASS                  cls  ON cls.STUDENT_SCHOOL_YEAR_GU        = ssy.STUDENT_SCHOOL_YEAR_GU
	   JOIN rev.EPC_SCH_YR_SECT                sect ON sect.SECTION_GU                   = cls.SECTION_GU
	   JOIN rev.EPC_SCH_YR_CRS                 ycrs ON ycrs.SCHOOL_YEAR_COURSE_GU        = sect.SCHOOL_YEAR_COURSE_GU
	   JOIN rev.EPC_CRS                        crs  ON crs.COURSE_GU                     = ycrs.COURSE_GU
													AND crs.DEPARTMENT IN ('ENG','MATH')
	   JOIN rev.EPC_STAFF_SCH_YR               stfs ON stfs.STAFF_SCHOOL_YEAR_GU         = sect.STAFF_SCHOOL_YEAR_GU
	   JOIN rev.EPC_STAFF                      stf  ON stf.STAFF_GU                      = stfs.STAFF_GU
	   JOIN rev.REV_PERSON                     stfp ON stfp.PERSON_GU                    = stf.STAFF_GU
	   LEFT JOIN GradeMark                     mk   ON mk.STUDENT_GU                     = stu.STUDENT_GU
                                                       and mk.COURSE_ID                  = crs.COURSE_ID
													   and mk.SECTION_ID                 = sect.SECTION_ID
													   and mk.TERM_CODE                  = sect.TERM_CODE
													   and mk.BADGE_NUM                  = stf.BADGE_NUM
       LEFT JOIN CourseHistoryMark             chsm ON chsm.STUDENT_GU                   = stu.STUDENT_GU
                                                       and chsm.rn                       = 1
													   and chsm.COURSE_GU                = crs.COURSE_GU
													   and chsm.SECTION_ID               = sect.SECTION_ID

WHERE mk.MARK IS NOT NULL
AND (sch.SCHOOL_CODE < '500' AND sch.SCHOOL_CODE > '200')
ORDER BY student_code, DEPARTMENT, mark_code