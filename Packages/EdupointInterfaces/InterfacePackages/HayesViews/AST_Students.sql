--APS - Database View for Hayes Textbook Software System - ASTStudents>

IF OBJECT_ID('EVASourcedb.ASTStudents') IS NOT NULL DROP VIEW EVASourcedb.ASTStudents
GO
CREATE VIEW EVASourcedb.ASTStudents AS
with ElemHomeroom AS
(
  select 
          stu.student_gu
        , row_number() over(partition by stu.student_gu order by stu.student_gu) rn
        , stfp.LAST_NAME + ', '+ stfp.FIRST_NAME                                 TeacherName
  from  rev.EPC_STU                    stu
        JOIN rev.REV_PERSON            per  ON per.PERSON_GU               = stu.STUDENT_GU
        JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU              = stu.STUDENT_GU 
        JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU    = ssy.ORGANIZATION_YEAR_GU
        JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU                  = oyr.YEAR_GU 
                                               and yr.YEAR_GU         IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
        JOIN rev.EPC_SCH               sch  ON sch.ORGANIZATION_GU         = oyr.ORGANIZATION_GU
        JOIN rev.EPC_SCH_YR_OPT        sopt ON sopt.ORGANIZATION_YEAR_GU   = oyr.ORGANIZATION_YEAR_GU
                                               AND sopt.SCHOOL_TYPE        = '1'
        JOIN rev.EPC_STU_CLASS         cls  ON cls.STUDENT_SCHOOL_YEAR_GU  = ssy.STUDENT_SCHOOL_YEAR_GU
        JOIN rev.EPC_SCH_YR_SECT       sect ON sect.SECTION_GU             = cls.SECTION_GU
                                               and sect.PERIOD_BEGIN       = 1
        JOIN rev.EPC_STAFF_SCH_YR      stfsy ON stfsy.STAFF_SCHOOL_YEAR_GU = sect.STAFF_SCHOOL_YEAR_GU
        JOIN rev.REV_PERSON            stfp  ON stfp.PERSON_GU             = stfsy.STAFF_GU
)

SELECT
        sch.SCHOOL_CODE        AS [LocationGivenID]
      , 'S'+stu.SIS_NUMBER     AS [StudentID]
      , per.FIRST_NAME         AS [FirstName]
      , per.LAST_NAME          AS [LastName]
      , per.MIDDLE_NAME        AS [MiddleName]
      , per.GENDER             AS [Gender]
      , per.BIRTH_DATE         AS [Birthdate]
      , grd.VALUE_DESCRIPTION  AS [GradeLevel]
      , ''                     AS [General1]
      , eht.TeacherName        AS [General2]
FROM rev.EPC_STU                    stu
     JOIN rev.REV_PERSON            per ON per.PERSON_GU            = stu.STUDENT_GU
     JOIN rev.EPC_STU_SCH_YR        ssy ON ssy.STUDENT_GU           = stu.STUDENT_GU
                                           AND ssy.STATUS           IS NULL
     JOIN rev.REV_ORGANIZATION_YEAR oyr ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
     JOIN rev.REV_YEAR              yr  ON yr.YEAR_GU               = oyr.YEAR_GU 
                                           and yr.YEAR_GU         IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
     JOIN rev.REV_ORGANIZATION      org ON org.ORGANIZATION_GU      = oyr.ORGANIZATION_GU
     JOIN rev.EPC_SCH               sch ON sch.ORGANIZATION_GU      = org.ORGANIZATION_GU
     LEFT JOIN rev.SIF_22_Common_GetLookupValues('K12', 'GRADE') grd ON grd.VALUE_CODE = ssy.GRADE
     LEFT JOIN ElemHomeroom         eht ON eht.STUDENT_GU           = stu.STUDENT_GU and  eht.rn = 1