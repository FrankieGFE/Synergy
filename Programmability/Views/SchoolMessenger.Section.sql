USE [ST_Production]
GO



SET QUOTED_IDENTIFIER ON
GO




ALTER VIEW [SchoolMessenger].[Section] AS
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
                                        --AND oyr.YEAR_GU = (select YEAR_GU from rev.SIF_22_Common_CurrentYearGU)
								AND 
								(oyr.YEAR_GU=(SELECT [YEAR_GU] FROM [APS].[YearDates] WHERE CAST(GETDATE() AS DATE) BETWEEN [START_DATE] AND [END_DATE] AND EXTENSION != 'R')
								/*AND (oyr.YEAR_GU			 = (SELECT YEAR_GU FROM rev.REV_YEAR WHERE SCHOOL_YEAR=2014 AND EXTENSION='S')
								OR oyr.YEAR_GU			 = (SELECT YEAR_GU FROM rev.REV_YEAR WHERE SCHOOL_YEAR=2015 AND EXTENSION='N'))*/
								OR oyr.YEAR_GU			 = (SELECT YEAR_GU FROM rev.REV_YEAR WHERE SCHOOL_YEAR=2016 AND EXTENSION='R')
								)
								
JOIN rev.REV_YEAR              yr    ON yr.YEAR_GU = oyr.YEAR_GU
JOIN rev.EPC_SCH_YR_CRS        ycrs  ON ycrs.SCHOOL_YEAR_COURSE_GU = sect.SCHOOL_YEAR_COURSE_GU
JOIN rev.EPC_CRS               crs   ON crs.COURSE_GU = ycrs.COURSE_GU
JOIN rev.EPC_SCH               sch   ON sch.ORGANIZATION_GU = oyr.ORGANIZATION_GU
JOIN rev.EPC_STAFF_SCH_YR      stfsy ON stfsy.STAFF_SCHOOL_YEAR_GU = sect.STAFF_SCHOOL_YEAR_GU
JOIN rev.REV_PERSON            stfp  ON stfp.PERSON_GU = stfsy.STAFF_GU
JOIN rev.EPC_STAFF             stf   ON stf.STAFF_GU = stfsy.STAFF_GU






GO


