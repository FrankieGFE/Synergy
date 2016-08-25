

ALTER VIEW APS.Edgenuity_Enrollment_Export
AS


SELECT  distinct
        
		stu.SIS_NUMBER                            AS SUSD
       , crs.COURSE_ID                            AS 'Course Code'
	   , crs.COURSE_SHORT_TITLE					  AS 'Course Title'
	   , TERM_CODE								  AS 'Term'
	   , CASE WHEN cls.LEAVE_DATE IS NULL THEN 'Active' 
	          ELSE 'Withdrawn'
	   END		    						      AS 'Status'
	   --, YR.SCHOOL_YEAR
	   --, cls.ENTER_DATE
	   --, cls.LEAVE_DATE
	   --,sch.SCHOOL_CODE
FROM   rev.EPC_STU                             stu
       JOIN rev.EPC_STU_SCH_YR                 ssy  ON ssy.STUDENT_GU                    = stu.STUDENT_GU
       JOIN rev.REV_ORGANIZATION_YEAR          oyr  ON oyr.ORGANIZATION_YEAR_GU          = ssy.ORGANIZATION_YEAR_GU
                                                       and oyr.YEAR_GU                   = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
	   JOIN rev.REV_ORGANIZATION               org  ON org.ORGANIZATION_GU               = oyr.ORGANIZATION_GU
       JOIN rev.REV_YEAR                       yr   ON yr.YEAR_GU                        = oyr.YEAR_GU
	   JOIN rev.EPC_SCH                        sch  ON sch.ORGANIZATION_GU               = oyr.ORGANIZATION_GU
       JOIN rev.EPC_STU_CLASS                  cls  ON cls.STUDENT_SCHOOL_YEAR_GU        = ssy.STUDENT_SCHOOL_YEAR_GU
	   JOIN rev.EPC_SCH_YR_SECT                sect ON sect.SECTION_GU                   = cls.SECTION_GU
	   JOIN rev.EPC_SCH_YR_CRS                 ycrs ON ycrs.SCHOOL_YEAR_COURSE_GU        = sect.SCHOOL_YEAR_COURSE_GU
	   JOIN rev.EPC_CRS                        crs  ON crs.COURSE_GU                     = ycrs.COURSE_GU
	   JOIN rev.EPC_STAFF_SCH_YR               stfs ON stfs.STAFF_SCHOOL_YEAR_GU         = sect.STAFF_SCHOOL_YEAR_GU
	   JOIN rev.EPC_STAFF                      stf  ON stf.STAFF_GU                      = stfs.STAFF_GU

WHERE
	1 = 1
	AND YR.SCHOOL_YEAR = (SELECT * FROM rev.SIF_22_Common_CurrentYear)
	AND EXTENSION = 'R'
	AND cls.LEAVE_DATE IS NULL  --- Request is for ALL enrollments from Loaction 517 and 518
	AND cls.ENTER_DATE IS NOT NULL
	--AND EXCLUDE_ADA_ADM IS NULL
	--AND SUMMER_WITHDRAWL_CODE IS NULL
	AND SCH.SCHOOL_CODE IN ('517','518')


--ORDER BY YR.SCHOOL_YEAR DESC

