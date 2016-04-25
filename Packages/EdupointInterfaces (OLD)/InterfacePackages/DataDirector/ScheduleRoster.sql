--<APS - DataDirector - ScheduleRoster>
SELECT DISTINCT
           stu.SIS_NUMBER                            AS [student_code]
         , replace(lower(stf.BADGE_NUM), 'e','')     AS [staff_code]
         , CASE 
               WHEN CAST(ssyr.grade as int) > 220 THEN '12'
			   ELSE grade.VALUE_DESCRIPTION
              -- WHEN CAST(ssyr.grade as int) < 110 THEN '1'
              -- ELSE CAST(grade.VALUE_DESCRIPTION as int)
           END                                       AS [grade_code]
         , sect.TERM_CODE                            AS [semester_code]
         , sect.PERIOD_BEGIN                         AS [PERIOD]
         , sch.SCHOOL_CODE                           AS [school_code]
         , crs.COURSE_ID                             AS [CRS_ASG]
FROM     rev.EPC_STU                    stu
         JOIN rev.EPC_STU_SCH_YR        ssyr ON ssyr.STUDENT_GU            = stu.STUDENT_GU
                                                AND ssyr.STATUS IS NULL
         JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU   = ssyr.ORGANIZATION_YEAR_GU
         JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU = oyr.YEAR_GU 
                                                --AND yr.YEAR_GU IN (SELECT YEAR_GU FROM APS.YearDates WHERE (GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE))
                                                --AND yr.YEAR_GU = '26F066A3-ABFC-4EDB-B397-43412EDABC8B'
                                                AND yr.SCHOOL_YEAR = '2014'
         JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
         JOIN rev.EPC_STU_CLASS         cls  ON cls.STUDENT_SCHOOL_YEAR_GU = ssyr.STUDENT_SCHOOL_YEAR_GU
         JOIN rev.EPC_SCH_YR_SECT       sect ON sect.SECTION_GU            = cls.SECTION_GU
         JOIN rev.EPC_SCH_YR_CRS        scrs ON scrs.SCHOOL_YEAR_COURSE_GU = sect.SCHOOL_YEAR_COURSE_GU
         JOIN rev.EPC_CRS               crs  ON crs.COURSE_GU              = scrs.COURSE_GU
         JOIN rev.EPC_STAFF_SCH_YR      stfy ON stfy.STAFF_SCHOOL_YEAR_GU  = sect.STAFF_SCHOOL_YEAR_GU
         JOIN rev.EPC_STAFF             stf  ON stf.STAFF_GU               = stfy.STAFF_GU
         LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grade ON grade.VALUE_CODE = ssyr.GRADE
--WHERE    (cls.LEAVE_DATE IS NULL OR cls.LEAVE_DATE >= GETDATE())
--          AND cls.ENTER_DATE <= GETDATE()
ORDER BY stu.SIS_NUMBER, sect.PERIOD_BEGIN
