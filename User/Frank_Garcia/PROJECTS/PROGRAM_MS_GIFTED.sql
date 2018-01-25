USE ST_Production
GO

/****
 
 * $LastChangedBy: Frank Garcia
 * $LastChangedDate: 12/18/2014 $
 *
 * Request By: SchoolNet
 * InitialRequestDate: 
 * 
 * Initial Request:
 * MS GIFTED (MS_GFT)
 * 
	
****/

SELECT
	student_code
	,school_code
	,school_year
	,program_code
	,date_enrolled
	,date_withdrawn
	,date_iep
	,date_iep_end
FROM
(	
SELECT 
       row_number() over(partition by stu.student_gu  order by stu.student_gu, cls.ENTER_DATE) rn2
	   ,  stu.SIS_NUMBER                           AS [student_code]
       , yr.SCHOOL_YEAR                           AS [school_year]
	   --, GFT.COURSE_LEVEL
	   --, VALUE_DESCRIPTION
       , sch.SCHOOL_CODE                          AS [school_code]
	   , 'MS_GFT'								  AS [program_code]
       , CONVERT(VARCHAR(10),cls.ENTER_DATE,120)  AS [date_enrolled]
       , CONVERT(VARCHAR(10),cls.LEAVE_DATE,120)  AS [date_withdrawn]
	   , CONVERT(VARCHAR(10), NULL, 120)		   AS [date_iep]
	   , CONVERT(VARCHAR(10), NULL, 120)		   AS [date_iep_end]
FROM   rev.EPC_STU                             stu
       JOIN rev.EPC_STU_SCH_YR                 ssy  ON ssy.STUDENT_GU                    = stu.STUDENT_GU
	   LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grade ON grade.VALUE_CODE = ssy.GRADE
       JOIN rev.REV_ORGANIZATION_YEAR          oyr  ON oyr.ORGANIZATION_YEAR_GU          = ssy.ORGANIZATION_YEAR_GU
                                                       and oyr.YEAR_GU                   = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
       JOIN rev.REV_YEAR                       yr   ON yr.YEAR_GU                        = oyr.YEAR_GU
	   JOIN rev.EPC_SCH                        sch  ON sch.ORGANIZATION_GU               = oyr.ORGANIZATION_GU
       JOIN rev.EPC_STU_CLASS                  cls  ON cls.STUDENT_SCHOOL_YEAR_GU        = ssy.STUDENT_SCHOOL_YEAR_GU
														AND CLS.LEAVE_DATE IS NULL
	   JOIN rev.EPC_SCH_YR_SECT                sect ON sect.SECTION_GU                   = cls.SECTION_GU
	   JOIN rev.EPC_SCH_YR_CRS                 ycrs ON ycrs.SCHOOL_YEAR_COURSE_GU        = sect.SCHOOL_YEAR_COURSE_GU
	   JOIN rev.EPC_CRS                        crs  ON crs.COURSE_GU                     = ycrs.COURSE_GU
	   JOIN rev.EPC_STAFF_SCH_YR               stfs ON stfs.STAFF_SCHOOL_YEAR_GU         = sect.STAFF_SCHOOL_YEAR_GU
	   JOIN rev.EPC_STAFF                      stf  ON stf.STAFF_GU                      = stfs.STAFF_GU
	   JOIN rev.REV_PERSON                     stfp ON stfp.PERSON_GU                    = stf.STAFF_GU
	   --LEFT JOIN GradeMark                     mk   ON mk.STUDENT_GU                     = stu.STUDENT_GU
    --                                                   and mk.COURSE_ID                  = crs.COURSE_ID
				--									   and mk.SECTION_ID                 = sect.SECTION_ID
				--									   and mk.TERM_CODE                  = sect.TERM_CODE
				--									   and mk.BADGE_NUM                  = stf.BADGE_NUM
    --   LEFT JOIN CourseHistoryMark             chsm ON chsm.STUDENT_GU                   = stu.STUDENT_GU
    --                                                   and chsm.rn                       = 1
				--									   and chsm.COURSE_GU                = crs.COURSE_GU
				--									   and chsm.SECTION_ID               = sect.SECTION_ID
	   JOIN REV.EPC_CRS_LEVEL_LST              GFT ON GFT.COURSE_GU                      = CRS.COURSE_GU
	                                                  AND GFT.COURSE_LEVEL = 'GFT'
WHERE VALUE_DESCRIPTION IN ('06','07','08')
) AS MID_GFT
WHERE rn2 = 1
ORDER BY student_code