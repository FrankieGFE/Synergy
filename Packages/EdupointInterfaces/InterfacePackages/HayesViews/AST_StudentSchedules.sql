--APS - Database View for Hayes Textbook Software System - ASTStudentSchedules>

IF OBJECT_ID('EVASourcedb.ASTStudentSchedules') IS NOT NULL DROP VIEW EVASourcedb.ASTStudentSchedules
GO
CREATE VIEW EVASourcedb.ASTStudentSchedules AS

SELECT  DISTINCT
         sch.SCHOOL_CODE                     AS [LocationGivenID]
       , /*'S'+*/stu.SIS_NUMBER                  AS [StudentGivenID]
       , LTRIM(RTRIM(crs.COURSE_ID
         + '/' +
         sect.SECTION_ID
         + '/' + 
       CAST(sect.PERIOD_BEGIN as CHAR(2))))   AS [ClassGivenID]
FROM   rev.EPC_STU                    stu
       JOIN rev.REV_PERSON            per   ON per.PERSON_GU              = stu.STUDENT_GU
       JOIN rev.EPC_STU_SCH_YR        ssy   ON ssy.STUDENT_GU             = stu.STUDENT_GU
                                               AND ssy.STATUS             IS NULL
       JOIN rev.REV_ORGANIZATION_YEAR oyr   ON oyr.ORGANIZATION_YEAR_GU   = ssy.ORGANIZATION_YEAR_GU
       JOIN rev.REV_YEAR              yr    ON yr.YEAR_GU                 = oyr.YEAR_GU 
                                               and yr.YEAR_GU         IN (SELECT YEAR_GU FROM APS.YearDates WHERE GETDATE() BETWEEN YearDates.START_DATE AND YearDates.END_DATE)
       JOIN rev.EPC_SCH               sch   ON sch.ORGANIZATION_GU        = oyr.ORGANIZATION_GU
       JOIN rev.EPC_STU_CLASS         cls   ON cls.STUDENT_SCHOOL_YEAR_GU = ssy.STUDENT_SCHOOL_YEAR_GU
       JOIN rev.EPC_SCH_YR_SECT       sect  ON sect.SECTION_GU            = cls.SECTION_GU
       JOIN rev.EPC_SCH_YR_CRS        scrs  ON scrs.SCHOOL_YEAR_COURSE_GU = sect.SCHOOL_YEAR_COURSE_GU
       JOIN rev.EPC_CRS               crs   ON crs.COURSE_GU              = scrs.COURSE_GU
/*WHERE (cls.LEAVE_DATE IS NULL OR cls.LEAVE_DATE >= GETDATE())
       AND cls.ENTER_DATE <= GETDATE()*/
