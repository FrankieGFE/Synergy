USE [ST_Production]
GO

/****** Object:  View [SchoolMessenger].[StudentSchedule]    Script Date: 6/15/2015 12:55:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SchoolMessenger].[StudentSchedule]'))
	EXEC ('CREATE VIEW SchoolMessenger.StudentSchedule AS SELECT 0 AS DUMMY')
GO

ALTER VIEW SchoolMessenger.StudentSchedule AS
with SummarSchoolStu AS
(
   select 
        stu.student_gu
   FROM rev.EPC_STU                    stu
        JOIN rev.EPC_STU_SCH_YR        ssy  ON ssy.STUDENT_GU = stu.STUDENT_GU
                                            and ssy.STATUS is NULL
                                            and ssy.EXCLUDE_ADA_ADM is null --exclude concurrent enrollment
											and ssy.LEAVE_DATE is null
        JOIN rev.REV_ORGANIZATION_YEAR oyr  ON oyr.ORGANIZATION_YEAR_GU = ssy.ORGANIZATION_YEAR_GU
        JOIN rev.REV_YEAR              yr   ON yr.YEAR_GU = oyr.YEAR_GU
                                               and ((yr.SCHOOL_YEAR = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
                                               and yr.EXTENSION = 'S')
									  OR
									  (yr.SCHOOL_YEAR           = 2015
											  AND yr.EXTENSION             = 'N'))
)
--Only Regular School classes
SELECT
  stu.SIS_NUMBER                      AS [Student Number]
, crs.COURSE_TITLE + ' ' +
  crs.COURSE_ID + '-'+
  sec.SECTION_ID + '-'+ 
  cast(sec.PERIOD_BEGIN as char(2))   AS [Class Key]
,  sch.SCHOOL_CODE                    AS [School Number]
, ''                                  AS [Some SCH Attendance]
FROM rev.EPC_STU_SCH_YR             ssy    
     JOIN rev.REV_ORGANIZATION_YEAR oyr    ON oyr.ORGANIZATION_YEAR_GU    = ssy.ORGANIZATION_YEAR_GU
     JOIN rev.REV_YEAR              y      ON y.YEAR_GU                   = ssy.YEAR_GU 
                                              AND y.SCHOOL_YEAR           = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
											  AND y.EXTENSION             = 'R'
     JOIN rev.EPC_STU               stu    ON stu.STUDENT_GU              = ssy.STUDENT_GU
     JOIN rev.EPC_SCH               sch    ON sch.ORGANIZATION_GU         = oyr.ORGANIZATION_GU  
     JOIN rev.EPC_STU_CLASS         cls    ON cls.STUDENT_SCHOOL_YEAR_GU  = ssy.STUDENT_SCHOOL_YEAR_GU
     JOIN rev.EPC_SCH_YR_SECT       sec    ON cls.SECTION_GU              = sec.SECTION_GU
     JOIN rev.EPC_SCH_YR_CRS        sycrs  ON sycrs.SCHOOL_YEAR_COURSE_GU = sec.SCHOOL_YEAR_COURSE_GU
     JOIN rev.EPC_CRS               crs    ON crs.COURSE_GU               = sycrs.COURSE_GU
WHERE (cls.LEAVE_DATE IS NULL OR cls.LEAVE_DATE >= GETDATE())  AND cls.ENTER_DATE <= GETDATE()
	 -- to exclude those students who have a summar school enrollment
	 and not exists (select ss.student_gu from SummarSchoolStu ss where ss.STUDENT_GU = stu.STUDENT_GU)
--Only Summer School classes
UNION
SELECT
  stu.SIS_NUMBER                      AS [Student Number]
, crs.COURSE_TITLE + ' ' +
  crs.COURSE_ID + '-'+
  sec.SECTION_ID + '-'+ 
  cast(sec.PERIOD_BEGIN as char(2))   AS [Class Key]
,  sch.SCHOOL_CODE                    AS [School Number]
, 'summer'                            AS [Some SCH Attendance]
FROM rev.EPC_STU_SCH_YR             ssy    
     JOIN rev.REV_ORGANIZATION_YEAR oyr    ON oyr.ORGANIZATION_YEAR_GU    = ssy.ORGANIZATION_YEAR_GU
     JOIN rev.REV_YEAR              y      ON y.YEAR_GU                   = ssy.YEAR_GU 
                                              AND ((y.SCHOOL_YEAR           = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear)
											  AND y.EXTENSION             = 'S')
									     OR
										(y.SCHOOL_YEAR           = 2015
											  AND y.EXTENSION             = 'N'))
     JOIN rev.EPC_STU               stu    ON stu.STUDENT_GU              = ssy.STUDENT_GU
     JOIN rev.EPC_SCH               sch    ON sch.ORGANIZATION_GU         = oyr.ORGANIZATION_GU  
     JOIN rev.EPC_STU_CLASS         cls    ON cls.STUDENT_SCHOOL_YEAR_GU  = ssy.STUDENT_SCHOOL_YEAR_GU
     JOIN rev.EPC_SCH_YR_SECT       sec    ON cls.SECTION_GU              = sec.SECTION_GU
     JOIN rev.EPC_SCH_YR_CRS        sycrs  ON sycrs.SCHOOL_YEAR_COURSE_GU = sec.SCHOOL_YEAR_COURSE_GU
     JOIN rev.EPC_CRS               crs    ON crs.COURSE_GU               = sycrs.COURSE_GU
WHERE (cls.LEAVE_DATE IS NULL OR cls.LEAVE_DATE >= GETDATE())  AND cls.ENTER_DATE <= GETDATE()
-- Next Years Regular Enrollment
UNION
SELECT
  stu.SIS_NUMBER                      AS [Student Number]
, crs.COURSE_TITLE + ' ' +
  crs.COURSE_ID + '-'+
  sec.SECTION_ID + '-'+ 
  cast(sec.PERIOD_BEGIN as char(2))   AS [Class Key]
,  sch.SCHOOL_CODE                    AS [School Number]
, ''                                  AS [Some SCH Attendance]
FROM rev.EPC_STU_SCH_YR             ssy    
     JOIN rev.REV_ORGANIZATION_YEAR oyr    ON oyr.ORGANIZATION_YEAR_GU    = ssy.ORGANIZATION_YEAR_GU
     JOIN rev.REV_YEAR              y      ON y.YEAR_GU                   = ssy.YEAR_GU 
                                              AND y.SCHOOL_YEAR           = (select SCHOOL_YEAR from rev.SIF_22_Common_CurrentYear) + 1
											  AND y.EXTENSION             = 'R'
     JOIN rev.EPC_STU               stu    ON stu.STUDENT_GU              = ssy.STUDENT_GU
     JOIN rev.EPC_SCH               sch    ON sch.ORGANIZATION_GU         = oyr.ORGANIZATION_GU  
     JOIN rev.EPC_STU_CLASS         cls    ON cls.STUDENT_SCHOOL_YEAR_GU  = ssy.STUDENT_SCHOOL_YEAR_GU
     JOIN rev.EPC_SCH_YR_SECT       sec    ON cls.SECTION_GU              = sec.SECTION_GU
     JOIN rev.EPC_SCH_YR_CRS        sycrs  ON sycrs.SCHOOL_YEAR_COURSE_GU = sec.SCHOOL_YEAR_COURSE_GU
     JOIN rev.EPC_CRS               crs    ON crs.COURSE_GU               = sycrs.COURSE_GU
WHERE (cls.LEAVE_DATE IS NULL OR cls.LEAVE_DATE >= GETDATE())

GO


