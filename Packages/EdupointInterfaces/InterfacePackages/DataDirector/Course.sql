--<APS - DataDirector - CourseList>

SELECT DISTINCT
           sch.SCHOOL_CODE                  AS [SCHOOL]
         , crs.COURSE_ID                    AS [COURSE]
         , crs.COURSE_SHORT_TITLE           AS [CRS_ABBRV]
         , crs.COURSE_TITLE                 AS [CRS_DESCR]
         , sarea.VALUE_DESCRIPTION          AS [DEPARTMENT]
         , CAST(crs.CREDIT as varchar(10))  AS [CREDIT]
         , ''                               AS [GRAD_YR]
FROM     rev.EPC_SCH_YR_CRS sycrs
         JOIN rev.REV_ORGANIZATION_YEAR oyr on oyr.ORGANIZATION_YEAR_GU = sycrs.ORGANIZATION_YEAR_GU
         JOIN rev.REV_YEAR              yr  on yr.YEAR_GU = oyr.YEAR_GU 
	                                           and yr.SCHOOL_YEAR = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
         JOIN rev.EPC_SCH               sch on sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
         JOIN rev.EPC_CRS               crs on crs.COURSE_GU = sycrs.COURSE_GU
         LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12.CourseInfo', 'SUBJECT_AREA') sarea ON sarea.VALUE_CODE = crs.SUBJECT_AREA_1
ORDER BY sch.SCHOOL_CODE, crs.COURSE_ID
