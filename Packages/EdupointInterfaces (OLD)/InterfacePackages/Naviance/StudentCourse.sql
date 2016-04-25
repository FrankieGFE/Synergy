--<APS - Naviance Student Course Data>
/*
All actively enrolled student’s course history and courses in progress 
on the student’s schedule for the current school year 
(regardless of whether they have ended).
*/
-- Course history info
SELECT
   stu.SIS_NUMBER                              AS [Student ID]
 , crsh.COURSE_ID                              AS [Course ID]
 , grdh.VALUE_DESCRIPTION                      AS [Grade Level Taken]
 , crsh.TERM_CODE                              AS [Term]
 , crsh.COURSE_TITLE                           AS [Course Name]
 , crsh.TEACHER_NAME                           AS [Teacher]
 , cast(crsh.CREDIT_COMPLETED as nvarchar(10)) AS [Credits Earned]
 , crsh.MARK                                   AS [Letter Grade]
 , ''                                          AS [Score]
 , 'Completed'                                 AS [Course Status]

FROM rev.EPC_STU                    stu
     JOIN rev.EPC_STU_SCH_YR        ssyr  ON ssyr.STUDENT_GU             = stu.STUDENT_GU 
                                             AND ssyr.STATUS               IS NULL
     JOIN rev.REV_ORGANIZATION_YEAR oyr   ON oyr.ORGANIZATION_YEAR_GU    = ssyr.ORGANIZATION_YEAR_GU
                                             AND oyr.YEAR_GU             = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
     join rev.EPC_STU_CRS_HIS       crsh  ON crsh.STUDENT_GU             = stu.STUDENT_GU
     LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') grdh  ON grdh.VALUE_CODE  = crsh.GRADE
where crsh.CREDIT_COMPLETED != 0
      and grdh.VALUE_DESCRIPTION in ('06','07','08','09','10','11','12')
-- Current classes
UNION
SELECT
    stu.SIS_NUMBER                       AS [Student ID]
 ,  crs.COURSE_ID                        AS [Course ID]
 ,  grdc.VALUE_DESCRIPTION               AS [Grade Level Taken]
 ,  sect.TERM_CODE                       AS [Term]
 ,  crs.COURSE_TITLE                     AS [Course Name]
 ,  stfp.LAST_NAME+', '+stfp.FIRST_NAME  AS [Teacher]
 , ''                                    AS [Credits Earned]
 , 'No Grade'                            AS [Letter Grade]
 , ''                                    AS [Score]
 , 'In progress'                         AS [Course Status]

FROM rev.EPC_STU                    stu
     JOIN rev.EPC_STU_SCH_YR        ssyr  ON ssyr.STUDENT_GU             = stu.STUDENT_GU 
                                             AND ssyr.STATUS               IS NULL
     JOIN rev.REV_ORGANIZATION_YEAR oyr   ON oyr.ORGANIZATION_YEAR_GU    = ssyr.ORGANIZATION_YEAR_GU
                                             AND oyr.YEAR_GU             = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
     LEFT JOIN REV.EPC_STU_CLASS    cls   ON cls.STUDENT_SCHOOL_YEAR_GU  = ssyr.STUDENT_SCHOOL_YEAR_GU
     LEFT JOIN rev.EPC_SCH_YR_SECT  sect  ON sect.SECTION_GU             = cls.SECTION_GU
     JOIN rev.EPC_SCH_YR_CRS        sycrs ON sycrs.SCHOOL_YEAR_COURSE_GU = sect.SCHOOL_YEAR_COURSE_GU
     JOIN rev.EPC_CRS               crs   ON crs.COURSE_GU               = sycrs.COURSE_GU
     LEFT JOIN rev.EPC_STAFF_SCH_YR stfsy ON stfsy.STAFF_SCHOOL_YEAR_GU  = sect.STAFF_SCHOOL_YEAR_GU
     LEFT JOIN rev.REV_PERSON       stfp  ON stfp.PERSON_GU              = stfsy.STAFF_GU
     LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12','GRADE') grdc  ON grdc.VALUE_CODE  = ssyr.GRADE
WHERE not exists (select h.course_id from rev.EPC_STU_CRS_HIS h where h.student_gu    = stu.student_gu 
                                                                      and h.COURSE_ID = crs.COURSE_ID
                                                                      and h.TERM_CODE = sect.TERM_CODE
                                                                      and h.GRADE     = ssyr.grade 
                                                                      and h.CREDIT_COMPLETED != 0
                                                                      )
     and grdc.VALUE_DESCRIPTION in ('06','07','08','09','10','11','12')