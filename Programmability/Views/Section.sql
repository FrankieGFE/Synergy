/**
 * $LastChangedBy: e204042 
 * $LastChangedDate: 2014-04-28 
 *
 * This is the SchoolMessenger pull for Section.
 */

BEGIN TRAN
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[SchoolMessenger].[Section]'))
	EXEC ('CREATE VIEW SchoolMessenger.Section AS SELECT 0 AS DUMMY')
GO

ALTER VIEW SchoolMessenger.Section AS
SELECT
  sch.SCHOOL_CODE                         AS [School Number]
, crs.COURSE_TITLE + ' ' +
  crs.COURSE_ID + '-'+
  sect.SECTION_ID + '-'+ 
  cast(sect.PERIOD_BEGIN as char(2))      AS [Class Key]
, stf.BADGE_NUM                           AS [Staff Number]
, sect.PERIOD_BEGIN                       AS [Period]
, yr.SCHOOL_YEAR                          AS [Current School Year]
, stfp.FIRST_NAME + ' ' + stfp.LAST_NAME  AS [Staff Name]
, crs.COURSE_TITLE                        AS [Course Title]

FROM rev.EPC_SCH_YR_SECT       sect
JOIN rev.REV_ORGANIZATION_YEAR oyr   ON oyr.ORGANIZATION_YEAR_GU = sect.ORGANIZATION_YEAR_GU
                                        AND oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
JOIN rev.REV_YEAR              yr    ON yr.YEAR_GU = oyr.YEAR_GU
JOIN rev.EPC_SCH_YR_CRS        ycrs  ON ycrs.SCHOOL_YEAR_COURSE_GU = sect.SCHOOL_YEAR_COURSE_GU
JOIN rev.EPC_CRS               crs   ON crs.COURSE_GU = ycrs.COURSE_GU
JOIN rev.EPC_SCH               sch   ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_STAFF_SCH_YR      stfsy ON stfsy.STAFF_SCHOOL_YEAR_GU = sect.STAFF_SCHOOL_YEAR_GU
JOIN rev.REV_PERSON            stfp  ON stfp.PERSON_GU = stfsy.STAFF_GU
JOIN rev.EPC_STAFF             stf   ON stf.STAFF_GU = stfsy.STAFF_GU

GO

COMMIT
