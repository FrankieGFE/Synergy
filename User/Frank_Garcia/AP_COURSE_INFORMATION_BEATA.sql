
; with GradeMark AS
(
   SELECT 
            stu.student_gu
          , sect.TERM_CODE
		  , sect.SECTION_ID
		  , crs.COURSE_ID
		  , crs.AP_CODE
		  , crs.AP_INDICATOR
		  , stf.BADGE_NUM
		  , mk.MARK
		  , AP.TEST_SECTION_NAME
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
													   AND (stf.BADGE_NUM LIKE 'e%' AND stf.BADGE_NUM != 'ebarraclou')
													   AND stf.BADGE_NUM NOT IN ('777777777', 'e999999', '666666666', 'llvitan', 'llevitan', 'nbuenavent', 'aoverman-s', 'ebiersgree', 'eesparza', 'ekivitz', 'ekrahn','barraclou','nagy')
	      JOIN rev.EPC_STU_SCH_YR_GRD        grd  ON grd.STUDENT_SCHOOL_YEAR_GU        = ssy.STUDENT_SCHOOL_YEAR_GU
	      JOIN rev.EPC_STU_SCH_YR_GRD_PRD    gprd ON gprd.STU_SCHOOL_YEAR_GRD_GU       = grd.STU_SCHOOL_YEAR_GRD_GU
                                                     and gprd.SECTION_GU               = sect.SECTION_GU
	                                                 and gprd.STAFF_SCHOOL_YEAR_GU     = stfs.STAFF_SCHOOL_YEAR_GU
	      JOIN rev.EPC_STU_SCH_YR_GRD_PRD_MK mk   ON mk.STU_SCHOOL_YEAR_GRD_PRD_GU     = gprd.STU_SCHOOL_YEAR_GRD_PRD_GU
	      JOIN rev.EPC_SCH_YR_GRD_PRD        sgp  ON sgp.SCHOOL_YEAR_GRD_PRD_GU        = gprd.SCHOOL_YEAR_GRD_PRD_GU
	      JOIN rev.EPC_SCH_YR_GRD_PRD_MK     smk  ON smk.SCHOOL_YEAR_GRD_PRD_GU        = sgp.SCHOOL_YEAR_GRD_PRD_GU
	                                                   and smk.SCHOOL_YEAR_GRD_PRD_MK_GU = mk.SCHOOL_YEAR_GRD_PRD_MK_GU
	                                                   and smk.MARK_NAME like '%Grade'
          LEFT JOIN [RDAVM.APS.EDU.ACTD].ASSESSMENTS.DBO.TEST_RESULT_AP AS AP
		  ON STUDENT_CODE = STU.SIS_NUMBER
), CourseHistoryMark AS
(
SELECT 
            stu.student_gu
          --, row_number() over(partition by stu.student_gu,crs.course_id, sect.section_id,sect.term_code  order by crsh.calendar_month desc ) rn
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
													   AND (stf.BADGE_NUM LIKE 'e%' AND stf.BADGE_NUM != 'ebarraclou')
													   AND stf.BADGE_NUM NOT IN ('777777777', 'e999999', '666666666', 'llvitan', 'llevitan', 'nbuenavent', 'aoverman-s', 'ebiersgree', 'eesparza', 'ekivitz', 'ekrahn','barraclou')
          JOIN rev.EPC_STU_CRS_HIS           crsh ON crsh.STUDENT_GU = stu.STUDENT_GU
		                                             and crsh.COURSE_GU = crs.COURSE_GU
													 and crsh.SCHOOL_YEAR = yr.SCHOOL_YEAR
)
SELECT  distinct
        
		stu.SIS_NUMBER                           AS ID_NBR
       , CAST(replace(lower(stf.BADGE_NUM), 'e', '')AS INT)   AS EMP_NBR
	   --, STF.BADGE_NUM	AS EMP_ID
       , sch.SCHOOL_CODE                          AS SCH_NBR
	   --, CLS.LEAVE_DATE
	   , (GETDATE())							  AS DATE_CREATE
       , crs.COURSE_ID                            AS CRS_ASG
	   , crs.AP_CODE
	   , crs.AP_INDICATOR
	   , crs.COURSE_TITLE
	   , yr.SCHOOL_YEAR
	   , crs.DUAL_CREDIT
	   , BS.RESOLVED_RACE
	   , TEST_SECTION_NAME AS AP_COURSE
	   , SCALED_SCORE AS AP_SCORE
	   , GRADE.VALUE_DESCRIPTION AS GRADE
FROM   rev.EPC_STU                             stu
       JOIN rev.EPC_STU_SCH_YR                 ssy  ON ssy.STUDENT_GU                    = stu.STUDENT_GU
       JOIN rev.REV_ORGANIZATION_YEAR          oyr  ON oyr.ORGANIZATION_YEAR_GU          = ssy.ORGANIZATION_YEAR_GU
                                                       --and oyr.YEAR_GU                   = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_YEAR                       yr   ON yr.YEAR_GU                        = oyr.YEAR_GU
	   JOIN rev.EPC_SCH                        sch  ON sch.ORGANIZATION_GU               = oyr.ORGANIZATION_GU
       JOIN rev.EPC_STU_CLASS                  cls  ON cls.STUDENT_SCHOOL_YEAR_GU        = ssy.STUDENT_SCHOOL_YEAR_GU
	   JOIN rev.EPC_SCH_YR_SECT                sect ON sect.SECTION_GU                   = cls.SECTION_GU
	   JOIN rev.EPC_SCH_YR_CRS                 ycrs ON ycrs.SCHOOL_YEAR_COURSE_GU        = sect.SCHOOL_YEAR_COURSE_GU
	   JOIN rev.EPC_CRS                        crs  ON crs.COURSE_GU                     = ycrs.COURSE_GU
	   JOIN rev.EPC_STAFF_SCH_YR               stfs ON stfs.STAFF_SCHOOL_YEAR_GU         = sect.STAFF_SCHOOL_YEAR_GU
	   JOIN rev.EPC_STAFF                      stf  ON stf.STAFF_GU                      = stfs.STAFF_GU
													   AND (stf.BADGE_NUM LIKE 'e%' AND stf.BADGE_NUM != 'ebarraclou')
													   AND stf.BADGE_NUM NOT IN ('777777777', 'e999999', '666666666', 'llvitan', 'llevitan', 'nbuenavent', 'aoverman-s', 'ebiersgree', 'eesparza', 'ekivitz', 'ekrahn','barraclou','enagy','edolph')
	   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grade ON grade.VALUE_CODE = ssy.GRADE
       LEFT JOIN
	   APS.BasicStudentWithMoreInfo AS BS
	   ON BS.SIS_NUMBER = STU.SIS_NUMBER

          LEFT JOIN [RDAVM.APS.EDU.ACTD].ASSESSMENTS.DBO.TEST_RESULT_AP AS AP
		  ON STUDENT_CODE = STU.SIS_NUMBER
	   --JOIN rev.REV_PERSON                     stfp ON stfp.PERSON_GU                    = stf.STAFF_GU
	   --LEFT JOIN GradeMark                     mk   ON mk.STUDENT_GU                     = stu.STUDENT_GU
    --                                                   and mk.COURSE_ID                  = crs.COURSE_ID
				--									   and mk.SECTION_ID                 = sect.SECTION_ID
				--									   and mk.TERM_CODE                  = sect.TERM_CODE
				--									   and mk.BADGE_NUM                  = stf.BADGE_NUM
    --   LEFT JOIN CourseHistoryMark             chsm ON chsm.STUDENT_GU                   = stu.STUDENT_GU
    --                                                   and chsm.rn                       = 1
				--									   and chsm.COURSE_GU                = crs.COURSE_GU
				--									   and chsm.SECTION_ID               = sect.SECTION_ID



WHERE cls.LEAVE_DATE IS NULL
AND YR.SCHOOL_YEAR = '2014'
AND AP_INDICATOR = 'Y'
AND GRADE > '08'
--AND stu.SIS_NUMBER = '970092962'
ORDER BY STU.SIS_NUMBER
