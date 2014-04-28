/**
 * $LastChangedBy: e204042 
 * $LastChangedDate: 2014-04-28 
 *
 * This is the SchoolMessenger pull for Student Schedule.
 */

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SchoolMessenger].[StudentSchedule]'))
	EXEC ('CREATE VIEW SchoolMessenger.StudentSchedule AS SELECT 0 AS DUMMY')
GO

ALTER VIEW SchoolMessenger.StudentSchedule AS
SELECT
  stu.SIS_NUMBER                      AS [Student Number]
, crs.COURSE_TITLE + ' ' +
  crs.COURSE_ID + '-'+
  sec.SECTION_ID + '-'+ 
  cast(sec.PERIOD_BEGIN as char(2))   AS [Class Key]
,  sch.SCHOOL_CODE                    AS [School Number]

FROM rev.EPC_STU_SCH_YR        ssy    
JOIN rev.REV_ORGANIZATION_YEAR oyr    ON oyr.ORGANIZATION_YEAR_GU    = ssy.ORGANIZATION_YEAR_GU
                                         AND oyr.YEAR_GU             = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
JOIN rev.EPC_STU               stu    ON stu.STUDENT_GU              = ssy.STUDENT_GU
JOIN rev.EPC_SCH               sch    ON sch.ORGANIZATION_GU         = oyr.ORGANIZATION_GU  
JOIN rev.EPC_STU_CLASS         cls    ON cls.STUDENT_SCHOOL_YEAR_GU  = ssy.STUDENT_SCHOOL_YEAR_GU
JOIN rev.EPC_SCH_YR_SECT       sec    ON cls.SECTION_GU              = sec.SECTION_GU
JOIN rev.EPC_SCH_YR_CRS        sycrs  ON sycrs.SCHOOL_YEAR_COURSE_GU = sec.SCHOOL_YEAR_COURSE_GU
JOIN rev.EPC_CRS               crs    ON crs.COURSE_GU               = sycrs.COURSE_GU

GO