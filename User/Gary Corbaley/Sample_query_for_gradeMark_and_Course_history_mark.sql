-- GradeMark 

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
	                                                   and smk.MARK_NAME in ( 'P1', 'Q1')


--  CourseHistoryMark 

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
